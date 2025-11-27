// lib/common/services/logging_config.dart

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggingConfig {
  static Logger createLogger({required String name, Level? level}) {
    return Logger(
      filter: _LogFilter(level ?? _getDefaultLogLevel()),
      printer: PrettyPrinter(
        // Fix: Replace deprecated printTime with dateTimeFormat
        dateTimeFormat: kDebugMode
            ? DateTimeFormat.onlyTimeAndSinceStart
            : DateTimeFormat.none,
      ),
      output: kDebugMode ? ConsoleOutput() : _ProductionOutput(),
    );
  }

  static Level _getDefaultLogLevel() {
    if (kDebugMode) {
      return Level.debug;
    } else if (kProfileMode) {
      return Level.info;
    } else {
      return Level.warning;
    }
  }
}

class _LogFilter extends LogFilter {

  _LogFilter(this._level);
  final Level _level;

  @override
  bool shouldLog(LogEvent event) {
    return event.level.value >= _level.value;
  }
}

class _ProductionOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Di production, kirim ke remote logging service
    // Implementasi sesuai kebutuhan (Firebase, Sentry, dll)

    // Untuk sekarang, hanya log error dan fatal ke console
    if (event.level.value >= Level.error.value) {
      for (final line in event.lines) {
        // ignore: avoid_print
        print('[PROD] $line');
      }
    }
  }
}
