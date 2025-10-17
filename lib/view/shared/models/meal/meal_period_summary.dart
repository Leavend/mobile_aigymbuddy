// lib/view/shared/models/meal/meal_period_summary.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'meal_period.dart';

class MealPeriodSummary {
  MealPeriodSummary({
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
}
