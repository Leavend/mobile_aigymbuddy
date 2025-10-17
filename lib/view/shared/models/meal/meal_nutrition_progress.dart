// lib/view/shared/models/meal/meal_nutrition_progress.dart

import 'package:flutter/foundation.dart';

/// Represents the daily completion percentage for nutrition targets.
@immutable
class MealNutritionProgressPoint {
  const MealNutritionProgressPoint({
    required this.day,
    required this.completion,
  }) : assert(completion >= 0 && completion <= 1,
            'Completion should be a normalized value between 0 and 1');

  final DateTime day;
  final double completion;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MealNutritionProgressPoint &&
            runtimeType == other.runtimeType &&
            day == other.day &&
            completion == other.completion;
  }

  @override
  int get hashCode => Object.hash(day, completion);

  @override
  String toString() =>
      'MealNutritionProgressPoint(day: $day, completion: $completion)';
}
