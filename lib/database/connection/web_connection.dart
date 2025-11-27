// lib/database/connection/web_connection.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';
import '../../common/services/logging_service.dart';

/// Creates a web-specific database connection
Future<DatabaseConnection> createWebConnection() async {
  try {
    final result = await WasmDatabase.open(
      databaseName: 'gym_buddy_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('worker.dart.js'),
    );

    LoggingService.instance.info(
      'Web database using implementation: ${result.chosenImplementation}',
    );

    if (result.missingFeatures.isNotEmpty) {
      LoggingService.instance.warning(
        'Using ${result.chosenImplementation} due to missing browser features: ${result.missingFeatures}',
      );
    }

    if (result.chosenImplementation.toString().contains('inMemory')) {
      LoggingService.instance.error(
        'WARNING: Database is in-memory only! Data will be lost on page reload. '
        'User should upgrade their browser for persistence support.',
      );
    }

    LoggingService.instance.info(
      'Web database initialized successfully with persistence',
    );
    return DatabaseConnection(result.resolvedExecutor);
  } catch (e, stackTrace) {
    LoggingService.instance.error(
      'WASM database failed, trying deprecated IndexedDB fallback',
      error: e,
      stackTrace: stackTrace,
    );

    try {
      // ignore: deprecated_member_use
      final fallbackDb = WebDatabase.withStorage(
        DriftWebStorage.indexedDb(
          'gym_buddy_db',
          migrateFromLocalStorage: true,
        ),
      );
      LoggingService.instance.info(
        'IndexedDB fallback (deprecated API) initialized successfully',
      );
      return DatabaseConnection(fallbackDb);
    } catch (fallbackError, fallbackStack) {
      LoggingService.instance.error(
        'All web database initialization methods failed',
        error: fallbackError,
        stackTrace: fallbackStack,
      );
      rethrow;
    }
  }
}
