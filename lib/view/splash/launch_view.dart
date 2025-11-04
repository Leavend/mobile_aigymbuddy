// lib/view/splash/launch_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common/services/error_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({super.key});

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  static const LocalizedText _loadingMessage = LocalizedText(
    english: 'Preparing your experience…',
    indonesian: 'Menyiapkan pengalaman Anda…',
  );

  final AuthService _authService = AuthService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleBootstrap());
  }

  Future<void> _handleBootstrap() async {
    try {
      ErrorService.logDebug('LaunchView', 'Checking saved credentials');
      final hasCredentials = await _authService.hasSavedCredentials();
      if (!mounted) return;

      final destination = hasCredentials ? AppRoute.main : AppRoute.onboarding;
      ErrorService.logDebug(
        'LaunchView',
        'Navigating to '
            'destination=$destination (hasCredentials=$hasCredentials)',
      );
      context.go(destination);
    } catch (error, stackTrace) {
      ErrorService.logError('Launch bootstrap', error, stackTrace);
      if (!mounted) return;

      ErrorService.logDebug(
        'LaunchView',
        'Navigation fallback to onboarding after bootstrap error',
      );
      context.go(AppRoute.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadingText = context.localize(_loadingMessage);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                loadingText,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
