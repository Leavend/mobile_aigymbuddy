// lib/database/connection/unsupported.dart
import 'package:drift/drift.dart';

LazyDatabase openConnection() => throw UnsupportedError(
  'Platform not supported for this database implementation.',
);
