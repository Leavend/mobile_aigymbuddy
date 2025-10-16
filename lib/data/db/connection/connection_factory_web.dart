// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';

/// Membuka database Drift di web menggunakan IndexedDB sebagai storage.
///
/// Implementasi ini tidak memerlukan konfigurasi aset tambahan karena drift
/// akan mengelola _worker_ dan file WASM secara otomatis melalui paket
/// `drift/web.dart`.
QueryExecutor createDriftExecutorImpl() {
  return WebDatabase.withStorage(
    DriftWebStorage.indexedDb('ai_gym_buddy'),
    logStatements: kDebugMode,
  );
}
