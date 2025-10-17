// lib/view/shared/repositories/drift_workout_repository.dart

import 'package:drift/drift.dart';

import '../../../common/date_time_utils.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/daos/dao_utils.dart';
import '../../../data/db/daos/workout_dao.dart';
import '../models/workout.dart';
import 'workout_repository.dart';

class DriftWorkoutRepository implements WorkoutRepository {
  DriftWorkoutRepository(this._db, this._workoutDao);

  final AppDatabase _db;
  final WorkoutDao _workoutDao;

  @override
  Stream<List<WorkoutOverview>> watchUpcomingWorkouts({
    DateTime? from,
    int limit = 5,
  }) {
    final now = ensureUtc(from ?? DateTime.now());

    final query = _db.select(_db.workouts).join([
      leftOuterJoin(
        _db.workoutExercises,
        _db.workoutExercises.workoutId.equalsExp(_db.workouts.id),
      ),
    ]);

    query
      ..where(_db.workouts.scheduledFor.isBiggerOrEqualValue(now))
      ..orderBy([
        OrderingTerm.asc(_db.workouts.scheduledFor),
        OrderingTerm.asc(_db.workouts.id),
      ]);

    return query.watch().map((rows) {
      final aggregated = _aggregateWorkouts(rows);
      aggregated.sort(
        (a, b) => (a.scheduledFor ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(
                b.scheduledFor ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
      return aggregated.take(limit).toList(growable: false);
    });
  }

  @override
  Stream<List<WorkoutOverview>> watchRecommendations({int limit = 6}) {
    final query = _db.select(_db.workouts).join([
      leftOuterJoin(
        _db.workoutExercises,
        _db.workoutExercises.workoutId.equalsExp(_db.workouts.id),
      ),
    ]);

    query
      ..where(_db.workouts.scheduledFor.isNull())
      ..orderBy([
        OrderingTerm.desc(_db.workouts.createdAt),
        OrderingTerm.asc(_db.workouts.id),
      ]);

    return query.watch().map((rows) {
      final aggregated = _aggregateWorkouts(rows);
      aggregated.sort(
        (a, b) => b.id.compareTo(a.id),
      );
      return aggregated.take(limit).toList(growable: false);
    });
  }

  @override
  Stream<List<WorkoutOverview>> watchWorkoutsForDay(DateTime day) {
    final startUtc = ensureUtc(DateTimeUtils.startOfDay(day));
    final endUtc = startUtc.add(const Duration(days: 1));

    final query = _db.select(_db.workouts).join([
      leftOuterJoin(
        _db.workoutExercises,
        _db.workoutExercises.workoutId.equalsExp(_db.workouts.id),
      ),
    ]);

    query
      ..where(
        _db.workouts.scheduledFor.isBiggerOrEqualValue(startUtc) &
            _db.workouts.scheduledFor.isSmallerThanValue(endUtc),
      )
      ..orderBy([
        OrderingTerm.asc(_db.workouts.scheduledFor),
        OrderingTerm.asc(_db.workouts.id),
      ]);

    return query.watch().map(_aggregateWorkouts);
  }

  @override
  Future<int> createQuickSchedule(WorkoutScheduleDraft draft) {
    return _workoutDao.createPlan(
      title: draft.title,
      goal: draft.goal.dbValue,
      level: draft.level.dbValue,
      mode: draft.environment.dbValue,
      scheduledFor: draft.scheduledFor,
      items: const <WorkoutItemInput>[],
    );
  }

  @override
  Future<void> completeWorkout(int workoutId) {
    return (_db.update(_db.workouts)..where((tbl) => tbl.id.equals(workoutId)))
        .write(const WorkoutsCompanion(scheduledFor: Value(null)));
  }

  @override
  Future<WorkoutDetail?> loadWorkoutDetail(int workoutId) async {
    final plan = await _workoutDao.getPlanWithItems(workoutId);
    if (plan == null) {
      return null;
    }

    final exercises = plan.items
        .map(
          (item) => WorkoutExerciseDetail(
            workoutExerciseId: item.workoutExercise.id,
            name: item.exercise.name,
            category: item.exercise.category,
            difficulty: item.exercise.difficulty,
            mode: item.exercise.mode,
            sets: item.workoutExercise.sets,
            rest: item.workoutExercise.restSec,
            reps: item.workoutExercise.reps,
            duration: item.workoutExercise.durationSec == null
                ? null
                : Duration(seconds: item.workoutExercise.durationSec!),
          ),
        )
        .toList(growable: false);

    final estimatedDuration = exercises
        .map((exercise) => exercise.duration)
        .whereType<Duration>()
        .fold<Duration>(
          Duration.zero,
          (previousValue, element) => previousValue + element,
        );

    final overview = WorkoutOverview(
      id: plan.workout.id,
      title: plan.workout.title,
      goal: WorkoutGoalX.fromDb(plan.workout.goal),
      level: WorkoutLevelX.fromDb(plan.workout.level),
      environment: WorkoutEnvironmentX.fromDb(plan.workout.mode),
      scheduledFor: plan.workout.scheduledFor?.toLocal(),
      exerciseCount: exercises.length,
      estimatedDuration:
          estimatedDuration == Duration.zero ? null : estimatedDuration,
    );

    return WorkoutDetail(overview: overview, exercises: exercises);
  }

  List<WorkoutOverview> _aggregateWorkouts(List<TypedResult> rows) {
    final Map<int, _WorkoutAccumulator> accumulator = {};
    for (final row in rows) {
      final workout = row.readTable(_db.workouts);
      final exercisesRow = row.readTableOrNull(_db.workoutExercises);

      final agg = accumulator.putIfAbsent(
        workout.id,
        () => _WorkoutAccumulator(workout),
      );
      if (exercisesRow != null) {
        agg.addExercise(exercisesRow);
      }
    }

    return accumulator.values
        .map((value) => value.toOverview())
        .toList(growable: false);
  }
}

class _WorkoutAccumulator {
  _WorkoutAccumulator(this.row);

  final Workout row;
  int exerciseCount = 0;
  int totalDurationSeconds = 0;

  void addExercise(WorkoutExercise exercise) {
    exerciseCount += 1;
    if (exercise.durationSec != null) {
      totalDurationSeconds += exercise.durationSec!;
    }
  }

  WorkoutOverview toOverview() {
    return WorkoutOverview(
      id: row.id,
      title: row.title,
      goal: WorkoutGoalX.fromDb(row.goal),
      level: WorkoutLevelX.fromDb(row.level),
      environment: WorkoutEnvironmentX.fromDb(row.mode),
      scheduledFor: row.scheduledFor?.toLocal(),
      exerciseCount: exerciseCount == 0 ? null : exerciseCount,
      estimatedDuration: totalDurationSeconds == 0
          ? null
          : Duration(seconds: totalDurationSeconds),
    );
  }
}
