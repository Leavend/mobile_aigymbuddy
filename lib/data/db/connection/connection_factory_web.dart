import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Membuka koneksi basis data untuk platform web menggunakan WebAssembly (WASM).
///
/// `LazyDatabase` digunakan untuk membungkus inisialisasi `WasmDatabase` yang bersifat
/// asinkron, sehingga menyediakan [QueryExecutor] secara sinkron sesuai kebutuhan
/// konstruktor [AppDatabase].
QueryExecutor createDriftExecutorImpl() {
  return LazyDatabase(() async {
    final dbResult = await WasmDatabase.open(
      databaseName: 'ai_gym_buddy', // Nama basis data Anda
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return dbResult.resolvedExecutor;
  });
}

