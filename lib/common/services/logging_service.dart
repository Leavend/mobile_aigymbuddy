import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Singleton logging service for the application
class LoggingService {
  factory LoggingService() => _instance;

  LoggingService._internal() {
    _logger = Logger(
      filter: _EnvironmentFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: kDebugMode,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      output: ConsoleOutput(),
    );
  }

  static final LoggingService _instance = LoggingService._internal();
  static Logger? _logger;

  static LoggingService get instance => _instance;

  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger?.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger?.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger?.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger?.e(message, error: error, stackTrace: stackTrace);
  }

  void trace(String message, {Object? error, StackTrace? stackTrace}) {
    _logger?.t(message, error: error, stackTrace: stackTrace);
  }

  void flutterLog(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'AI Gym Buddy',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class _EnvironmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kReleaseMode) {
      return event.level.value >= Level.warning.value;
    }
    return true;
  }
}
