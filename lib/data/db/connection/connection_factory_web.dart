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

Future<dynamic> _attemptOpen(String label, Future<dynamic> Function() opener) async {
  try {
    return await opener();
  } on Object catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Failed to open Drift wasm database using $label assets: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    rethrow;
  }
}

Future<dynamic> _openPreferredDatabase() async {
  final attempts = <({String label, Future<dynamic> Function() create})>[
    (
      label: 'CDN-hosted',
      create: () => _openWasmDatabase(
            sqlite3Uri: _remoteSqlite3Uri,
            driftWorkerUri: _remoteDriftWorkerUri,
          ),
    ),
    (
      label: 'locally bundled',
      create: () => _openWasmDatabase(
            sqlite3Uri: _resolveUri(_localSqlite3AssetPath),
            driftWorkerUri: _resolveUri(_localDriftWorkerAssetPath),
          ),
    ),
  ];

  Object? lastError;
  StackTrace? lastStackTrace;

  for (final attempt in attempts) {
    try {
      return await _attemptOpen(attempt.label, attempt.create);
    } on Object catch (error, stackTrace) {
      lastError = error;
      lastStackTrace = stackTrace;
    }
  }

  final error = lastError ??
      StateError('Unable to open Drift wasm database from CDN or local assets.');
  Error.throwWithStackTrace(error, lastStackTrace ?? StackTrace.current);
}

QueryExecutor createDriftExecutorImpl() {
  return LazyDatabase(() async {
    final result = await _openPreferredDatabase();

    if (kDebugMode && result.missingFeatures.isNotEmpty) {
      debugPrint(
        'Drift web storage: ${result.chosenImplementation}; '
        'missing: ${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  });
}
