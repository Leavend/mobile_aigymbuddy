// lib/data/db/connection/connection_factory_web.dart

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

const _databaseName = 'ai_gym_buddy';

Future<QueryExecutor> createDriftExecutorImpl() async {
  final result = await WasmDatabase.open(
    databaseName: _databaseName,
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );

  return result.resolvedExecutor;
}