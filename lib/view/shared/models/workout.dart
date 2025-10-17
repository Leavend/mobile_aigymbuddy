// lib/view/shared/models/workout.dart

import 'package:flutter/foundation.dart';

/// Goals supported by workout plans inside the offline database.
enum WorkoutGoal { loseWeight, buildMuscle, endurance }

/// Difficulty levels a workout can target.
enum WorkoutLevel { beginner, intermediate, advanced }

/// Environment where the workout should be performed.
enum WorkoutEnvironment { home, gym }

extension WorkoutGoalX on WorkoutGoal {
  String get dbValue {
    switch (this) {
      case WorkoutGoal.loseWeight:
        return 'lose_weight';
      case WorkoutGoal.buildMuscle:
        return 'build_muscle';
      case WorkoutGoal.endurance:
        return 'endurance';
    }
  }

  static WorkoutGoal fromDb(String value) {
    switch (value) {
      case 'lose_weight':
        return WorkoutGoal.loseWeight;
      case 'build_muscle':
        return WorkoutGoal.buildMuscle;
      case 'endurance':
        return WorkoutGoal.endurance;
      default:
        throw ArgumentError.value(value, 'value', 'Unknown workout goal');
    }
  }
}

extension WorkoutLevelX on WorkoutLevel {
  String get dbValue {
    switch (this) {
      case WorkoutLevel.beginner:
        return 'beginner';
      case WorkoutLevel.intermediate:
        return 'intermediate';
      case WorkoutLevel.advanced:
        return 'advanced';
    }
  }

  static WorkoutLevel fromDb(String value) {
    switch (value) {
      case 'beginner':
        return WorkoutLevel.beginner;
      case 'intermediate':
        return WorkoutLevel.intermediate;
      case 'advanced':
        return WorkoutLevel.advanced;
      default:
        throw ArgumentError.value(value, 'value', 'Unknown workout level');
    }
  }
}

extension WorkoutEnvironmentX on WorkoutEnvironment {
  String get dbValue {
    switch (this) {
      case WorkoutEnvironment.home:
        return 'home';
      case WorkoutEnvironment.gym:
        return 'gym';
    }
  }

  static WorkoutEnvironment fromDb(String value) {
    switch (value) {
      case 'home':
        return WorkoutEnvironment.home;
      case 'gym':
        return WorkoutEnvironment.gym;
      default:
        throw ArgumentError.value(value, 'value', 'Unknown environment');
    }
  }
}

/// Lightweight projection of a workout used across the tracker screens.
@immutable
class WorkoutOverview {
  const WorkoutOverview({
    required this.id,
    required this.title,
    required this.goal,
    required this.level,
    required this.environment,
    this.scheduledFor,
    this.exerciseCount,
    this.estimatedDuration,
  });

  final int id;
  final String title;
  final WorkoutGoal goal;
  final WorkoutLevel level;
  final WorkoutEnvironment environment;
  final DateTime? scheduledFor;
  final int? exerciseCount;
  final Duration? estimatedDuration;

  WorkoutOverview copyWith({
    int? id,
    String? title,
    WorkoutGoal? goal,
    WorkoutLevel? level,
    WorkoutEnvironment? environment,
    DateTime? scheduledFor,
    bool keepScheduledFor = false,
    int? exerciseCount,
    bool keepExerciseCount = false,
    Duration? estimatedDuration,
    bool keepEstimatedDuration = false,
  }) {
    return WorkoutOverview(
      id: id ?? this.id,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      environment: environment ?? this.environment,
      scheduledFor: keepScheduledFor
          ? this.scheduledFor
          : (scheduledFor ?? this.scheduledFor),
      exerciseCount: keepExerciseCount
          ? this.exerciseCount
          : (exerciseCount ?? this.exerciseCount),
      estimatedDuration: keepEstimatedDuration
          ? this.estimatedDuration
          : (estimatedDuration ?? this.estimatedDuration),
    );
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        goal,
        level,
        environment,
        scheduledFor,
        exerciseCount,
        estimatedDuration,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkoutOverview &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            title == other.title &&
            goal == other.goal &&
            level == other.level &&
            environment == other.environment &&
            scheduledFor == other.scheduledFor &&
            exerciseCount == other.exerciseCount &&
            estimatedDuration == other.estimatedDuration;
  }

  @override
  String toString() {
    return 'WorkoutOverview(id: $id, title: $title, goal: $goal, level: $level, '
        'environment: $environment, scheduledFor: $scheduledFor, '
        'exerciseCount: $exerciseCount, estimatedDuration: $estimatedDuration)';
  }
}

/// Detailed information about a workout including its planned exercises.
@immutable
class WorkoutDetail {
  const WorkoutDetail({required this.overview, required this.exercises});

  final WorkoutOverview overview;
  final List<WorkoutExerciseDetail> exercises;
}

/// Individual exercise planned inside a workout.
@immutable
class WorkoutExerciseDetail {
  const WorkoutExerciseDetail({
    required this.workoutExerciseId,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.mode,
    required this.sets,
    required this.rest,
    this.reps,
    this.duration,
  });

  final int workoutExerciseId;
  final String name;
  final String category;
  final String difficulty;
  final String mode;
  final int sets;
  final int rest;
  final int? reps;
  final Duration? duration;
}

/// Draft payload when the user schedules a quick workout from the UI.
@immutable
class WorkoutScheduleDraft {
  const WorkoutScheduleDraft({
    required this.title,
    required this.goal,
    required this.level,
    required this.environment,
    required this.scheduledFor,
    this.notes,
  });

  final String title;
  final WorkoutGoal goal;
  final WorkoutLevel level;
  final WorkoutEnvironment environment;
  final DateTime scheduledFor;
  final String? notes;
}
