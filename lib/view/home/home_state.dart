import '../shared/models/exercise.dart';
import '../shared/models/tracking.dart' as tracking_models;

class HomeState {
  const HomeState({
    required this.isAddingWeight,
    required this.isLoggingSet,
    required this.exercises,
    required this.selectedExercise,
    required this.weeklyVolumeFuture,
  });

  factory HomeState.initial() {
    return HomeState(
      isAddingWeight: false,
      isLoggingSet: false,
      exercises: const [],
      selectedExercise: null,
      weeklyVolumeFuture:
          Future<List<tracking_models.WeeklyVolumePoint>>.value(const []),
    );
  }

  final bool isAddingWeight;
  final bool isLoggingSet;
  final List<ExerciseSummary> exercises;
  final ExerciseSummary? selectedExercise;
  final Future<List<tracking_models.WeeklyVolumePoint>> weeklyVolumeFuture;

  HomeState copyWith({
    bool? isAddingWeight,
    bool? isLoggingSet,
    List<ExerciseSummary>? exercises,
    ExerciseSummary? selectedExercise,
    bool setSelectedExercise = false,
    Future<List<tracking_models.WeeklyVolumePoint>>? weeklyVolumeFuture,
  }) {
    return HomeState(
      isAddingWeight: isAddingWeight ?? this.isAddingWeight,
      isLoggingSet: isLoggingSet ?? this.isLoggingSet,
      exercises: exercises ?? this.exercises,
      selectedExercise:
          setSelectedExercise ? selectedExercise : this.selectedExercise,
      weeklyVolumeFuture: weeklyVolumeFuture ?? this.weeklyVolumeFuture,
    );
  }
}
