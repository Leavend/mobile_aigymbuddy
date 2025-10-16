import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'connection_factory_stub.dart';

QueryExecutor createDriftExecutorImpl() => LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'ai_gym_buddy.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
