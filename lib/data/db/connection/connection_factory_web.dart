// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

const _sqlite3AssetPath = 'assets/packages/sqlite3/wasm/sqlite3.wasm';
const _driftWorkerAssetPath = 'assets/packages/drift/wasm/drift_worker.dart.js';

Uri _resolveUri(String path) {
  return Uri.base.resolve(path);
}

QueryExecutor createDriftExecutorImpl() {
  return LazyDatabase(() async {
    final sqliteUri = _resolveUri(_sqlite3AssetPath);
    final workerUri = _resolveUri(_driftWorkerAssetPath);

    final result = await WasmDatabase.open(
      databaseName: 'ai_gym_buddy',
      sqlite3Uri: sqliteUri,
      driftWorkerUri: workerUri,
    );

    if (kDebugMode && result.missingFeatures.isNotEmpty) {
      debugPrint(
        'Drift web storage: ${result.chosenImplementation}; '
        'missing: ${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  });
}
