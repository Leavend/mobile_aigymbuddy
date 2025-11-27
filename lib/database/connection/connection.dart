// lib/database/connection/connection.dart
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

// Import the native connection creation function conditionally
import 'native_connection.dart' if (dart.library.html) 'web_stub.dart';
// Import the web connection creation function conditionally
import 'web_connection_stub.dart' if (dart.library.html) 'web_connection.dart';

/// Creates and returns a database connection for the application
DatabaseConnection openConnection() {
  return DatabaseConnection.delayed(_openConnection());
}

Future<DatabaseConnection> _openConnection() async {
  if (kIsWeb) {
    return await createWebConnection();
  } else {
    // For native platforms, use the optimized native connection
    return await createNativeConnection();
  }
}

/// Alternative connection method that can be used for different environments
DatabaseConnection createConnection({bool inMemory = false}) {
  if (inMemory) {
    if (kIsWeb) {
      throw UnsupportedError(
        'In-memory database not supported on web platform',
      );
    }
    return createNativeInMemoryConnection();
  }
  return openConnection();
}
