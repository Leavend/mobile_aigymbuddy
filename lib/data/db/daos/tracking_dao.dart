// lib/data/db/daos/tracking_dao.dart

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/body_weight_entries.dart';
import '../tables/exercises.dart';
import '../tables/sessions.dart';
import '../tables/set_logs.dart';
import '../tables/workout_exercises.dart';
import '../tables/workouts.dart';
import 'dao_utils.dart';

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
  // ignore: use_super_parameters
  TrackingDao(AppDatabase db, {UtcNow now = defaultUtcNow})
      : _now = now,
        super(db);

  final UtcNow _now;

  DateTime get _utcNow => _now();

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
    if (setIndex <= 0) {
      throw ArgumentError.value(setIndex, 'setIndex', 'Must be greater than 0');
    }

    return transaction(() async {
      final now = _utcNow;
      final workoutId = await _insertManualWorkout(
        goal: goal,
        level: level,
        mode: mode,
        scheduledFor: now,
      );

      final workoutExerciseId = await _insertManualWorkoutExercise(
        workoutId: workoutId,
        exerciseId: exerciseId,
        reps: reps,
      );

      final sessionId = await _startSession(
        workoutId,
        startedAt: now,
        note: note,
      );

      await _insertSetLog(
        sessionId: sessionId,
        workoutExerciseId: workoutExerciseId,
        setIndex: setIndex,
        reps: reps,
        weight: weight,
        note: note,
      );

      await _completeSession(sessionId, endedAt: now);
    });
  }

  /// Creates a session for the given [workoutId].
  Future<int> startSession(int workoutId, {DateTime? startedAt}) {
    final timestamp = startedAt ?? _utcNow;
    return into(sessions).insert(
      SessionsCompanion.insert(
        workoutId: workoutId,
        startedAt: Value(timestamp),
      ),
    );
  }

  /// Sets the session [endedAt] timestamp to now.
  Future<void> endSession(int sessionId) {
    return _completeSession(sessionId, endedAt: _utcNow);
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
    return _insertSetLog(
      sessionId: sessionId,
      workoutExerciseId: workoutExerciseId,
      setIndex: setIndex,
      reps: reps,
      weight: weight,
      note: note,
    );
  }

  /// Records a body weight entry at the current timestamp.
  Future<int> insertBodyWeight(double weightKg) {
    return into(bodyWeightEntries).insert(
      BodyWeightEntriesCompanion.insert(
        weightKg: weightKg,
        recordedAt: Value(_utcNow),
      ),
    );
  }

  /// Calculates aggregated weekly training volume for the last [weeks].
  Future<List<WeeklyVolume>> getWeeklyVolume(int weeks) async {
    if (weeks <= 0) {
      return const [];
    }

    final fromDate = subtractDays(_now, weeks * 7);

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
      variables: [Variable<DateTime>(fromDate)],
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
    final fromDate = subtractDays(_now, days);

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
    final fromDate = subtractDays(_now, days);
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
    final resolvedLimit = resolvePositiveLimit(limit, fallback: 20);
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
      variables: [Variable<int>(resolvedLimit)],
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

  Future<int> _insertManualWorkout({
    required String goal,
    required String level,
    required String mode,
    required DateTime scheduledFor,
  }) {
    return into(workouts).insert(
      WorkoutsCompanion.insert(
        title: 'Manual Log',
        goal: goal,
        level: level,
        mode: mode,
        scheduledFor: Value(scheduledFor),
      ),
    );
  }

  Future<int> _insertManualWorkoutExercise({
    required int workoutId,
    required int exerciseId,
    int? reps,
  }) {
    return into(workoutExercises).insert(
      WorkoutExercisesCompanion.insert(
        workoutId: workoutId,
        exerciseId: exerciseId,
        sets: 1,
        reps: Value(reps),
      ),
    );
  }

  Future<void> _completeSession(int sessionId, {required DateTime endedAt}) {
    return (update(sessions)..where((tbl) => tbl.id.equals(sessionId))).write(
      SessionsCompanion(endedAt: Value(endedAt)),
    );
  }

  Future<int> _startSession(
    int workoutId, {
    required DateTime startedAt,
    String? note,
  }) {
    return into(sessions).insert(
      SessionsCompanion.insert(
        workoutId: workoutId,
        startedAt: Value(startedAt),
        note: Value(note),
      ),
    );
  }

  Future<int> _insertSetLog({
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
}
