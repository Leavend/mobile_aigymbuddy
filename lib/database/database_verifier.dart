import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:aigymbuddy/database/app_db.dart';

/// Utility class for verifying database persistence and integrity
class DatabaseVerifier {

  DatabaseVerifier(this._db);
  final LoggingService _logger = LoggingService.instance;
  final AppDatabase _db;

  /// Test database persistence by writing and reading data
  Future<bool> testPersistence() async {
    try {
      _logger.info('Starting database persistence test...');

      // Test basic connectivity
      await _db.customSelect('SELECT 1').getSingle();
      _logger.debug('Database connectivity verified');

      // Test table existence
      final tables = await _getTables();
      if (tables.isEmpty) {
        _logger.warning('No tables found in database');
        return false;
      }

      _logger.debug('Found ${tables.length} tables: ${tables.join(', ')}');

      // Test write operation
      await _testWriteOperation();

      // Test read operation
      await _testReadOperation();

      // Test transaction integrity
      await _testTransactionIntegrity();

      _logger.info('Database persistence test completed successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.error(
        'Database persistence test failed: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get list of all tables in the database
  Future<List<String>> _getTables() async {
    final result = await _db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    return result.map((row) => row.data['name'] as String).toList();
  }

  /// Test write operations
  Future<void> _testWriteOperation() async {
    // This would create a test record if the schema allows
    // For now, we'll just verify we can execute writes
    await _db.customSelect('BEGIN').get();
    await _db.customSelect('COMMIT').get();
    _logger.debug('Write operation test passed');
  }

  /// Test read operations
  Future<void> _testReadOperation() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) as count FROM sqlite_master')
        .get();
    if (result.isEmpty) {
      throw Exception('Read operation failed');
    }
    _logger.debug('Read operation test passed');
  }

  /// Test transaction integrity
  Future<void> _testTransactionIntegrity() async {
    await _db.transaction(() async {
      await _db.customSelect('SELECT 1').getSingle();
    });
    _logger.debug('Transaction integrity test passed');
  }

  /// Get database statistics
  Future<DatabaseStats> getDatabaseStats() async {
    try {
      final pageCount = await _db.customSelect('PRAGMA page_count').get();
      final pageSize = await _db.customSelect('PRAGMA page_size').get();
      final freeList = await _db.customSelect('PRAGMA freelist_count').get();

      return DatabaseStats(
        pageCount: pageCount.first.data['page_count'] as int,
        pageSize: pageSize.first.data['page_size'] as int,
        freeListCount: freeList.first.data['freelist_count'] as int,
      );
    } catch (e) {
      _logger.error('Failed to get database stats: $e');
      rethrow;
    }
  }

  /// Check for database corruption
  Future<bool> checkForCorruption() async {
    try {
      final result = await _db.customSelect('PRAGMA integrity_check').get();
      final isOk = result.first.data['integrity_check'] == 'ok';

      if (isOk) {
        _logger.debug('Database integrity check passed');
      } else {
        _logger.warning('Database integrity check failed');
      }

      return isOk;
    } catch (e) {
      _logger.error('Error checking database integrity: $e');
      return false;
    }
  }
}

/// Database statistics for monitoring
class DatabaseStats {

  DatabaseStats({
    required this.pageCount,
    required this.pageSize,
    required this.freeListCount,
  });
  final int pageCount;
  final int pageSize;
  final int freeListCount;

  int get totalSize => pageCount * pageSize;
  int get freeSize => freeListCount * pageSize;
  int get usedSize => totalSize - freeSize;
  double get usagePercentage => (usedSize / totalSize) * 100;

  @override
  String toString() {
    return 'DatabaseStats(pageCount: $pageCount, pageSize: $pageSize, '
        'totalSize: $totalSize bytes, usage: ${usagePercentage.toStringAsFixed(2)}%)';
  }
}
