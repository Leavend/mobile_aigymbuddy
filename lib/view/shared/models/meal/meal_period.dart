// lib/view/shared/models/meal/meal_period.dart

import 'package:aigymbuddy/common/localization/app_language.dart';

enum MealPeriod { breakfast, lunch, snack, dinner }

extension MealPeriodX on MealPeriod {
  static const Map<MealPeriod, String> _ids = {
    MealPeriod.breakfast: 'breakfast',
    MealPeriod.lunch: 'lunch',
    MealPeriod.snack: 'snack',
    MealPeriod.dinner: 'dinner',
  };

  static const Map<MealPeriod, LocalizedText> _labels = {
    MealPeriod.breakfast:
        LocalizedText(english: 'Breakfast', indonesian: 'Sarapan'),
    MealPeriod.lunch:
        LocalizedText(english: 'Lunch', indonesian: 'Makan Siang'),
    MealPeriod.snack: LocalizedText(english: 'Snack', indonesian: 'Camilan'),
    MealPeriod.dinner:
        LocalizedText(english: 'Dinner', indonesian: 'Makan Malam'),
  };

  static final Map<String, MealPeriod> _reverseIds = {
    for (final entry in _ids.entries) entry.value: entry.key
  };

  String get id => _ids[this]!;

  LocalizedText get label => _labels[this]!;

  static MealPeriod? fromId(String id) => _reverseIds[id];
}
