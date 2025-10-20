// lib/main.dart

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/di/app_scope.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/features/auth/application/auth_controller.dart';
import 'package:aigymbuddy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:aigymbuddy/features/auth/data/datasources/session_local_data_source.dart';
import 'package:aigymbuddy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:aigymbuddy/features/auth/data/repositories/session_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLanguageController _languageController;
  late final AppDatabase _database;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _languageController = AppLanguageController();
    _database = AppDatabase();
    final authLocalDataSource = AuthLocalDataSource(_database);
    final sessionLocalDataSource = SessionLocalDataSource();
    final authRepository = AuthRepositoryImpl(authLocalDataSource);
    final sessionRepository = SessionRepositoryImpl(sessionLocalDataSource);
    _authController = AuthController(
      authRepository: authRepository,
      sessionRepository: sessionRepository,
    );
  }

  @override
  void dispose() {
    _languageController.dispose();
    unawaited(_database.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      database: _database,
      authController: _authController,
      child: AppLanguageScope(
        controller: _languageController,
        child: MaterialApp.router(
          title: 'AI Gym Buddy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: TColor.primaryColor1,
            fontFamily: 'Poppins',
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
