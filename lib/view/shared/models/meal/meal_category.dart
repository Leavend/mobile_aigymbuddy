// lib/view/shared/models/meal/meal_category.dart

import '../../../common/localization/app_language.dart';

class MealCategorySummary {
  MealCategorySummary({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.totalMeals,
  });

  final int id;
  final LocalizedText title;
  final String imageAsset;
  final int totalMeals;

  String localizedTitle(AppLanguage language) => title.resolve(language);
}
