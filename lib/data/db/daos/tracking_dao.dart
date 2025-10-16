// lib/data/db/daos/tracking_dao.dart

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/body_weight_entries.dart';
import '../tables/exercises.dart';
import '../tables/sessions.dart';
import '../tables/set_logs.dart';
import '../tables/workout_exercises.dart';
import '../tables/workouts.dart';

part 'tracking_dao.g.dart';

/// Aggregated weekly training volume value object.
class WeeklyVolume {
  const WeeklyVolume({required this.weekKey, required this.totalVolume});

  final String weekKey;
  final double totalVolume;
}

/// Historical weight entry value object.
class WeightPoint {
  const WeightPoint({required this.recordedAt, required this.weightKg});

  final DateTime recordedAt;
  final double weightKg;
}

/// Result of joining set logs with exercises and sessions.
class RecentSetLogRow {
  const RecentSetLogRow({
    required this.id,
    required this.exerciseName,
    required this.setIndex,
    required this.startedAt,
    this.reps,
    this.weight,
    this.note,
  });

  final int id;
  final String exerciseName;
  final int setIndex;
  final DateTime startedAt;
  final int? reps;
  final double? weight;
  final String? note;
}

/// DAO working with workout sessions, set logs, and weight entries.
@DriftAccessor(
  tables: [
    Sessions,
    SetLogs,
    WorkoutExercises,
    BodyWeightEntries,
    Workouts,
    Exercises,
  ],
)
class TrackingDao extends DatabaseAccessor<AppDatabase>
    with _$TrackingDaoMixin {
  TrackingDao(super.db);

  /// Inserts a manual workout, session and set log for ad-hoc tracking.
  Future<void> insertManualSet({
    required int exerciseId,
    required int setIndex,
    required String goal,
    required String level,
    required String mode,
    int? reps,
    double? weight,
    String? note,
  }) {
    return transaction(() async {
      final now = DateTime.now().toUtc();
      final workoutId = await into(workouts).insert(
        WorkoutsCompanion.insert(
          title: 'Manual Log',
          goal: goal,
          level: level,
          mode: mode,
          scheduledFor: Value(now),
        ),
      );

      final workoutExerciseId = await into(workoutExercises).insert(
        WorkoutExercisesCompanion.insert(
          workoutId: workoutId,
          exerciseId: exerciseId,
          sets: 1,
          reps: Value(reps),
        ),
      );

      final sessionId = await into(sessions).insert(
        SessionsCompanion.insert(
          workoutId: workoutId,
          startedAt: Value(now),
          note: Value(note),
        ),
      );

      await into(setLogs).insert(
        SetLogsCompanion.insert(
          sessionId: sessionId,
          workoutExerciseId: workoutExerciseId,
          setIndex: setIndex,
          reps: Value(reps),
          weight: Value(weight),
          note: Value(note),
        ),
      );

      await (update(sessions)..where((tbl) => tbl.id.equals(sessionId))).write(
        SessionsCompanion(endedAt: Value(now)),
      );
    });
  }

  /// Creates a session for the given [workoutId].
  Future<int> startSession(int workoutId) {
    return into(
      sessions,
    ).insert(SessionsCompanion.insert(workoutId: workoutId));
  }

  /// Sets the session [endedAt] timestamp to now.
  Future<void> endSession(int sessionId) {
    return (update(sessions)..where((tbl) => tbl.id.equals(sessionId))).write(
      SessionsCompanion(endedAt: Value(DateTime.now().toUtc())),
    );
  }

  /// Inserts a log for the performed set.
  Future<int> insertSetLog({
    required int sessionId,
    required int workoutExerciseId,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  }) {
    return into(setLogs).insert(
      SetLogsCompanion.insert(
        sessionId: sessionId,
        workoutExerciseId: workoutExerciseId,
        setIndex: setIndex,
        reps: Value(reps),
        weight: Value(weight),
        note: Value(note),
      ),
    );
  }

  /// Records a body weight entry at the current timestamp.
  Future<int> insertBodyWeight(double weightKg) {
    return into(
      bodyWeightEntries,
    ).insert(BodyWeightEntriesCompanion.insert(weightKg: weightKg));
  }

  /// Calculates aggregated weekly training volume for the last [weeks].
  Future<List<WeeklyVolume>> getWeeklyVolume(int weeks) async {
    if (weeks <= 0) {
      return const [];
    }

    final fromDate = DateTime.now().toUtc().subtract(Duration(days: weeks * 7));

    final rows = await customSelect(
      '''
SELECT strftime('%Y-%W', sessions.started_at) AS week_key,
       SUM(COALESCE(set_logs.reps, 0) * COALESCE(set_logs.weight, 0)) AS total_volume
FROM set_logs
INNER JOIN sessions ON sessions.id = set_logs.session_id
WHERE sessions.started_at >= ?
GROUP BY week_key
ORDER BY week_key ASC
''',
      variables: [Variable<String>(fromDate.toIso8601String())],
      readsFrom: {setLogs, sessions},
    ).get();

    return rows
        .map(
          (row) => WeeklyVolume(
            weekKey: row.read<String>('week_key'),
            totalVolume: (row.read<double?>('total_volume') ?? 0).toDouble(),
          ),
        )
        .toList();
  }

  /// Retrieves weight entries ordered ascending by date within the last [days].
  Future<List<WeightPoint>> getWeightSeries({int days = 30}) async {
    final fromDate = DateTime.now().toUtc().subtract(Duration(days: days));

    final results = await (select(bodyWeightEntries)
          ..where((tbl) => tbl.recordedAt.isBiggerOrEqualValue(fromDate))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.recordedAt)]))
        .get();

    return results
        .map(
          (entry) => WeightPoint(
            recordedAt: entry.recordedAt,
            weightKg: entry.weightKg,
          ),
        )
        .toList();
  }

  /// Watches weight entries ordered ascending by date within the last [days].
  Stream<List<WeightPoint>> watchWeightSeries({int days = 30}) {
    final fromDate = DateTime.now().toUtc().subtract(Duration(days: days));
    final query = (select(bodyWeightEntries)
          ..where((tbl) => tbl.recordedAt.isBiggerOrEqualValue(fromDate))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.recordedAt)]))
        .watch();

    return query.map(
      (rows) => rows
          .map(
            (row) => WeightPoint(
              recordedAt: row.recordedAt,
              weightKg: row.weightKg,
            ),
          )
          .toList(),
    );
  }

  /// Watches the latest set logs with exercise information.
  Stream<List<RecentSetLogRow>> watchRecentSetLogs({int limit = 20}) {
    final selectable = customSelect(
      '''
SELECT set_logs.id AS set_log_id,
       set_logs.set_index AS set_index,
       set_logs.reps AS reps,
       set_logs.weight AS weight,
       set_logs.note AS note,
       sessions.started_at AS started_at,
       exercises.name AS exercise_name
FROM set_logs
INNER JOIN sessions ON sessions.id = set_logs.session_id
INNER JOIN workout_exercises ON workout_exercises.id = set_logs.workout_exercise_id
INNER JOIN exercises ON exercises.id = workout_exercises.exercise_id
ORDER BY sessions.started_at DESC, set_logs.set_index DESC
LIMIT ?
''',
      variables: [Variable<int>(limit)],
      readsFrom: {setLogs, sessions, workoutExercises, exercises},
    );

    return selectable.watch().map(
          (rows) => rows
              .map(
                (row) => RecentSetLogRow(
                  id: row.read<int>('set_log_id'),
                  exerciseName: row.read<String>('exercise_name'),
                  setIndex: row.read<int>('set_index'),
                  startedAt: row.read<DateTime>('started_at'),
                  reps: row.read<int?>('reps'),
                  weight: row.read<double?>('weight'),
                  note: row.read<String?>('note'),
                ),
              )
              .toList(),
        );
  }
}
