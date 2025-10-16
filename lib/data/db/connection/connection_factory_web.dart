import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Membuka database Drift pada platform web menggunakan backend WebAssembly
/// resmi. Drift akan memuat modul SQLite dan worker langsung dari paket
/// dependensi (`packages/sqlite3/wasm/sqlite3.wasm` dan
/// `packages/drift/wasm/drift_worker.js`) sehingga tidak perlu menyalin file
/// secara manual.
QueryExecutor createDriftExecutorImpl() {
  const sqlite3Uri = String.fromEnvironment(
    'DRIFT_SQLITE3_WASM_URI',
    defaultValue: 'packages/sqlite3/wasm/sqlite3.wasm',
  );

  const driftWorkerUri = String.fromEnvironment(
    'DRIFT_WORKER_URI',
    defaultValue: 'packages/drift/wasm/drift_worker.js',
  );

  return LazyDatabase(() async {
    final options = DriftWebOptions(
      sqlite3Uri: Uri.parse(sqlite3Uri),
      driftWorkerUri: Uri.parse(driftWorkerUri),
      storage: DriftWebStorage.indexedDb('ai_gym_buddy'),
    );

    return await WasmDatabase.open(options);
  });
}
