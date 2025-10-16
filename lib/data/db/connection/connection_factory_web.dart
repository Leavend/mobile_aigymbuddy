// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

// Default asset locations declared in pubspec.yaml so Flutter copies the files
// from the drift and sqlite3 packages into the compiled web bundle.
const _defaultSqlite3Path =
    'assets/packages/sqlite3/wasm/sqlite3.wasm';
const _defaultWorkerPath =
    'assets/packages/drift/wasm/drift_worker.js';

Uri _resolveUri(String raw) {
  final uri = Uri.parse(raw);
  if (uri.hasScheme || uri.hasAuthority) {
    return uri;
  }
  return Uri.base.resolveUri(uri);
}

/// Membuka database Drift pada platform web menggunakan backend WebAssembly
/// resmi. Modul sqlite3 dan worker diambil dari paket dependensi bawaan dan
/// data disimpan ke IndexedDB untuk mendukung skenario offline-first.
QueryExecutor createDriftExecutorImpl() {
  const sqlite3Uri = String.fromEnvironment(
    'DRIFT_SQLITE3_WASM_URI',
    defaultValue: _defaultSqlite3Path,
  );

  const driftWorkerUri = String.fromEnvironment(
    'DRIFT_WORKER_URI',
    defaultValue: _defaultWorkerPath,
  );

  return LazyDatabase(() async {
    final options = DriftWebOptions(
      sqlite3Uri: _resolveUri(sqlite3Uri),
      driftWorkerUri: _resolveUri(driftWorkerUri),
      storage: DriftWebStorage.indexedDb('ai_gym_buddy'),
    );

    return WasmDatabase.open(options);
  });
}
