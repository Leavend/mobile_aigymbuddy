import 'package:drift/drift.dart';

import 'connection_factory_stub.dart'
    if (dart.library.io) 'connection_factory_native.dart'
    if (dart.library.html) 'connection_factory_web.dart';

/// Provides the platform-specific [QueryExecutor] for the Drift database.
QueryExecutor createDriftExecutor() => createDriftExecutorImpl();
