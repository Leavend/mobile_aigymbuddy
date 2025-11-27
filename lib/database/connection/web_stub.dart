// lib/database/connection/web_stub.dart
// Stub file for web platform that doesn't import FFI-dependent code

import 'package:drift/drift.dart';

// These functions will never be called on web, so we just provide stub implementations
Future<DatabaseConnection> createNativeConnection() async {
  throw UnsupportedError(
    'Native database connection not available on web platform',
  );
}

DatabaseConnection createNativeInMemoryConnection() {
  throw UnsupportedError(
    'Native in-memory database not available on web platform',
  );
}
