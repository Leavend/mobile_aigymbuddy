// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';

import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';


const _defaultSqlite3Path = 'sqlite3.wasm';
const _defaultWorkerPath = 'drift_worker.dart.js';

Uri _resolveUri(String path) {
  return Uri.base.resolve(path);
}

QueryExecutor createDriftExecutorImpl() {

  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'ai_gym_buddy',
      sqlite3Uri: _resolveUri(_defaultSqlite3Path),
      driftWorkerUri: _resolveUri(_defaultWorkerPath),
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
