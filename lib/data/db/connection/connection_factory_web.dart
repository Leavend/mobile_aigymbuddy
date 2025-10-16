// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';

/// Membuka database Drift di web dengan penyimpanan IndexedDB.
///
/// Pendekatan ini tidak membutuhkan aset WebAssembly tambahan sehingga
/// mempermudah konfigurasi dan menghindari error asset saat build web.
QueryExecutor createDriftExecutorImpl() {
  final storage = DriftWebStorage.indexedDb('ai_gym_buddy');

  return WebDatabase.withStorage(
    storage,
    logStatements: kDebugMode,
  );
}
