import 'package:flutter/foundation.dart';

/// Immutable data model representing the configuration of a sleep alarm.
@immutable
class SleepAlarmConfiguration {
  const SleepAlarmConfiguration({
    required this.bedtime,
    required this.duration,
    required Set<int> repeatWeekdays,
    required this.vibrate,
  }) : repeatWeekdays = Set.unmodifiable(repeatWeekdays);

  /// Date and time when the user plans to go to bed.
  final DateTime bedtime;

  /// Desired amount of time spent sleeping.
  final Duration duration;

  /// ISO weekday integers (Monday = 1 ... Sunday = 7) when the alarm repeats.
  final Set<int> repeatWeekdays;

  /// Whether vibration should be enabled when the alarm fires.
  final bool vibrate;

  /// Calculated wake up time derived from [bedtime] and [duration].
  DateTime get wakeTime => bedtime.add(duration);

  SleepAlarmConfiguration copyWith({
    DateTime? bedtime,
    Duration? duration,
    Set<int>? repeatWeekdays,
    bool? vibrate,
  }) {
    return SleepAlarmConfiguration(
      bedtime: bedtime ?? this.bedtime,
      duration: duration ?? this.duration,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      vibrate: vibrate ?? this.vibrate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SleepAlarmConfiguration &&
        other.bedtime == bedtime &&
        other.duration == duration &&
        setEquals(other.repeatWeekdays, repeatWeekdays) &&
        other.vibrate == vibrate;
  }

  @override
  int get hashCode {
    final sortedWeekdays = repeatWeekdays.toList()..sort();
    return Object.hash(
      bedtime,
      duration,
      Object.hashAll(sortedWeekdays),
      vibrate,
    );
  }
}
