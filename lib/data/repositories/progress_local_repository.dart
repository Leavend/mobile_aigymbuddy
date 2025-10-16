import 'dart:async';

import 'package:drift/drift.dart';

import '../../domain/entities/progress_models.dart' as progress;
import '../../domain/entities/weight_entry.dart' as weight;
import '../../domain/repositories/progress_repository.dart';
import '../db/app_database.dart';
import '../db/daos/tracking_dao.dart';

class ProgressLocalRepository implements ProgressRepository {
  ProgressLocalRepository(this._db);

  final AppDatabase _db;

  TrackingDao get _trackingDao => _db.trackingDao;
  @override
  Future<weight.WeightEntry> addBodyWeight({
    required double weightKg,
    DateTime? recordedAt,
  }) async {
    final id = await _db.into(_db.bodyWeightEntries).insert(
          BodyWeightEntriesCompanion.insert(
            weightKg: weightKg,
            recordedAt: Value(recordedAt ?? DateTime.now().toUtc()),
          ),
        );
    final row = await (_db.select(_db.bodyWeightEntries)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();
    return weight.WeightEntry(
      id: row.id,
      weightKg: row.weightKg,
      recordedAt: row.recordedAt,
    );
  }

  @override
  Future<List<weight.WeightEntry>> loadBodyWeightHistory({int days = 30}) async {
    final fromDate = DateTime.now().toUtc().subtract(Duration(days: days));
    final query = (_db.select(_db.bodyWeightEntries)
          ..where((tbl) => tbl.recordedAt.isBiggerOrEqualValue(fromDate))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.recordedAt)]));
    final rows = await query.get();
    return rows
        .map(
          (row) => weight.WeightEntry(
            id: row.id,
            weightKg: row.weightKg,
            recordedAt: row.recordedAt,
          ),
        )
        .toList();
  }

  @override
  Stream<List<weight.WeightEntry>> watchBodyWeightHistory({int days = 30}) {
    final fromDate = DateTime.now().toUtc().subtract(Duration(days: days));
    final query = (_db.select(_db.bodyWeightEntries)
          ..where((tbl) => tbl.recordedAt.isBiggerOrEqualValue(fromDate))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.recordedAt)]));
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => weight.WeightEntry(
                  id: row.id,
                  weightKg: row.weightKg,
                  recordedAt: row.recordedAt,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<progress.WeeklyVolumePoint>> loadWeeklyVolume({int weeks = 6}) async {
    final data = await _trackingDao.getWeeklyVolume(weeks);
    return data
        .map(
          (item) => progress.WeeklyVolumePoint(
            weekKey: item.weekKey,
            totalVolume: item.totalVolume,
          ),
        )
        .toList();
  }

  @override
  Stream<List<progress.SessionSummary>> watchRecentSessions({int limit = 10}) {
    final query = _db.customSelectStream(
      '''
SELECT sessions.id AS session_id,
       sessions.started_at AS started_at,
       sessions.ended_at AS ended_at,
       sessions.note AS note,
       workouts.title AS workout_title,
       SUM(COALESCE(set_logs.reps, 0) * COALESCE(set_logs.weight, 0)) AS total_volume,
       COUNT(set_logs.id) AS total_sets
FROM sessions
LEFT JOIN workouts ON workouts.id = sessions.workout_id
LEFT JOIN set_logs ON set_logs.session_id = sessions.id
GROUP BY sessions.id
ORDER BY sessions.started_at DESC
LIMIT ?
''',
      variables: [Variable<int>(limit)],
      readsFrom: {_db.sessions, _db.setLogs, _db.workouts},
    );

    return query.map((row) {
      return progress.SessionSummary(
        id: row.read<int>('session_id'),
        title: row.read<String?>('workout_title') ?? 'Workout',
        startedAt: row.read<DateTime>('started_at'),
        endedAt: row.read<DateTime?>('ended_at'),
        note: row.read<String?>('note'),
        totalVolume: (row.read<double?>('total_volume') ?? 0).toDouble(),
        totalSets: row.read<int>('total_sets'),
      );
    });
  }

  @override
  Stream<List<progress.LoggedSet>> watchSessionSets(int sessionId) {
    final query = _db.customSelectStream(
      '''
SELECT set_logs.id AS set_id,
       set_logs.session_id AS session_id,
       set_logs.set_index AS set_index,
       set_logs.reps AS reps,
       set_logs.weight AS weight,
       set_logs.note AS note,
       exercises.name AS exercise_name
FROM set_logs
INNER JOIN workout_exercises ON workout_exercises.id = set_logs.workout_exercise_id
INNER JOIN exercises ON exercises.id = workout_exercises.exercise_id
WHERE set_logs.session_id = ?
ORDER BY set_logs.set_index ASC
''',
      variables: [Variable<int>(sessionId)],
      readsFrom: {_db.setLogs, _db.workoutExercises, _db.exercises},
    );

    return query.map(
      (row) => progress.LoggedSet(
        id: row.read<int>('set_id'),
        sessionId: row.read<int>('session_id'),
        exerciseName: row.read<String>('exercise_name'),
        setIndex: row.read<int>('set_index'),
        reps: row.read<int?>('reps'),
        weight: row.read<double?>('weight'),
        note: row.read<String?>('note'),
      ),
    );
  }

  @override
  Future<int> startSession({
    required String title,
    String? note,
    required String goal,
    required String level,
    required String mode,
  }) async {
    return _db.transaction(() async {
      final workoutId = await _db.into(_db.workouts).insert(
            WorkoutsCompanion.insert(
              title: title,
              goal: goal,
              level: level,
              mode: mode,
              scheduledFor: const Value(null),
            ),
          );
      final sessionId = await _trackingDao.startSession(workoutId, note: note);
      return sessionId;
    });
  }

  @override
  Future<void> finishSession({required int sessionId, String? note}) async {
    await _trackingDao.endSession(sessionId, note: note);
  }

  @override
  Future<void> addSet({
    required int sessionId,
    required String exerciseName,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  }) async {
    await _db.transaction(() async {
      final session = await (_db.select(_db.sessions)
            ..where((tbl) => tbl.id.equals(sessionId)))
          .getSingle();
      final workoutId = session.workoutId;

      final existingExercise = await (_db.select(_db.exercises)
            ..where((tbl) => tbl.name.equals(exerciseName)))
          .getSingleOrNull();

      final exerciseId = existingExercise?.id ??
          await _db.into(_db.exercises).insert(
                ExercisesCompanion.insert(
                  name: exerciseName,
                  category: 'full',
                  requiresEquipment: const Value(false),
                  equipment: const Value(null),
                  mode: 'both',
                  difficulty: 'beginner',
                ),
              );

      final workoutExercise = await (_db.select(_db.workoutExercises)
            ..where(
              (tbl) => tbl.workoutId.equals(workoutId) & tbl.exerciseId.equals(exerciseId),
            ))
          .getSingleOrNull();

      final workoutExerciseId = workoutExercise?.id ??
          await _db.into(_db.workoutExercises).insert(
                WorkoutExercisesCompanion.insert(
                  workoutId: workoutId,
                  exerciseId: exerciseId,
                  sets: 1,
                  reps: Value(reps),
                  durationSec: const Value(null),
                  restSec: const Value(60),
                ),
              );

      await _trackingDao.insertSetLog(
        sessionId: sessionId,
        workoutExerciseId: workoutExerciseId,
        setIndex: setIndex,
        reps: reps,
        weight: weight,
        note: note,
      );
    });
  }
}
