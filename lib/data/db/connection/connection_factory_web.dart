import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import 'connection_constants.dart';

QueryExecutor createDriftExecutorImpl() => LazyDatabase(() async {
  final database = await WasmDatabase.open(
    databaseName: kDatabaseName,
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );

  return database.resolvedExecutor;
});
