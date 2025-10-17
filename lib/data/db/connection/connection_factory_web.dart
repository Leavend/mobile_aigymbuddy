// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

const _localSqlite3AssetPath = 'sqlite3.wasm';
const _localDriftWorkerAssetPath = 'drift_worker.dart.js';

// CDN fallbacks ensure dev builds continue to work even when the wasm assets
// were not generated locally yet. For production deployments consider hosting
// these files yourself to avoid third-party availability concerns.
final Uri _remoteSqlite3Uri =
    Uri.parse('https://unpkg.com/sqlite3@2.9.3/wasm/sqlite3.wasm');
final Uri _remoteDriftWorkerUri =
    Uri.parse('https://unpkg.com/drift@2.28.2/wasm/drift_worker.dart.js');

Uri _resolveUri(String path) {
  return Uri.base.resolve(path);
}

Future<dynamic> _openWasmDatabase({
  required Uri sqlite3Uri,
  required Uri driftWorkerUri,
}) {
  return WasmDatabase.open(
    databaseName: 'ai_gym_buddy',
    sqlite3Uri: sqlite3Uri,
    driftWorkerUri: driftWorkerUri,
  );
}

QueryExecutor createDriftExecutorImpl() {
  return LazyDatabase(() async {
    dynamic result;
    try {
      result = await _openWasmDatabase(
        sqlite3Uri: _resolveUri(_localSqlite3AssetPath),
        driftWorkerUri: _resolveUri(_localDriftWorkerAssetPath),
      );
    } on Object catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'Falling back to CDN-hosted Drift wasm assets: $error',
        );
        debugPrintStack(stackTrace: stackTrace);
      }

      result = await _openWasmDatabase(
        sqlite3Uri: _remoteSqlite3Uri,
        driftWorkerUri: _remoteDriftWorkerUri,
      );
    }

    if (kDebugMode && result.missingFeatures.isNotEmpty) {
      debugPrint(
        'Drift web storage: ${result.chosenImplementation}; '
        'missing: ${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  });
}
