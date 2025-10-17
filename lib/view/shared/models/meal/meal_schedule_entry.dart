// lib/view/shared/models/meal/meal_schedule_entry.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'meal_period.dart';
import 'meal_summary.dart';

/// Represents a scheduled meal instance for a specific day.
@immutable
class MealScheduleEntry {
  const MealScheduleEntry({
    required this.id,
    required this.meal,
    required this.scheduledAt,
  });

  final int id;
  final MealSummary meal;
  final DateTime scheduledAt;

  MealPeriod get period => meal.period;

  String formattedTime(AppLanguage language) {
    final locale = language == AppLanguage.indonesian ? 'id' : 'en';
    return DateFormat.jm(locale).format(scheduledAt);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MealScheduleEntry &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            meal == other.meal &&
            scheduledAt == other.scheduledAt;
  }

  @override
  int get hashCode => Object.hash(id, meal, scheduledAt);

  @override
  String toString() =>
      'MealScheduleEntry(id: $id, meal: ${meal.id}, scheduledAt: $scheduledAt)';
}
