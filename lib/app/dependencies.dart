// lib/app/dependencies.dart

import 'package:flutter/widgets.dart';

import '../data/db/app_database.dart';
import '../view/shared/repositories/drift_exercise_repository.dart';
import '../view/shared/repositories/drift_profile_repository.dart';
import '../view/shared/repositories/drift_tracking_repository.dart';
import '../view/shared/repositories/exercise_repository.dart';
import '../view/shared/repositories/profile_repository.dart';
import '../view/shared/repositories/tracking_repository.dart';

/// Aggregates repositories and exposes them through the widget tree.
class AppDependencies extends InheritedWidget {
  const AppDependencies._({
    super.key,
    required this.profileRepository,
    required this.exerciseRepository,
    required this.trackingRepository,
    required super.child,
  });

  factory AppDependencies({
    Key? key,
    required AppDatabase database,
    required Widget child,
  }) {
    final profileRepo = DriftProfileRepository(database.userProfileDao);
    return AppDependencies._(
      key: key,
      profileRepository: profileRepo,
      exerciseRepository: DriftExerciseRepository(database.exerciseDao),
      trackingRepository: DriftTrackingRepository(
        database.trackingDao,
        profileRepo,
        database.exerciseDao,
      ),
      child: child,
    );
  }

  final ProfileRepository profileRepository;
  final ExerciseRepository exerciseRepository;
  final TrackingRepository trackingRepository;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(scope != null, 'AppDependencies not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) => false;
}
