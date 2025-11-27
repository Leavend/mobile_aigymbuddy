// lib/database/connection/web_connection_stub.dart
import 'package:drift/drift.dart';

/// Stub for web connection on non-web platforms
Future<DatabaseConnection> createWebConnection() async {
  throw UnsupportedError('Web connection is not available on this platform');
}
