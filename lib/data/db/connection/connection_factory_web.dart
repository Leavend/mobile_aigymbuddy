import 'package:drift/drift.dart';
import 'package:drift/web.dart';

import 'connection_factory_stub.dart';

QueryExecutor createDriftExecutorImpl() => WebDatabase('ai_gym_buddy');
