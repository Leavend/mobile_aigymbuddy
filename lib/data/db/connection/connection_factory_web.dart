// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

// Pastikan path ini benar dan terdaftar di pubspec.yaml sebagai asset.
const _defaultSqlite3Path = 'assets/packages/sqlite3/wasm/sqlite3.wasm';
// Worker yang benar biasanya bernama drift_worker.dart.js (bukan .js)
const _defaultWorkerPath = 'assets/packages/drift/wasm/drift_worker.dart.js';

Uri _resolveUri(String raw) {
  final uri = Uri.parse(raw);
  if (uri.hasScheme || uri.hasAuthority) return uri;
  return Uri.base.resolveUri(uri);
}

/// Membuka database Drift di web (WASM) dengan penyimpanan persisten otomatis.
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
    // Panggil dengan ARGUMEN BERNAMA dan ambil executor-nya
    final result = await WasmDatabase.open(
      databaseName: 'ai_gym_buddy',
      sqlite3Uri: _resolveUri(sqlite3Uri),
      driftWorkerUri: _resolveUri(driftWorkerUri),
    );

    if (kDebugMode && result.missingFeatures.isNotEmpty) {
      debugPrint('Drift web storage: ${result.chosenImplementation}; '
          'missing: ${result.missingFeatures}');
    }

    // Kembalikan QueryExecutor yang Drift butuhkan
    return result.resolvedExecutor;
  });
}
