import 'dart:developer' as developer;

import 'package:logger/logger.dart';

/// Singleton logging service for the application
class LoggingService {
  static LoggingService? _instance;
  static Logger? _logger;

  LoggingService._internal() {
    _logger = Logger(
      filter: _EnvironmentFilter(), // Custom filter for different environments
      printer: PrettyPrinter(
        methodCount: 0, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Updated format
      ),
      output: ConsoleOutput(), // Use ConsoleOutput for regular console
    );
  }

  static LoggingService get instance {
    _instance ??= LoggingService._internal();
    return _instance!;
  }

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

  /// For logging Flutter developer logs (these will appear in debug mode)
  void flutterLog(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'AI Gym Buddy',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Custom filter to control logging based on environment
class _EnvironmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In production, we might want to filter out debug and trace logs
    // For now, allow all logs
    return true;
  }
}
