// lib/view/shared/repositories/workout_repository.dart

import '../models/workout.dart';

/// Abstraction used by the workout tracker feature to interact with Drift.
abstract class WorkoutRepository {
  /// Watches upcoming workouts ordered by the scheduled date.
  Stream<List<WorkoutOverview>> watchUpcomingWorkouts({
    DateTime? from,
    int limit = 5,
  });

  /// Watches recommended workouts that are currently unscheduled.
  Stream<List<WorkoutOverview>> watchRecommendations({int limit = 6});

  /// Watches workouts scheduled for a specific [day].
  Stream<List<WorkoutOverview>> watchWorkoutsForDay(DateTime day);

  /// Persists a new workout based on a quick schedule draft.
  Future<int> createQuickSchedule(WorkoutScheduleDraft draft);

  /// Marks the workout as completed, clearing its schedule.
  Future<void> completeWorkout(int workoutId);

  /// Loads a workout with its planned exercises.
  Future<WorkoutDetail?> loadWorkoutDetail(int workoutId);
}
