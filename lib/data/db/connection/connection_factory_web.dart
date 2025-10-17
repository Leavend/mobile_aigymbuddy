// lib/data/db/connection/connection_factory_web.dart
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';

const _databaseName = 'ai_gym_buddy';

QueryExecutor createDriftExecutorImpl() {
  DriftWebStorage storage;
  try {
    storage = DriftWebStorage.indexedDb(_databaseName);
  } on Object catch (error) {
    if (kDebugMode) {
      debugPrint('IndexedDB unavailable ($error), falling back to in-memory web storage.');
    }
    storage = DriftWebStorage.inMemory();
  }

  return WebDatabase.withStorage(
    storage,
    logStatements: kDebugMode,
  );
}
