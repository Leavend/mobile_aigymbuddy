// lib/view/shared/models/meal/meal_summary.dart

import 'package:flutter/foundation.dart';

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'meal_period.dart';

@immutable
class MealSummary {
  const MealSummary({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.heroImageAsset,
    required this.period,
    required this.prepMinutes,
    this.sizeLabel,
    this.calories,
  });

  final int id;
  final LocalizedText name;
  final String imageAsset;
  final String heroImageAsset;
  final MealPeriod period;
  final int prepMinutes;
  final String? sizeLabel;
  final int? calories;

  String localizedName(AppLanguage language) => name.resolve(language);

  String localizedTime(AppLanguage language) {
    if (language == AppLanguage.indonesian) {
      return '$prepMinutes menit';
    }
    return '$prepMinutes mins';
  }

  String localizedCalories(AppLanguage language) {
    final value = calories;
    if (value == null) {
      return language == AppLanguage.indonesian
          ? 'Kalori tidak tersedia'
          : 'Calories N/A';
    }
    final unit = language == AppLanguage.indonesian ? 'kKal' : 'kCal';
    return '$value $unit';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MealSummary &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            imageAsset == other.imageAsset &&
            heroImageAsset == other.heroImageAsset &&
            period == other.period &&
            prepMinutes == other.prepMinutes &&
            sizeLabel == other.sizeLabel &&
            calories == other.calories;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        imageAsset,
        heroImageAsset,
        period,
        prepMinutes,
        sizeLabel,
        calories,
      );

  @override
  String toString() =>
      'MealSummary(id: $id, name: ${name.english}, period: ${period.name})';
}
