// lib/app/dependencies.dart

import 'package:flutter/widgets.dart';

import '../data/db/app_database.dart';
import '../view/shared/repositories/drift_exercise_repository.dart';
import '../data/db/daos/meal_planner_dao.dart';
import '../view/shared/repositories/drift_meal_planner_repository.dart';
import '../view/shared/repositories/drift_profile_repository.dart';
import '../view/shared/repositories/drift_tracking_repository.dart';
import '../view/shared/repositories/exercise_repository.dart';
import '../view/shared/repositories/meal_planner_repository.dart';
import '../view/shared/repositories/profile_repository.dart';
import '../view/shared/repositories/tracking_repository.dart';

/// Aggregates repositories and exposes them through the widget tree.
class AppDependencies extends InheritedWidget {
  const AppDependencies._({
    super.key,
    required this.profileRepository,
    required this.exerciseRepository,
    required this.trackingRepository,
    required this.mealPlannerRepository,
    required super.child,
  });

  factory AppDependencies({
    Key? key,
    required AppDatabase database,
    required Widget child,
  }) {
    final profileRepo = DriftProfileRepository(database.userProfileDao);
    final mealPlannerRepository =
        DriftMealPlannerRepository(MealPlannerStore(database));
    return AppDependencies._(
      key: key,
      profileRepository: profileRepo,
      exerciseRepository: DriftExerciseRepository(database.exerciseDao),
      trackingRepository: DriftTrackingRepository(
        database.trackingDao,
        profileRepo,
        database.exerciseDao,
      ),
      mealPlannerRepository: mealPlannerRepository,
      child: child,
    );
  }

  final ProfileRepository profileRepository;
  final ExerciseRepository exerciseRepository;
  final TrackingRepository trackingRepository;
  final MealPlannerRepository mealPlannerRepository;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(scope != null, 'AppDependencies not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) => false;
}
