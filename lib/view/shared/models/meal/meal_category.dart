// lib/view/shared/models/meal/meal_category.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:meta/meta.dart';

/// Aggregated representation for a meal category.
@immutable
class MealCategorySummary {
  const MealCategorySummary({
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

  @override
  String toString() =>
      'MealCategorySummary(id: $id, totalMeals: $totalMeals, imageAsset: $imageAsset)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MealCategorySummary &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            title == other.title &&
            imageAsset == other.imageAsset &&
            totalMeals == other.totalMeals;
  }

  @override
  int get hashCode => Object.hash(id, title, imageAsset, totalMeals);
}
