import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({super.key});

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final hasCredentials = await AuthService.instance.hasSavedCredentials();
    if (!mounted) return;

    if (hasCredentials) {
      context.go(AppRoute.main);
    } else {
      context.go(AppRoute.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
