import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

/// Membuka koneksi basis data untuk platform web menggunakan WebAssembly (WASM).
///
/// `LazyDatabase` digunakan untuk membungkus inisialisasi `WasmDatabase` yang bersifat
/// asinkron, sehingga menyediakan [QueryExecutor] secara sinkron sesuai kebutuhan
/// konstruktor [AppDatabase].
QueryExecutor createDriftExecutorImpl() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'ai_gym_buddy', // Nama basis data Anda
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // Menangani kasus di mana browser tidak mendukung fitur yang diperlukan.
      // Anda dapat menampilkan pesan galat kepada pengguna di sini.
      debugPrint(
          'Browser ini tidak mendukung semua fitur yang diperlukan untuk basis data.');
    }

    return result.resolvedExecutor;
  });
}

