import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/body_weight_entries.dart';
import '../tables/sessions.dart';
import '../tables/set_logs.dart';
import '../tables/workout_exercises.dart';

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

/// DAO working with workout sessions, set logs, and weight entries.
@DriftAccessor(tables: [Sessions, SetLogs, WorkoutExercises, BodyWeightEntries])
class TrackingDao extends DatabaseAccessor<AppDatabase>
    with _$TrackingDaoMixin {
  TrackingDao(AppDatabase db) : super(db);

  /// Creates a session for the given [workoutId].
  Future<int> startSession(int workoutId) {
    return into(sessions).insert(SessionsCompanion.insert(workoutId: workoutId));
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
    return into(setLogs).insert(SetLogsCompanion.insert(
      sessionId: sessionId,
      workoutExerciseId: workoutExerciseId,
      setIndex: setIndex,
      reps: Value(reps),
      weight: Value(weight),
      note: Value(note),
    ));
  }

  /// Records a body weight entry at the current timestamp.
  Future<int> insertBodyWeight(double weightKg) {
    return into(bodyWeightEntries)
        .insert(BodyWeightEntriesCompanion.insert(weightKg: weightKg));
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
}
