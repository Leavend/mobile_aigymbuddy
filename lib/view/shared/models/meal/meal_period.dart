// lib/view/shared/models/meal/meal_period.dart

import '../../../common/localization/app_language.dart';

enum MealPeriod { breakfast, lunch, snack, dinner }

extension MealPeriodX on MealPeriod {
  String get id => name;

  LocalizedText get label => switch (this) {
        MealPeriod.breakfast => const LocalizedText(
            english: 'Breakfast', indonesian: 'Sarapan'),
        MealPeriod.lunch =>
            const LocalizedText(english: 'Lunch', indonesian: 'Makan Siang'),
        MealPeriod.snack =>
            const LocalizedText(english: 'Snack', indonesian: 'Camilan'),
        MealPeriod.dinner =>
            const LocalizedText(english: 'Dinner', indonesian: 'Makan Malam'),
      };

  static MealPeriod? fromId(String id) {
    for (final period in MealPeriod.values) {
      if (period.id == id) return period;
    }
    return null;
  }
}
