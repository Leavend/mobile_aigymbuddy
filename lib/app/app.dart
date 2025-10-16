import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/db/app_database.dart';
import '../data/seed/seed_repository.dart';
import 'app_state.dart';
import 'dependencies.dart';
import 'router.dart';

class AiGymBuddyApp extends StatefulWidget {
  const AiGymBuddyApp({super.key});

  @override
  State<AiGymBuddyApp> createState() => _AiGymBuddyAppState();
}

class _AiGymBuddyAppState extends State<AiGymBuddyApp> {
  late final AppDatabase _database;
  late final AppStateController _appState;
  GoRouter? _router;
  late final Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _appState = AppStateController();
    _bootstrapFuture = _bootstrap();
  }

  Future<void> _bootstrap() async {
    final seedRepository = SeedRepository(_database.exerciseDao);
    await seedRepository.seedExercisesIfEmpty();

    final profile = await _database.userProfileDao.getSingle();
    _appState.updateHasProfile(profile != null);
    _router = createRouter(_appState);
  }

  @override
  void dispose() {
    _router?.dispose();
    _database.close();
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            _router == null) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return AppStateScope(
          controller: _appState,
          child: AppDependencies(
            database: _database,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'AI Gym Buddy',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              routerConfig: _router!,
            ),
          ),
        );
      },
    );
  }
}
