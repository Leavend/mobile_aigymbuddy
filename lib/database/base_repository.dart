// lib/database/base_repository.dart

import 'package:aigymbuddy/common/services/error_service.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart';

abstract class BaseRepository {

  BaseRepository(this.database);
  final AppDatabase database;

  Future<T> safeExecute<T>(Future<T> Function() operation) async {
    if (database.isClosed) {
      throw StateError('Database connection is closed');
    }

    try {
      return await operation();
    } on SqliteException catch (e, stackTrace) {
      // Fix: Use proper logging instead of print
      ErrorService.logDatabaseError('SqliteException', e, stackTrace);
      rethrow;
    } on DriftWrappedException catch (e, stackTrace) {
      // Drift-specific exceptions
      ErrorService.logDatabaseError('DriftWrappedException', e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      // Fix: Use proper logging instead of print
      ErrorService.logDatabaseError('Unexpected error', e, stackTrace);
      rethrow;
    }
  }

  // Helper method untuk performance monitoring
  Future<T> safeExecuteWithTimer<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    ErrorService.startPerformanceTimer(operationName);
    try {
      final result = await safeExecute(operation);
      ErrorService.endPerformanceTimer(operationName);
      return result;
    } catch (e) {
      ErrorService.endPerformanceTimer(operationName);
      rethrow;
    }
  }
}
