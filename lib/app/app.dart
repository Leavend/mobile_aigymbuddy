import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'bootstrap.dart';
import 'router.dart';
import 'theme.dart';

class AiGymBuddyApp extends StatefulWidget {
  const AiGymBuddyApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<AiGymBuddyApp> createState() => _AiGymBuddyAppState();
}

class _AiGymBuddyAppState extends State<AiGymBuddyApp> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(widget.dependencies);
  }

  @override
  void dispose() {
    widget.dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      dependencies: widget.dependencies,
      child: MaterialApp.router(
        title: 'AI Gym Buddy',
        theme: AppTheme.light,
        routerConfig: _router.router,
      ),
    );
  }
}
