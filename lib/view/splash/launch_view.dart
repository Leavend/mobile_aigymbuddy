import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
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
    final hasCredentials = await _authService.hasSavedCredentials();
    if (!mounted) return;

    final destination = hasCredentials ? AppRoute.main : AppRoute.onboarding;
    context.go(destination);
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
