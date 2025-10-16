# AI Gym Buddy

MVP aplikasi latihan pribadi dengan penyimpanan offline-first berbasis Drift
(`SQLite`). Proyek disiapkan dengan arsitektur bersih agar mudah dikembangkan
untuk fitur sinkronisasi dan integrasi AI di kemudian hari.

## Menjalankan Proyek

1. **Pasang dependensi**
   ```bash
   flutter pub get
   ```

2. **Jalankan code generation Drift** setiap kali ada perubahan pada tabel atau
   DAO.
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run            # perangkat/emulator mobile
   flutter run -d chrome  # build web
   ```

### Catatan Platform Web

- Backend Drift memakai WebAssembly resmi dengan penyimpanan IndexedDB. Modul
  SQLite (`sqlite3.wasm`) dan worker (`drift_worker.js`) otomatis diambil dari
  paket dependensi sehingga tidak perlu menyalin berkas secara manual.
- Jika ingin meng-host file sendiri (misal untuk lingkungan tanpa akses
  internet), setel variabel kompilasi berikut saat build:
  ```bash
  flutter run -d chrome --dart-define=DRIFT_SQLITE3_WASM_URI=/path/sqlite3.wasm \
                               --dart-define=DRIFT_WORKER_URI=/path/drift_worker.js
  ```
