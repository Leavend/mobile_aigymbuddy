// lib/database/daos/workout_plans_dao.dart

part of '../app_db.dart';

class PlanDayWithExercises {

  PlanDayWithExercises(this.day, this.items);
  final WorkoutPlanDay day;
  final List<(WorkoutPlanExercise, Exercise)> items;
}

@DriftAccessor(
  tables: [WorkoutPlans, WorkoutPlanDays, WorkoutPlanExercises, Exercises],
)
class WorkoutPlansDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutPlansDaoMixin {
  WorkoutPlansDao(super.db);

  // Method ini sudah benar
  Future<WorkoutPlan?> getActivePlan(String userId) {
    return (select(workoutPlans)
          ..where((w) => w.userId.equals(userId) & w.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<List<PlanDayWithExercises>> getPlanDaysWithExercises(
    String planId,
  ) async {
    final query =
        select(workoutPlanDays).join([
            innerJoin(
              workoutPlanExercises,
              workoutPlanExercises.planDayId.equalsExp(workoutPlanDays.id),
            ),
            innerJoin(
              exercises,
              exercises.id.equalsExp(workoutPlanExercises.exerciseId),
            ),
          ])
          ..where(workoutPlanDays.planId.equals(planId))
          ..orderBy([OrderingTerm.asc(workoutPlanDays.dayIndex)]);

    final rows = await query.get();

    final groupedData =
        <WorkoutPlanDay, List<(WorkoutPlanExercise, Exercise)>>{};

    for (final row in rows) {
      final day = row.readTable(workoutPlanDays);
      final planExercise = row.readTable(workoutPlanExercises);
      final exercise = row.readTable(exercises);

      final list = groupedData.putIfAbsent(day, () => []);
      list.add((planExercise, exercise));
    }

    return groupedData.entries
        .map((entry) => PlanDayWithExercises(entry.key, entry.value))
        .toList();
  }
}
