// lib/database/connection/native_connection.dart
// This file is only imported on native platforms
import 'dart:io';

// Import logging service
import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

Future<DatabaseConnection> createNativeConnection() async {
  try {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'gym_buddy_db.sqlite');
    final file = File(path);

    // Ensure directory exists before creating database
    await file.parent.create(recursive: true);

    // Log database location for debugging
    LoggingService.instance.info('Database path: $path');
    LoggingService.instance.info(
      'Database file exists before init: ${file.existsSync()}',
    );

    // Create optimized NativeDatabase with explicit file
    final database = NativeDatabase(
      file,
    );

    // Verify file was created successfully
    if (!file.existsSync()) {
      LoggingService.instance.warning(
        'Database file was not created after initialization!',
      );
    } else {
      final fileSize = file.lengthSync();
      LoggingService.instance.info(
        'Database file created successfully (size: $fileSize bytes)',
      );
    }

    LoggingService.instance.info(
      'Native database initialized successfully at: $path',
    );
    return DatabaseConnection(database);
  } catch (e, stackTrace) {
    LoggingService.instance.error(
      'Failed to initialize native database: $e',
      error: e,
      stackTrace: stackTrace,
    );

    // DO NOT fallback to in-memory database!
    // In-memory databases lose all data when app closes.
    // Better to fail fast and show an error to the user.
    rethrow;
  }
}

DatabaseConnection createNativeInMemoryConnection() {
  return DatabaseConnection(NativeDatabase.memory());
}
