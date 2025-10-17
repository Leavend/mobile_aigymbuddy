// lib/view/workout_tracker/workout_visuals.dart

import '../shared/models/workout.dart';

class WorkoutVisuals {
  const WorkoutVisuals._();

  static String coverImageFor(WorkoutGoal goal) {
    switch (goal) {
      case WorkoutGoal.loseWeight:
        return 'assets/img/Workout1.png';
      case WorkoutGoal.buildMuscle:
        return 'assets/img/Workout2.png';
      case WorkoutGoal.endurance:
        return 'assets/img/Workout3.png';
    }
  }

  static String trainingImageFor(WorkoutGoal goal) {
    switch (goal) {
      case WorkoutGoal.loseWeight:
        return 'assets/img/what_1.png';
      case WorkoutGoal.buildMuscle:
        return 'assets/img/what_2.png';
      case WorkoutGoal.endurance:
        return 'assets/img/what_3.png';
    }
  }

  static String exerciseImageForCategory(String category) {
    switch (category) {
      case 'upper':
        return 'assets/img/img_2.png';
      case 'lower':
        return 'assets/img/img_1.png';
      case 'core':
        return 'assets/img/img_1.png';
      case 'full':
      default:
        return 'assets/img/img_2.png';
    }
  }
}
