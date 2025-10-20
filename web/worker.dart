// web/worker.dart
import 'package:drift/wasm.dart';

/// Entry point web worker untuk Drift Web (WASM).
/// Setelah dibuat, KOMPILASILAH file ini ke JS:
///   dart compile js -O4 web/worker.dart -o web/worker.dart.js
/// Hasilnya (worker.dart.js) HARUS ada di folder web/ (sejajar index.html).
void main() => WasmDatabase.workerMainForOpen();
