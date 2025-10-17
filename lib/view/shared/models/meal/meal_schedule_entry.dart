// lib/view/shared/models/meal/meal_schedule_entry.dart

import '../../../common/localization/app_language.dart';
import 'meal_period.dart';
import 'meal_summary.dart';

class MealScheduleEntry {
  MealScheduleEntry({
    required this.id,
    required this.meal,
    required this.scheduledAt,
  });

  final int id;
  final MealSummary meal;
  final DateTime scheduledAt;

  MealPeriod get period => meal.period;

  String formattedTime(AppLanguage language) {
    final hour = scheduledAt.hour;
    final minute = scheduledAt.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = ((hour + 11) % 12) + 1;
    return '${displayHour.toString().padLeft(2, '0')}:$minute $suffix';
  }
}
