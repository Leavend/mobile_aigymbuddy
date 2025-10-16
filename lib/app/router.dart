import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/session_controller.dart';
import 'app_scope.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/profile/profile_page.dart';
import 'features/progress/log_session_page.dart';
import 'features/progress/progress_page.dart';
import 'features/shared/home_page.dart';

class AppRouter {
  AppRouter(this._dependencies)
      : _router = GoRouter(
          initialLocation:
              _dependencies.sessionController.isOnboarded ? '/home' : '/onboarding',
          refreshListenable: _dependencies.sessionController,
          routes: [
            GoRoute(
              path: '/onboarding',
              name: 'onboarding',
              builder: (context, state) => const OnboardingPage(),
            ),
            ShellRoute(
              builder: (context, state, child) => HomePage(child: child),
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const ProgressPage(),
                  routes: [
                    GoRoute(
                      path: 'log-session',
                      name: 'log-session',
                      pageBuilder: (context, state) => MaterialPage<void>(
                        child: LogSessionPage(initialNote: state.uri.queryParameters['note']),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
          redirect: (context, state) {
            final onboarded = _dependencies.sessionController.isOnboarded;
            final goingToOnboarding = state.subloc == '/onboarding';
            if (!onboarded && !goingToOnboarding) {
              return '/onboarding';
            }
            if (onboarded && goingToOnboarding) {
              return '/home';
            }
            return null;
          },
        );

  final AppDependencies _dependencies;
  final GoRouter _router;

  GoRouter get router => _router;
}

extension BuildContextRouterX on BuildContext {
  AppDependencies get dependencies => AppScope.of(this);
  SessionController get sessionController => dependencies.sessionController;
}
