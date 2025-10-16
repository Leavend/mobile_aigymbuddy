// lib/data/db/daos/workout_dao.dart

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/exercises.dart';
import '../tables/workout_exercises.dart';
import '../tables/workouts.dart';

part 'workout_dao.g.dart';

/// Input helper describing a planned exercise row.
class WorkoutItemInput {
  const WorkoutItemInput({
    required this.exerciseId,
    required this.sets,
    this.reps,
    this.durationSec,
    this.restSec = 60,
  });

  final int exerciseId;
  final int sets;
  final int? reps;
  final int? durationSec;
  final int restSec;
}

/// Result containing the workout and its populated exercises.
class WorkoutPlanWithItems {
  const WorkoutPlanWithItems({required this.workout, required this.items});

  final Workout workout;
  final List<WorkoutPlanItem> items;
}

/// Single plan item with joined exercise metadata.
class WorkoutPlanItem {
  const WorkoutPlanItem({
    required this.workoutExercise,
    required this.exercise,
  });

  final WorkoutExercise workoutExercise;
  final Exercise exercise;
}

/// DAO responsible for workout plan persistence.
@DriftAccessor(tables: [Workouts, WorkoutExercises, Exercises])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  /// Creates a workout plan and its detail rows inside a transaction.
  Future<int> createPlan({
    required String title,
    required String goal,
    required String level,
    required String mode,
    DateTime? scheduledFor,
    required List<WorkoutItemInput> items,
  }) {
    return transaction(() async {
      final workoutId = await into(workouts).insert(
        WorkoutsCompanion.insert(
          title: title,
          goal: goal,
          level: level,
          mode: mode,
          scheduledFor: Value(scheduledFor),
        ),
      );

      if (items.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(
            workoutExercises,
            items
                .map(
                  (item) => WorkoutExercisesCompanion.insert(
                    workoutId: workoutId,
                    exerciseId: item.exerciseId,
                    sets: item.sets,
                    reps: Value(item.reps),
                    durationSec: Value(item.durationSec),
                    restSec: Value(item.restSec),
                  ),
                )
                .toList(),
          );
        });
      }

      return workoutId;
    });
  }

  /// Fetches a plan along with the detailed exercises.
  Future<WorkoutPlanWithItems?> getPlanWithItems(int workoutId) async {
    final workout = await (select(
      workouts,
    )..where((tbl) => tbl.id.equals(workoutId)))
        .getSingleOrNull();

    if (workout == null) {
      return null;
    }

    final joined = await (select(
      workoutExercises,
    )..where((tbl) => tbl.workoutId.equals(workoutId)))
        .join([
      innerJoin(
        exercises,
        exercises.id.equalsExp(workoutExercises.exerciseId),
      ),
    ]).get();

    final items = joined
        .map(
          (row) => WorkoutPlanItem(
            workoutExercise: row.readTable(workoutExercises),
            exercise: row.readTable(exercises),
          ),
        )
        .toList();

    return WorkoutPlanWithItems(workout: workout, items: items);
  }
}
