import 'package:flutter/foundation.dart';

/// Collection of strongly typed navigation argument models used by [GoRouter].
///
/// Using dedicated data classes instead of loosely typed `Map` extras helps us
/// avoid runtime type errors and keeps the router declarations clean.
@immutable
class AddScheduleArgs {
  const AddScheduleArgs({required this.date});

  final DateTime date;

  @override
  String toString() => 'AddScheduleArgs(date: $date)';
}

@immutable
class WorkoutDetailArgs {
  const WorkoutDetailArgs({required this.workout});

  final Map<String, dynamic> workout;

  @override
  String toString() => 'WorkoutDetailArgs(workout: $workout)';
}

@immutable
class ExerciseStepsArgs {
  const ExerciseStepsArgs({required this.exercise});

  final Map<String, dynamic> exercise;

  @override
  String toString() => 'ExerciseStepsArgs(exercise: $exercise)';
}

@immutable
class MealFoodDetailsArgs {
  const MealFoodDetailsArgs({required this.food});

  final Map<String, dynamic> food;

  @override
  String toString() => 'MealFoodDetailsArgs(food: $food)';
}

@immutable
class FoodInfoArgs {
  const FoodInfoArgs({required this.meal, required this.food});

  final Map<String, dynamic> meal;
  final Map<String, dynamic> food;

  @override
  String toString() => 'FoodInfoArgs(meal: $meal, food: $food)';
}

@immutable
class PhotoResultArgs {
  const PhotoResultArgs({required this.firstDate, required this.secondDate});

  final DateTime firstDate;
  final DateTime secondDate;

  @override
  String toString() =>
      'PhotoResultArgs(firstDate: $firstDate, secondDate: $secondDate)';
}

@immutable
class SleepAddAlarmArgs {
  const SleepAddAlarmArgs({required this.date});

  final DateTime date;

  @override
  String toString() => 'SleepAddAlarmArgs(date: $date)';
}
