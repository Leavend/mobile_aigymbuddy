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
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService.instance;
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleBootstrap());
  }

  Future<void> _handleBootstrap() async {
    final hasCredentials = await _authService.hasSavedCredentials();
    if (!mounted) return;

    final destination = hasCredentials ? AppRoute.main : AppRoute.onboarding;
    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
