// lib/data/db/connection/connection_factory_native.dart

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'connection_constants.dart';

QueryExecutor createDriftExecutorImpl() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, kDatabaseFileName));

  return NativeDatabase.createInBackground(file);
});
