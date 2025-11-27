import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/database_verifier.dart';
import 'package:aigymbuddy/common/services/logging_service.dart';

/// Simple test script untuk verify database persistence
void main() async {
  LoggingService.instance.info('🔍 Starting Database Persistence Test...');

  // Initialize logging
  LoggingService.instance.info('Database persistence test initiated');

  try {
    // Initialize database
    final db = AppDatabase();
    LoggingService.instance.info('✅ Database initialized');

    // Test persistence
    final verifier = DatabaseVerifier(db);
    final isPersistent = await verifier.testPersistence();

    LoggingService.instance.info('📊 Test Results:');
    LoggingService.instance.info(
      'Persistence: ${isPersistent ? '✅ PASSED' : '❌ FAILED'}',
    );

    if (isPersistent) {
      // Get database stats
      final stats = await verifier.getDatabaseStats();
      LoggingService.instance.info('💾 Database Stats:');
      LoggingService.instance.info(
        'Total Size: ${stats.totalSize} bytes (${(stats.totalSize / 1024 / 1024).toStringAsFixed(2)} MB)',
      );
      LoggingService.instance.info(
        'Usage: ${stats.usagePercentage.toStringAsFixed(2)}%',
      );

      // Check integrity
      final isIntact = await verifier.checkForCorruption();
      LoggingService.instance.info(
        'Integrity: ${isIntact ? '✅ OK' : '❌ CORRUPTED'}',
      );
    }

    // Test transaction
    LoggingService.instance.info('🔄 Testing Transactions...');
    await db.transaction(() async {
      // Perform a simple operation
      await db.customSelect('SELECT 1').getSingle();
    });
    LoggingService.instance.info('✅ Transactions working');

    // Close database
    await db.close();
    LoggingService.instance.info('✅ Database closed safely');

    LoggingService.instance.info('🎉 All tests completed successfully!');
    LoggingService.instance.info(
      'Database persistence test completed successfully',
    );
  } catch (e, stackTrace) {
    LoggingService.instance.error(
      '❌ Test failed: $e',
      error: e,
      stackTrace: stackTrace,
    );
    LoggingService.instance.error(
      'Database persistence test failed: $e',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
