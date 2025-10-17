// lib/view/workout_tracker/workout_localizations.dart

import 'package:intl/intl.dart';

import '../../common/date_time_utils.dart';
import '../../common/localization/app_language.dart';
import '../shared/models/workout.dart';

class WorkoutLocalizations {
  const WorkoutLocalizations._();

  static String goalLabel(AppLanguage language, WorkoutGoal goal) {
    switch (goal) {
      case WorkoutGoal.loseWeight:
        return language == AppLanguage.english
            ? 'Lose Weight'
            : 'Turunkan Berat Badan';
      case WorkoutGoal.buildMuscle:
        return language == AppLanguage.english ? 'Build Muscle' : 'Bangun Otot';
      case WorkoutGoal.endurance:
        return language == AppLanguage.english ? 'Endurance' : 'Daya Tahan';
    }
  }

  static String levelLabel(AppLanguage language, WorkoutLevel level) {
    switch (level) {
      case WorkoutLevel.beginner:
        return language == AppLanguage.english ? 'Beginner' : 'Pemula';
      case WorkoutLevel.intermediate:
        return language == AppLanguage.english ? 'Intermediate' : 'Menengah';
      case WorkoutLevel.advanced:
        return language == AppLanguage.english ? 'Advanced' : 'Lanjutan';
    }
  }

  static String environmentLabel(
    AppLanguage language,
    WorkoutEnvironment environment,
  ) {
    switch (environment) {
      case WorkoutEnvironment.home:
        return language == AppLanguage.english ? 'Home' : 'Rumah';
      case WorkoutEnvironment.gym:
        return language == AppLanguage.english ? 'Gym' : 'Gym';
    }
  }

  static String exerciseCount(AppLanguage language, int? count) {
    if (count == null || count == 0) {
      return language == AppLanguage.english
          ? 'No exercises'
          : 'Belum ada latihan';
    }

    final label = language == AppLanguage.english ? 'Exercises' : 'Latihan';
    return '$count $label';
  }

  static String durationLabel(AppLanguage language, Duration? duration) {
    if (duration == null || duration == Duration.zero) {
      return language == AppLanguage.english ? '—' : '—';
    }

    final singularHour = language == AppLanguage.english ? 'hour' : 'jam';
    final pluralHour = language == AppLanguage.english ? 'hours' : 'jam';
    final singularMinute = language == AppLanguage.english ? 'minute' : 'menit';
    final pluralMinute = language == AppLanguage.english ? 'minutes' : 'menit';

    return duration.toReadableString(
      singularHourLabel: singularHour,
      pluralHourLabel: pluralHour,
      singularMinuteLabel: singularMinute,
      pluralMinuteLabel: pluralMinute,
    );
  }

  static String upcomingTimeLabel(AppLanguage language, DateTime? time) {
    if (time == null) {
      return language == AppLanguage.english
          ? 'Flexible schedule'
          : 'Jadwal fleksibel';
    }

    final format = language == AppLanguage.english
        ? DateFormat('MMM dd, hh:mma')
        : DateFormat('dd MMM, HH.mm', language.code);
    final dayLabel = language == AppLanguage.english
        ? time.relativeDayLabel
        : _relativeDayLabelId(time);
    return '$dayLabel, ${format.format(time)}';
  }

  static String scheduleTime(AppLanguage language, DateTime time) {
    final format = language == AppLanguage.english
        ? DateFormat('MMM dd, hh:mma')
        : DateFormat('dd MMM, HH.mm', language.code);
    return format.format(time);
  }

  static String relativeDay(AppLanguage language, DateTime date) {
    if (language == AppLanguage.english) {
      return date.relativeDayLabel;
    }

    final today = DateTimeUtils.startOfDay(DateTime.now());
    final target = DateTimeUtils.startOfDay(date);
    final difference = target.difference(today).inDays;
    if (difference == 0) return 'Hari ini';
    if (difference == 1) return 'Besok';
    if (difference == -1) return 'Kemarin';

    return DateFormat('E', language.code).format(date);
  }

  static String _relativeDayLabelId(DateTime date) {
    final today = DateTimeUtils.startOfDay(DateTime.now());
    final target = DateTimeUtils.startOfDay(date);
    final difference = target.difference(today).inDays;

    if (difference == 0) return 'Hari ini';
    if (difference == 1) return 'Besok';
    if (difference == -1) return 'Kemarin';
    return DateFormat('E', 'id').format(date);
  }
}
