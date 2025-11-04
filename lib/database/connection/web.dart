// lib/database/connection/web.dart

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';
import '../../common/services/error_service.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    ErrorService.logDebug('Database', 'Initializing web database connection');

    try {
      ErrorService.startPerformanceTimer('wasm_database_init');

      final db = await WasmDatabase.open(
        databaseName: 'gym_buddy_db',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('worker.dart.js'),
      );

      ErrorService.endPerformanceTimer('wasm_database_init');

      if (db.missingFeatures.isNotEmpty) {
        ErrorService.logWarning(
          'Database - Web',
          'WASM missing features: ${db.missingFeatures}',
        );
      }

      ErrorService.logInfo(
        'Database',
        'WASM database initialized successfully',
      );
      return db.resolvedExecutor;
    } catch (wasmError) {
      ErrorService.logDatabaseError('WASM initialization', wasmError);

      try {
        ErrorService.logInfo(
          'Database',
          'Attempting IndexedDB fallback initialization',
        );

        final fallbackDb = WebDatabase.withStorage(
          DriftWebStorage.indexedDb('gym_buddy_db'),
        );

        ErrorService.logInfo(
          'Database',
          'IndexedDB database initialized successfully',
        );
        return fallbackDb;
      } catch (fallbackError) {
        ErrorService.logFatal(
          'Database fallback initialization',
          fallbackError,
        );
        rethrow;
      }
    }
  });
}
