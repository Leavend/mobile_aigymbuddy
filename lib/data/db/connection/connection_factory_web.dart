// lib/data/db/connection/connection_factory_web.dart

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Menggunakan penyimpanan IndexedDB bawaan Drift untuk platform web sehingga
/// tidak membutuhkan aset tambahan seperti `sqlite3.wasm`.
QueryExecutor createDriftExecutorImpl() {
  return WebDatabase.withStorage(
    DriftWebStorage.indexedDb('ai_gym_buddy'),
  );
}
