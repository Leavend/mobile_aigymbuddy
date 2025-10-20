// lib/common/app_router.dart

import 'package:aigymbuddy/view/home/activity_tracker_view.dart';
import 'package:aigymbuddy/view/home/finished_workout_view.dart';
import 'package:aigymbuddy/view/home/home_view.dart';
import 'package:aigymbuddy/view/home/notification_view.dart';
import 'package:aigymbuddy/view/login/complete_profile_view.dart';
import 'package:aigymbuddy/view/login/login_view.dart';
import 'package:aigymbuddy/view/login/signup_view.dart';
import 'package:aigymbuddy/view/login/welcome_view.dart';
import 'package:aigymbuddy/view/login/what_your_goal_view.dart';
import 'package:aigymbuddy/view/main_tab/main_tab_view.dart';
import 'package:aigymbuddy/view/main_tab/select_view.dart';
import 'package:aigymbuddy/view/meal_planner/food_info_details_view.dart';
import 'package:aigymbuddy/view/meal_planner/meal_food_details_view.dart';
import 'package:aigymbuddy/view/meal_planner/meal_planner_view.dart';
import 'package:aigymbuddy/view/meal_planner/meal_schedule_view.dart';
import 'package:aigymbuddy/view/on_boarding/on_boarding_view.dart';
import 'package:aigymbuddy/view/photo_progress/comparison_view.dart';
import 'package:aigymbuddy/view/photo_progress/photo_progress_view.dart';
import 'package:aigymbuddy/view/photo_progress/result_view.dart';
import 'package:aigymbuddy/view/profile/profile_view.dart';
import 'package:aigymbuddy/view/sleep_tracker/sleep_add_alarm_view.dart';
import 'package:aigymbuddy/view/sleep_tracker/sleep_schedule_view.dart';
import 'package:aigymbuddy/view/sleep_tracker/sleep_tracker_view.dart';
import 'package:aigymbuddy/view/splash/launch_view.dart';
import 'package:aigymbuddy/view/workout_tracker/add_schedule_view.dart';
import 'package:aigymbuddy/view/workout_tracker/exercises_step_details.dart';
import 'package:aigymbuddy/view/workout_tracker/workout_detail_view.dart';
import 'package:aigymbuddy/view/workout_tracker/workout_schedule_view.dart';
import 'package:aigymbuddy/view/workout_tracker/workout_tracker_view.dart';

// import 'package:aigymbuddy/view/test/drift_test_view.dart';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'models/navigation_args.dart';

class AppRoute {
  static const String launch = '/';
  static const String main = '/home';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String completeProfile = '/complete-profile';
  static const String goal = '/goal';
  static const String welcome = '/welcome';
  static const String activityTracker = '/activity-tracker';
  static const String notification = '/notification';
  static const String finishedWorkout = '/finished-workout';
  static const String workoutTracker = '/workout-tracker';
  static const String workoutSchedule = '/workout-schedule';
  static const String addWorkoutSchedule = '/workout-schedule/add';
  static const String workoutDetail = '/workout-detail';
  static const String exerciseSteps = '/exercise-steps';
  static const String workoutTrackerName = 'workout-tracker';
  static const String workoutScheduleName = 'workout-schedule';
  static const String addWorkoutScheduleName = 'add-workout-schedule';
  static const String workoutDetailName = 'workout-detail';
  static const String exerciseStepsName = 'exercise-steps';
  static const String mealPlanner = '/meal-planner';
  static const String mealSchedule = '/meal-planner/schedule';
  static const String mealFoodDetails = '/meal-planner/food-details';
  static const String foodInfo = '/meal-planner/food-info';
  static const String photoProgress = '/photo-progress';
  static const String photoComparison = '/photo-progress/comparison';
  static const String photoResult = '/photo-progress/result';
  static const String photoProgressName = 'photo-progress';
  static const String photoComparisonName = 'photo-comparison';
  static const String photoResultName = 'photo-result';
  static const String sleepTracker = '/sleep-tracker';
  static const String sleepSchedule = '/sleep-tracker/schedule';
  static const String sleepAddAlarm = '/sleep-tracker/add-alarm';
  static const String sleepTrackerName = 'sleep-tracker';
  static const String sleepScheduleName = 'sleep-schedule';
  static const String sleepAddAlarmName = 'sleep-add-alarm';
  static const String profile = '/profile';
  static const String select = '/select';

  // static const String testDrift = '/test-drift';
}

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeBranch');
  static final GlobalKey<NavigatorState> _selectNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'selectBranch');
  static final GlobalKey<NavigatorState> _photoNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'photoBranch');
  static final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profileBranch');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    // initialLocation: AppRoute.testDrift,'
    initialLocation: AppRoute.launch,
    routes: [
      _simpleRoute(
        path: AppRoute.launch,
        builder: (context) => const LaunchView(),
      ),
      _simpleRoute(
        path: AppRoute.onboarding,
        builder: (context) => const OnBoardingView(),
      ),
      _simpleRoute(
        path: AppRoute.login,
        builder: (context) => const LoginView(),
      ),
      _simpleRoute(
        path: AppRoute.signUp,
        builder: (context) => const SignUpView(),
      ),
      _simpleRoute(
        path: AppRoute.completeProfile,
        builder: (context) => const CompleteProfileView(),
      ),
      _simpleRoute(
        path: AppRoute.goal,
        builder: (context) => const WhatYourGoalView(),
      ),
      _simpleRoute(
        path: AppRoute.welcome,
        builder: (context) => const WelcomeView(),
      ),
      _buildMainShell(),
      ..._standaloneRoutes,
    ],
  );

  static RouteBase _buildMainShell() {
    return StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, navigationShell) =>
          MainTabView(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            _simpleRoute(
              path: AppRoute.main,
              builder: (context) => const HomeView(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _selectNavigatorKey,
          routes: [
            _simpleRoute(
              path: AppRoute.select,
              builder: (context) => const SelectView(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _photoNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoute.photoProgress,
              name: AppRoute.photoProgressName,
              builder: (context, state) => const PhotoProgressView(),
              routes: [
                _simpleRoute(
                  path: 'comparison',
                  name: AppRoute.photoComparisonName,
                  builder: (context) => const ComparisonView(),
                ),
                _extraRoute<PhotoResultArgs>(
                  path: 'result',
                  name: AppRoute.photoResultName,
                  missingExtraMessage:
                      'ResultView requires PhotoResultArgs as extra.',
                  builder: (context, args) =>
                      ResultView(date1: args.firstDate, date2: args.secondDate),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            _simpleRoute(
              path: AppRoute.profile,
              builder: (context) => const ProfileView(),
            ),
          ],
        ),
      ],
    );
  }

  static List<RouteBase> get _standaloneRoutes => [
    _simpleRoute(
      path: AppRoute.activityTracker,
      builder: (context) => const ActivityTrackerView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _simpleRoute(
      path: AppRoute.notification,
      builder: (context) => const NotificationView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _simpleRoute(
      path: AppRoute.finishedWorkout,
      builder: (context) => const FinishedWorkoutView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _simpleRoute(
      path: AppRoute.workoutTracker,
      name: AppRoute.workoutTrackerName,
      builder: (context) => const WorkoutTrackerView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _simpleRoute(
      path: AppRoute.workoutSchedule,
      name: AppRoute.workoutScheduleName,
      builder: (context) => const WorkoutScheduleView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _extraRoute<AddScheduleArgs>(
      path: AppRoute.addWorkoutSchedule,
      name: AppRoute.addWorkoutScheduleName,
      parentNavigatorKey: rootNavigatorKey,
      missingExtraMessage: 'AddScheduleView requires AddScheduleArgs as extra.',
      builder: (context, args) => AddScheduleView(date: args.date),
    ),
    _extraRoute<WorkoutDetailArgs>(
      path: AppRoute.workoutDetail,
      name: AppRoute.workoutDetailName,
      parentNavigatorKey: rootNavigatorKey,
      missingExtraMessage:
          'WorkoutDetailView requires WorkoutDetailArgs as extra.',
      builder: (context, args) => WorkoutDetailView(workout: args.workout),
    ),
    _extraRoute<ExerciseStepsArgs>(
      path: AppRoute.exerciseSteps,
      name: AppRoute.exerciseStepsName,
      parentNavigatorKey: rootNavigatorKey,
      missingExtraMessage:
          'ExercisesStepDetails requires ExerciseStepsArgs as extra.',
      builder: (context, args) => ExercisesStepDetails(exercise: args.exercise),
    ),
    _simpleRoute(
      path: AppRoute.mealPlanner,
      builder: (context) => const MealPlannerView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _simpleRoute(
      path: AppRoute.mealSchedule,
      builder: (context) => const MealScheduleView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _extraRoute<MealFoodDetailsArgs>(
      path: AppRoute.mealFoodDetails,
      parentNavigatorKey: rootNavigatorKey,
      missingExtraMessage:
          'MealFoodDetailsView requires MealFoodDetailsArgs as extra.',
      builder: (context, args) => MealFoodDetailsView(eObj: args.food),
    ),
    _extraRoute<FoodInfoArgs>(
      path: AppRoute.foodInfo,
      parentNavigatorKey: rootNavigatorKey,
      missingExtraMessage:
          'FoodInfoDetailsView requires FoodInfoArgs as extra.',
      builder: (context, args) =>
          FoodInfoDetailsView(meal: args.meal, detail: args.food),
    ),
    _simpleRoute(
      path: AppRoute.sleepTracker,
      name: AppRoute.sleepTrackerName,
      builder: (context) => const SleepTrackerView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _simpleRoute(
      path: AppRoute.sleepSchedule,
      name: AppRoute.sleepScheduleName,
      builder: (context) => const SleepScheduleView(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    _extraRoute<SleepAddAlarmArgs>(
      path: AppRoute.sleepAddAlarm,
      name: AppRoute.sleepAddAlarmName,
      parentNavigatorKey: rootNavigatorKey,
      missingExtraMessage:
          'SleepAddAlarmView requires SleepAddAlarmArgs as extra.',
      builder: (context, args) => SleepAddAlarmView(date: args.date),
    ),
  ];

  static GoRoute _simpleRoute({
    required String path,
    String? name,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    required WidgetBuilder builder,
  }) {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: parentNavigatorKey,
      builder: (context, state) => builder(context),
    );
  }

  static GoRoute _extraRoute<T extends Object>({
    required String path,
    String? name,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    required String missingExtraMessage,
    required Widget Function(BuildContext context, T args) builder,
  }) {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: parentNavigatorKey,
      builder: (context, state) {
        final args = _requireExtra<T>(state, missingExtraMessage);
        return builder(context, args);
      },
    );
  }
}

T _requireExtra<T extends Object>(GoRouterState state, String message) {
  final extra = state.extra;
  if (extra is! T) {
    throw ArgumentError(message);
  }
  return extra;
}
