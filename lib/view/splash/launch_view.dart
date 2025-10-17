// lib/view/splash/launch_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _LaunchStatus { loading, failure }

class LaunchView extends StatefulWidget {
  const LaunchView({
    super.key,
    AuthService? authService,
    this.navigationDelay = Duration.zero,
  }) : authService = authService ?? AuthService.instance;

  final AuthService authService;
  final Duration navigationDelay;

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  static const LocalizedText _loadingMessage = LocalizedText(
    english: 'Preparing your experience…',
    indonesian: 'Menyiapkan pengalaman Anda…',
  );

  static const LocalizedText _errorMessage = LocalizedText(
    english: 'We ran into a problem starting the app. Please try again.',
    indonesian: 'Terjadi masalah saat memulai aplikasi. Silakan coba lagi.',
  );

  static const LocalizedText _retryLabel = LocalizedText(
    english: 'Try again',
    indonesian: 'Coba lagi',
  );

  _LaunchStatus _status = _LaunchStatus.loading;
  Object? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startBootstrap());
  }

  Future<void> _startBootstrap() async {
    setState(() {
      _status = _LaunchStatus.loading;
      _error = null;
    });

    try {
      final hasCredentials = await widget.authService.hasSavedCredentials();
      if (!mounted) return;

      final destination = hasCredentials ? AppRoute.main : AppRoute.onboarding;
      await _navigate(destination);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'view/splash',
          informationCollector: () => [
            DiagnosticsProperty<LaunchView>('launchView', widget),
          ],
        ),
      );

      if (!mounted) return;

      setState(() {
        _status = _LaunchStatus.failure;
        _error = error;
      });
    }
  }

  Future<void> _navigate(String destination) async {
    if (widget.navigationDelay > Duration.zero) {
      await Future.delayed(widget.navigationDelay);
      if (!mounted) return;
    }

    if (!mounted) return;
    context.go(destination);
  }

  void _handleRetry() => _startBootstrap();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final localize = context.localize;

    final isLoading = _status == _LaunchStatus.loading;
    final content = isLoading
        ? _LoadingContent(message: localize(_loadingMessage))
        : _ErrorContent(
            message: localize(_errorMessage),
            retryLabel: localize(_retryLabel),
            onRetry: _handleRetry,
            debugDetails: kDebugMode && _error != null ? '$_error' : null,
            textTheme: textTheme,
            colorScheme: colorScheme,
          );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey(_LaunchStatus.loading),
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          message,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    required this.textTheme,
    required this.colorScheme,
    this.debugDetails,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final String? debugDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey(_LaunchStatus.failure),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 48, color: colorScheme.error),
        const SizedBox(height: 16),
        Text(
          message,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onRetry,
          child: Text(retryLabel),
        ),
        if (debugDetails != null) ...[
          const SizedBox(height: 12),
          Text(
            debugDetails!,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
