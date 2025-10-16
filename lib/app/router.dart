import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/profile/presentation/profile_form_page.dart';
import 'app_state.dart';

GoRouter createRouter(AppStateController appState) {
  return GoRouter(
    initialLocation: appState.hasProfile ? '/dashboard' : '/onboarding',
    refreshListenable: appState,
    redirect: (context, state) {
      final hasProfile = appState.hasProfile;
      final loggingIn = state.matchedLocation == '/onboarding';

      if (!hasProfile) {
        return loggingIn ? null : '/onboarding';
      }

      if (loggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const ProfileFormPage(isEditing: false),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            path: 'profile/edit',
            builder: (context, state) => const ProfileFormPage(isEditing: true),
          ),
        ],
      ),
    ],
  );
}
