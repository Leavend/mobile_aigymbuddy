// lib/common/services/error_service.dart

import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class ErrorService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      // Fix: Replace deprecated printTime with dateTimeFormat
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: _CustomLogOutput(),
  );

  // Log levels berdasarkan severity
  static void logDebug(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void logWarning(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void logError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    _logger.e('Error in $context', error: error, stackTrace: stackTrace);

    // Di production, kirim ke crash analytics
    if (kReleaseMode) {
      _sendToCrashAnalytics(context, error, stackTrace);
    }
  }

  static void logFatal(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    _logger.f('Fatal error in $context', error: error, stackTrace: stackTrace);

    // Di production, kirim ke crash analytics dengan priority tinggi
    if (kReleaseMode) {
      _sendToCrashAnalytics(context, error, stackTrace, isFatal: true);
    }
  }

  // Database-specific logging
  static void logDatabaseError(
    String operation,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    logError('Database - $operation', error, stackTrace);
  }

  static void logDatabaseInfo(String operation, String message) {
    logInfo('Database - $operation: $message');
  }

  static void logDatabaseDebug(String operation, String message) {
    logDebug('Database - $operation: $message');
  }

  // Network-specific logging
  static void logNetworkError(
    String endpoint,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    logError('Network - $endpoint', error, stackTrace);
  }

  static void logNetworkInfo(String endpoint, String message) {
    logInfo('Network - $endpoint: $message');
  }

  // UI-specific logging
  static void logUIError(
    String widget,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    logError('UI - $widget', error, stackTrace);
  }

  static void logUIDebug(String widget, String message) {
    logDebug('UI - $widget: $message');
  }

  // Performance logging
  static void logPerformance(String operation, Duration duration) {
    final message =
        'Performance - $operation took ${duration.inMilliseconds}ms';
    if (duration.inMilliseconds > 100) {
      logWarning(message);
    } else {
      logDebug(message);
    }
  }

  // Private method untuk mengirim ke crash analytics
  static void _sendToCrashAnalytics(
    String context,
    dynamic error,
    StackTrace? stackTrace, {
    bool isFatal = false,
  }) {
    // FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    //   fatal: isFatal,
    //   information: [
    //     DiagnosticsProperty('context', context),
    //     DiagnosticsProperty('timestamp', DateTime.now().toIso8601String()),
    //   ],
    // );
  }

  // Method untuk development debugging
  static void startPerformanceTimer(String operation) {
    if (kDebugMode) {
      _performanceTimers[operation] = DateTime.now();
      logDebug('Performance timer started for: $operation');
    }
  }

  static void endPerformanceTimer(String operation) {
    if (kDebugMode && _performanceTimers.containsKey(operation)) {
      final startTime = _performanceTimers[operation]!;
      final duration = DateTime.now().difference(startTime);
      logPerformance(operation, duration);
      _performanceTimers.remove(operation);
    }
  }

  static final Map<String, DateTime> _performanceTimers = {};
}

// Custom log output untuk mengontrol ke mana log dikirim
class _CustomLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (kDebugMode) {
      // Di development, tampilkan di console
      for (final line in event.lines) {
        // ignore: avoid_print
        print(line);
      }
    } else {
      // Di production, bisa dikirim ke logging service
      _sendToRemoteLogging(event);
    }
  }

  void _sendToRemoteLogging(OutputEvent event) {}
}
