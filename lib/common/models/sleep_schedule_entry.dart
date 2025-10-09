import 'dart:convert';

import 'package:flutter/material.dart';

import '../date_time_utils.dart';

/// Domain model representing a single entry in the user's sleep schedule.
class SleepScheduleEntry {
  SleepScheduleEntry({
    required this.title,
    required this.startTime,
    required this.timeUntilStart,
    required this.imageReference,
    ImageProvider<Object>? fallbackImage,
  }) : _fallbackImage =
            fallbackImage ?? const AssetImage('assets/img/sleep_schedule.png');

  /// Display name shown to the user (e.g. `Bedtime`).
  final String title;

  /// When the sleep related event is scheduled to start.
  final DateTime startTime;

  /// The remaining time until [startTime].
  final Duration timeUntilStart;

  /// Raw value representing an image. This can be:
  ///
  /// * an assets path (`assets/img/bed.png`),
  /// * an `http(s)` url, or
  /// * a (data) base64 string.
  final String imageReference;

  final ImageProvider<Object> _fallbackImage;

  /// Returns the formatted hour/minute representation of [startTime].
  String get formattedTime =>
      DateTimeUtils.formatDate(startTime, pattern: 'hh:mm a');

  /// Formats [timeUntilStart] into a localized friendly string.
  String get formattedCountdown {
    if (timeUntilStart.isNegative) {
      final elapsed = timeUntilStart.abs();
      return 'started ${_formatDuration(elapsed)} ago';
    }

    final buffer = StringBuffer('in ');
    buffer.write(_formatDuration(timeUntilStart));
    return buffer.toString();
  }

  /// Builds an [ImageProvider] from [imageReference] that gracefully handles
  /// malformed/base64 references to avoid runtime `FormatException`s.
  ImageProvider<Object> get imageProvider {
    final reference = imageReference.trim();
    if (reference.isEmpty) {
      return _fallbackImage;
    }

    if (_looksLikeNetworkUrl(reference)) {
      return NetworkImage(reference);
    }

    final base64Payload = _extractBase64Payload(reference);
    if (base64Payload != null) {
      try {
        return MemoryImage(base64Decode(base64Payload));
      } on FormatException {
        // Fall through to the fallback image when decoding fails.
        return _fallbackImage;
      }
    }

    return AssetImage(reference);
  }

  static bool _looksLikeNetworkUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final segments = <String>[];

    if (hours != 0) {
      final label = hours == 1 ? 'hour' : 'hours';
      segments.add('$hours $label');
    }

    if (minutes != 0 || segments.isEmpty) {
      final label = minutes == 1 ? 'minute' : 'minutes';
      segments.add('$minutes $label');
    }

    return segments.join(' ');
  }

  static String? _extractBase64Payload(String value) {
    final normalized = value.replaceAll(RegExp(r'\s'), '');
    final markerIndex = normalized.indexOf('base64,');
    final payload = markerIndex == -1
        ? normalized
        : normalized.substring(markerIndex + 'base64,'.length);

    final base64Pattern = RegExp(r'^[A-Za-z0-9+/=]+$');
    if (payload.isEmpty || payload.length % 4 != 0) {
      return null;
    }
    if (!base64Pattern.hasMatch(payload)) {
      return null;
    }
    return payload;
  }
}
