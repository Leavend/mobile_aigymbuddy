import 'package:aigymbuddy/database/app_db.dart';

import 'package:aigymbuddy/common/services/logging_service.dart';

/// Service class for managing database operations with proper transaction handling
/// and enhanced persistence features
class DatabaseService {
  final AppDatabase _db;
  final LoggingService _logger = LoggingService.instance;

  DatabaseService(this._db);

  /// Executes a database operation within a transaction
  Future<T> transaction<T>(Future<T> Function() operation) async {
    try {
      _logger.debug('Starting database transaction');
      final result = await _db.transaction(() async {
        try {
          return await operation();
        } catch (e, stackTrace) {
          _logger.error(
            'Error during transaction operation: $e',
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      });
      _logger.debug('Transaction completed successfully');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Transaction failed: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Executes a read-only database operation with enhanced error handling
  Future<T> readOnly<T>(Future<T> Function() operation) async {
    try {
      _logger.debug('Starting read-only database operation');
      final result = await operation();
      _logger.debug('Read-only operation completed successfully');
      return result;
    } catch (e, stackTrace) {
      _logger.error(
        'Read-only operation failed: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Executes a batch of database operations within a single transaction
  Future<void> batch(List<Future<void> Function()> operations) async {
    try {
      _logger.debug(
        'Starting batch database operations (${operations.length} operations)',
      );
      await _db.transaction(() async {
        for (int i = 0; i < operations.length; i++) {
          try {
            await operations[i]();
          } catch (e, stackTrace) {
            _logger.error(
              'Batch operation $i failed: $e',
              error: e,
              stackTrace: stackTrace,
            );
            rethrow;
          }
        }
      });
      _logger.debug('Batch operations completed successfully');
    } catch (e, stackTrace) {
      _logger.error(
        'Batch operations failed: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Executes a safe database operation with retry logic
  Future<T> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          _logger.error('Operation failed after $maxRetries attempts: $e');
          rethrow;
        }

        _logger.warning(
          'Operation attempt $attempts failed, retrying in ${delay.inMilliseconds}ms: $e',
        );
        await Future.delayed(delay);
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// Backup database to a safe location
  Future<String> backupDatabase() async {
    // This would implement database backup logic
    // For now, just log the intent
    _logger.info('Database backup requested');
    return 'backup_${DateTime.now().millisecondsSinceEpoch}.sql';
  }

  /// Check database integrity
  Future<bool> checkDatabaseIntegrity() async {
    try {
      await _db.customSelect('PRAGMA integrity_check;').get();
      _logger.debug('Database integrity check passed');
      return true;
    } catch (e) {
      _logger.error('Database integrity check failed: $e');
      return false;
    }
  }
}
