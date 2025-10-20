// lib/database/connection/web.dart

import 'package:drift/wasm.dart';
import 'package:drift/drift.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    // Hanya gunakan WasmDatabase.open tanpa try-catch
    final db = await WasmDatabase.open(
      databaseName: 'gym_buddy_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('worker.dart.js'),
    );

    // Anda tetap bisa mengecek jika ada fitur yang tidak didukung
    if (db.missingFeatures.isNotEmpty) {
      // ignore: avoid_print
      print('Drift WASM missing features: ${db.missingFeatures}');
    }

    return db.resolvedExecutor;
  });
}