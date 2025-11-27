import 'package:intl/intl.dart';

/// Utilities for working with [DateTime] and formatted strings.
///
/// The methods in this file are intentionally pure to keep them predictable and
/// testable. They throw [ArgumentError] or [FormatException] with descriptive
/// messages when an invalid value is provided so failures surface early.
class DateTimeUtils {
  const DateTimeUtils._();

  /// Formats [minutes] since midnight (UTC) into a string using [pattern].
  ///
  /// Throws an [ArgumentError] when [minutes] is negative.
  static String formatMinutesToTime(int minutes, {String pattern = 'hh:mm a'}) {
    if (minutes < 0) {
      throw ArgumentError.value(minutes, 'minutes', 'Cannot be negative');
    }

    final formatter = DateFormat(pattern);
    final dateTime = DateTime(1970).add(Duration(minutes: minutes));

    return formatter.format(dateTime);
  }

  /// Converts a [date] string from [inputPattern] into [outputPattern].
  static String reformatDateString(
    String date, {
    String inputPattern = 'dd/MM/yyyy hh:mm aa',
    String outputPattern = 'hh:mm a',
  }) {
    final parsedDate = parseDate(date, pattern: inputPattern);
    return formatDate(parsedDate, pattern: outputPattern);
  }

  /// Parses [value] into a [DateTime] using [pattern].
  ///
  /// Throws a [FormatException] that includes the provided [value] for easier
  /// debugging when parsing fails.
  static DateTime parseDate(String value, {String pattern = 'hh:mm a'}) {
    final formatter = DateFormat(pattern);
    try {
      return formatter.parseStrict(value);
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FormatException('Unable to parse "$value" using "$pattern".', error),
        stackTrace,
      );
    }
  }

  /// Returns the start of the day for [date] (i.e. time set to 00:00:00.000).
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Formats [date] with the provided [pattern].
  static String formatDate(
    DateTime date, {
    String pattern = 'dd/MM/yyyy hh:mm a',
  }) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  /// Generates a human friendly description of how [date] relates to `now`.
  ///
  /// Examples: `Today`, `Tomorrow`, `Yesterday`, `Mon`.
  static String describeDay(DateTime date) {
    final now = DateTime.now();
    final today = startOfDay(now);
    final target = startOfDay(date);
    final dayDifference = target.difference(today).inDays;

    if (dayDifference == 0) {
      return 'Today';
    }
    if (dayDifference == 1) {
      return 'Tomorrow';
    }
    if (dayDifference == -1) {
      return 'Yesterday';
    }
    return DateFormat('E').format(date);
  }

  /// Parses [value] using [pattern] and then delegates to [describeDay].
  static String describeDayFromString(
    String value, {
    String pattern = 'dd/MM/yyyy hh:mm a',
  }) {
    final date = parseDate(value, pattern: pattern);
    return describeDay(date);
  }

  /// Formats [duration] into a human friendly string containing hour/minute
  /// segments. Examples: `1 hour 10 minutes`, `45 minutes`.
  static String formatDuration(
    Duration duration, {
    String singularHourLabel = 'hour',
    String pluralHourLabel = 'hours',
    String singularMinuteLabel = 'minute',
    String pluralMinuteLabel = 'minutes',
  }) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final segments = <String>[];

    if (hours != 0) {
      final label = hours.abs() == 1 ? singularHourLabel : pluralHourLabel;
      segments.add('${hours.abs()} $label');
    }

    if (minutes != 0 || segments.isEmpty) {
      final label = minutes.abs() == 1
          ? singularMinuteLabel
          : pluralMinuteLabel;
      segments.add('${minutes.abs()} $label');
    }

    return segments.join(' ');
  }
}

extension DateTimeRelativeX on DateTime {
  /// Shortcut for [DateTimeUtils.startOfDay].
  DateTime get startOfDay => DateTimeUtils.startOfDay(this);

  /// Shortcut for [DateTimeUtils.describeDay].
  String get relativeDayLabel => DateTimeUtils.describeDay(this);
}

extension DurationFormattingX on Duration {
  /// Formats this [Duration] using [DateTimeUtils.formatDuration].
  String toReadableString({
    String singularHourLabel = 'hour',
    String pluralHourLabel = 'hours',
    String singularMinuteLabel = 'minute',
    String pluralMinuteLabel = 'minutes',
  }) {
    return DateTimeUtils.formatDuration(
      this,
      singularHourLabel: singularHourLabel,
      pluralHourLabel: pluralHourLabel,
      singularMinuteLabel: singularMinuteLabel,
      pluralMinuteLabel: pluralMinuteLabel,
    );
  }
}
