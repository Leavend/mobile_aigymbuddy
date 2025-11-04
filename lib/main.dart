// lib/main.dart

import 'dart:async';
import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  try {
    await db.customSelect('SELECT 1').getSingle();
    debugPrint("Database connection verified.");
  } catch (e) {
    debugPrint("Error verifying database connection: $e");
  }

  final hasCredentials = await AuthService.instance.hasSavedCredentials();
  final initialLocation = hasCredentials
      ? AppRoute.main
      : AppRoute.onboarding;

  debugPrint(
    'AI Gym Buddy starting with initialLocation=$initialLocation '
    '(hasCredentials=$hasCredentials)',
  );

  runApp(MyApp(db: db, initialLocation: initialLocation));
}

class MyApp extends StatefulWidget {
  final AppDatabase db;
  final String initialLocation;
  const MyApp({super.key, required this.db, required this.initialLocation});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLanguageController _languageController = AppLanguageController();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(initialLocation: widget.initialLocation);
  }

  @override
  void dispose() {
    unawaited(widget.db.closeDb());
    _router.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      controller: _languageController,
      child: MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: widget.db),
          Provider<AuthRepository>(create: (_) => AuthRepository(widget.db)),
          ChangeNotifierProvider<AuthController>(
            create: (context) =>
                AuthController(repository: context.read<AuthRepository>()),
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
