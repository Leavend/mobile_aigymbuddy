// lib/main.dart

import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of your language controller
  final languageController = AppLanguageController();

  runApp(
    // Wrap your entire app with the AppLanguageScope
    AppLanguageScope(
      controller: languageController,
      child: const AiGymBuddyApp(),
    ),
  );
}
