import 'package:flutter/widgets.dart';

import '../data/db/app_database.dart';
import '../features/exercise/data/drift_exercise_repository.dart';
import '../features/exercise/domain/exercise_repository.dart';
import '../features/profile/data/drift_profile_repository.dart';
import '../features/profile/domain/profile_repository.dart';
import '../features/tracking/data/drift_tracking_repository.dart';
import '../features/tracking/domain/tracking_repository.dart';

/// Aggregates repositories and exposes them through the widget tree.
class AppDependencies extends InheritedWidget {
  AppDependencies._({
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
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(scope != null, 'AppDependencies not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) => false;
}
