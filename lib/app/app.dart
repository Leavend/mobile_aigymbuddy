// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/db/app_database.dart';
import 'app_state.dart';
import 'bootstrap.dart';
import 'dependencies.dart';

class AiGymBuddyApp extends StatefulWidget {
  const AiGymBuddyApp({super.key});

  @override
  State<AiGymBuddyApp> createState() => _AiGymBuddyAppState();
}

class _AiGymBuddyAppState extends State<AiGymBuddyApp> {
  late final AppDatabase _database;
  late final AppStateController _appState;
  late final AppBootstrapper _bootstrapper;
  late Future<AppBootstrapData> _bootstrapFuture;
  GoRouter? _activeRouter;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _appState = AppStateController();
    _bootstrapper = AppBootstrapper(_database, _appState);
    _bootstrapFuture = _createBootstrapFuture();
  }

  Future<AppBootstrapData> _createBootstrapFuture() {
    return _bootstrapper.initialize().then((result) {
      _activeRouter?.dispose();
      _activeRouter = result.router;
      return result;
    });
  }

  void _retryBootstrap() {
    setState(() {
      _bootstrapFuture = _createBootstrapFuture();
    });
  }

  @override
  void dispose() {
    _activeRouter?.dispose();
    _database.close();
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _createAppTheme();
    return FutureBuilder<AppBootstrapData>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildLoadingApp(theme);
        }

        if (snapshot.hasError || snapshot.data == null) {
          final errorMessage = snapshot.hasError
              ? 'Gagal memulai aplikasi. ${snapshot.error}'
              : 'Gagal memulai aplikasi. Silakan coba lagi.';
          return _buildErrorApp(theme, errorMessage);
        }

        final router = snapshot.data!.router;
        return AppStateScope(
          controller: _appState,
          child: AppDependencies(
            database: _database,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'AI Gym Buddy',
              theme: theme,
              routerConfig: router,
            ),
          ),
        );
      },
    );
  }

  ThemeData _createAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      fontFamily: 'Poppins',
    );
  }

  Widget _buildLoadingApp(ThemeData theme) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorApp(ThemeData theme, String message) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _retryBootstrap,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
