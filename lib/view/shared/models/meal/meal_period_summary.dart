// lib/view/shared/models/meal/meal_period_summary.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/foundation.dart';

import 'meal_period.dart';

/// Provides a localized summary for a specific meal period.
@immutable
class MealPeriodSummary {
  const MealPeriodSummary({
    required this.period,
    required this.totalMeals,
  });

  final MealPeriod period;
  final int totalMeals;

  String localizedTitle(AppLanguage language) => period.label.resolve(language);

  String localizedSubtitle(AppLanguage language) {
    final suffix = language == AppLanguage.indonesian ? 'Menu' : 'Foods';
    return '$totalMeals+ $suffix';
  }

  @override
  String toString() =>
      'MealPeriodSummary(period: ${period.name}, totalMeals: $totalMeals)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MealPeriodSummary &&
            runtimeType == other.runtimeType &&
            period == other.period &&
            totalMeals == other.totalMeals;
  }

  @override
  int get hashCode => Object.hash(period, totalMeals);
}
