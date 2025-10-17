// lib/app/router.dart

import 'package:go_router/go_router.dart';

import '../common/app_router.dart';
import '../view/home/home_view.dart';
import '../view/login/complete_profile_view.dart';
import '../view/login/login_view.dart';
import '../view/login/models/onboarding_draft.dart';
import '../view/login/signup_view.dart';
import '../view/login/welcome_view.dart';
import '../view/login/what_your_goal_view.dart';
import '../view/on_boarding/on_boarding_view.dart';
import '../view/profile/profile_view.dart';
import 'app_state.dart';

GoRouter createRouter(AppStateController appState) {
  const onboardingRoutes = {
    AppRoute.onboarding,
    AppRoute.signUp,
    AppRoute.login,
    AppRoute.completeProfile,
    AppRoute.goal,
    AppRoute.welcome,
  };

  return GoRouter(
    initialLocation: appState.hasProfile ? AppRoute.main : AppRoute.onboarding,
    refreshListenable: appState,
    redirect: (context, state) {
      final location = state.uri.path;
      final hasProfile = appState.hasProfile;
      final isOnboardingRoute = onboardingRoutes.contains(location);

      if (!hasProfile && !isOnboardingRoute) {
        return AppRoute.onboarding;
      }

      if (hasProfile && isOnboardingRoute) {
        return AppRoute.main;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.onboarding,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: AppRoute.signUp,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoute.completeProfile,
        builder: (context, state) {
          final args = state.extra as ProfileFormArguments?;
          if (args == null) {
            throw ArgumentError(
              'CompleteProfileView requires ProfileFormArguments via state.extra.',
            );
          }
          return CompleteProfileView(args: args);
        },
      ),
      GoRoute(
        path: AppRoute.goal,
        builder: (context, state) {
          final args = state.extra as ProfileFormArguments?;
          if (args == null) {
            throw ArgumentError(
              'WhatYourGoalView requires ProfileFormArguments via state.extra.',
            );
          }
          return WhatYourGoalView(args: args);
        },
      ),
      GoRoute(
        path: AppRoute.welcome,
        builder: (context, state) {
          final args = state.extra as WelcomeArgs?;
          return WelcomeView(args: args);
        },
      ),
      GoRoute(
        path: AppRoute.main,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoute.profile,
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
}
