// lib/main.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aigymbuddy/database/app_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  try {
    await db.customSelect('SELECT 1').getSingle();
    debugPrint("Database connection verified.");
  } catch (e) {
    debugPrint("Error verifying database connection: $e");
  }

  runApp(MyApp(db: db));
}

class MyApp extends StatefulWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLanguageController _languageController = AppLanguageController();

  @override
  void dispose() {
    widget.db.close();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      controller: _languageController,
      child: Provider<AppDatabase>.value(
        value: widget.db,
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
