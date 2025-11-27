// lib/main.dart
import 'dart:async';

import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/di/service_locator.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/database_service.dart';
import 'package:aigymbuddy/database/repositories/user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator with error handling
  final serviceLocator = ServiceLocator();
  try {
    await serviceLocator.initialize();
  } catch (e, stackTrace) {
    debugPrint('Critical error initializing ServiceLocator: $e');
    debugPrint('Stack trace: $stackTrace');
    // Continue with minimal functionality if ServiceLocator fails
  }

  // Get database instance from service locator
  AppDatabase? db;
  try {
    db = ServiceLocator().database;

    // Verify database connection with enhanced logging
    await db.customSelect('SELECT 1').getSingle();
    debugPrint('Database connection verified successfully.');

    // Check database integrity
    final isValid = await ServiceLocator().databaseService
        .checkDatabaseIntegrity();
    if (isValid) {
      debugPrint('Database integrity check passed.');
    } else {
      debugPrint('Database integrity check failed - proceeding with caution.');
    }
  } catch (e) {
    debugPrint('Error verifying database connection: $e');
    debugPrint('App will continue with limited functionality.');
  }

  final hasCredentials = await AuthService.instance.hasSavedCredentials();
  final initialLocation = hasCredentials ? AppRoute.main : AppRoute.onboarding;

  debugPrint(
    'AI Gym Buddy starting with initialLocation=$initialLocation '
    '(hasCredentials=$hasCredentials)',
  );

  // Only run app if we have a valid database
  if (db != null) {
    runApp(MyApp(db: db, initialLocation: initialLocation));
  } else {
    // Fallback app without database functionality
    runApp(const ErrorApp(error: 'Database initialization failed'));
  }
}

/// Fallback widget to display when database fails to initialize
class ErrorApp extends StatelessWidget {

  const ErrorApp({required this.error, super.key});
  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    runApp(
                      const MaterialApp(
                        home: Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Main application widget
class MyApp extends StatefulWidget {
  const MyApp({
    required this.db,
    super.key,
    this.initialLocation,
  });

  final AppDatabase db;
  final String? initialLocation;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLanguageController _languageController = AppLanguageController();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(
      initialLocation: widget.initialLocation ?? AppRoute.onboarding,
    );
    
    // TODO: Add session expiry listener when app context is properly initialized
    // This requires refactoring to avoid accessing AuthService.instance before
    // ServiceLocator is initialized
  }

  @override
  void dispose() {
    try {
      // Dispose router first
      _router.dispose();

      // Dispose language controller
      _languageController.dispose();

      // Close database connection
      if (!widget.db.isClosed) {
        unawaited(widget.db.closeDb());
      }

      // Dispose service locator
      unawaited(ServiceLocator().dispose());
    } catch (e, stackTrace) {
      debugPrint('Error during app disposal: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    super.dispose();
  }

  void _handleSessionExpired() {
    // Navigate to login
    _router.go(AppRoute.login);
    
    // Show dialog if widget is still mounted
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Session Expired'),
              content: const Text(
                'Your session has expired. Please log in again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      controller: _languageController,
      child: MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: widget.db),
          Provider<DatabaseService>.value(
            value: ServiceLocator().databaseService,
          ),
          Provider<AuthRepositoryInterface>.value(
            value: ServiceLocator().authRepository,
          ),
          Provider<UserProfileRepositoryInterface>.value(
            value: ServiceLocator().userProfileRepository,
          ),
          Provider<AuthUseCase>.value(value: ServiceLocator().authUseCase),
          ChangeNotifierProvider<AuthController>.value(
            value: ServiceLocator().authController,
          ),
        ],
        child: MaterialApp.router(
          title: 'AI Gym Buddy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: TColor.primaryColor1,
            fontFamily: 'Poppins',
          ),
          routerConfig: _router,
        ),
      ),
    );
  }
}
