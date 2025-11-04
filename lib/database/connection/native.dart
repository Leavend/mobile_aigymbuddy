// lib/database/connection/native.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../common/services/error_service.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    ErrorService.logDebug(
      'Database',
      'Initializing native database connection',
    );

    try {
      ErrorService.startPerformanceTimer('native_database_init');

      // Initialize SQLite3 for Flutter on supported platforms
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
        ErrorService.logDebug(
          'Database',
          'Applied SQLite workaround for Android',
        );
      }

      final directory = Platform.isIOS
          ? await getLibraryDirectory()
          : await getApplicationDocumentsDirectory();
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      final file = File(p.join(directory.path, 'gym_buddy.db'));

      ErrorService.logDebug('Database', 'Database file path: ${file.path}');

      final database = NativeDatabase(
        file,
        setup: (database) {
          database.execute('PRAGMA foreign_keys = ON;');
          database.execute('PRAGMA journal_mode = WAL;');
          database.execute('PRAGMA synchronous = NORMAL;');
          database.execute('PRAGMA cache_size = 10000;');
          database.execute('PRAGMA temp_store = MEMORY;');

          ErrorService.logDebug('Database', 'SQLite pragmas configured');
        },
      );

      ErrorService.logInfo(
        'Database',
        'Native database initialized successfully',
      );
      return database;
    } catch (error, stackTrace) {
      ErrorService.logFatal(
        'Native database initialization',
        error,
        stackTrace,
      );
      rethrow;
    } finally {
      ErrorService.endPerformanceTimer('native_database_init');
    }
  });
}
