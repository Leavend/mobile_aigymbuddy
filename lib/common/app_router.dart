import 'package:aigymbuddy/view/home/activity_tracker_view.dart';
import 'package:aigymbuddy/view/home/finished_workout_view.dart';
import 'package:aigymbuddy/view/home/notification_view.dart';
import 'package:aigymbuddy/view/home/home_view.dart';
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
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.launch,
    routes: [
      GoRoute(
        path: AppRoute.launch,
        builder: (context, state) => const LaunchView(),
      ),
      GoRoute(
        path: AppRoute.onboarding,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoute.signUp,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: AppRoute.completeProfile,
        builder: (context, state) => const CompleteProfileView(),
      ),
      GoRoute(
        path: AppRoute.goal,
        builder: (context, state) => const WhatYourGoalView(),
      ),
      GoRoute(
        path: AppRoute.welcome,
        builder: (context, state) => const WelcomeView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainTabView(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.main,
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.select,
                builder: (context, state) => const SelectView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.photoProgress,
                name: AppRoute.photoProgressName,
                builder: (context, state) => const PhotoProgressView(),
                routes: [
                  GoRoute(
                    path: 'comparison',
                    name: AppRoute.photoComparisonName,
                    builder: (context, state) => const ComparisonView(),
                  ),
                  GoRoute(
                    path: 'result',
                    name: AppRoute.photoResultName,
                    builder: (context, state) => _buildPhotoResultView(state),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.profile,
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.activityTracker,
        builder: (context, state) => const ActivityTrackerView(),
      ),
      GoRoute(
        path: AppRoute.notification,
        builder: (context, state) => const NotificationView(),
      ),
      GoRoute(
        path: AppRoute.finishedWorkout,
        builder: (context, state) => const FinishedWorkoutView(),
      ),
      GoRoute(
        path: AppRoute.workoutTracker,
        name: AppRoute.workoutTrackerName,
        builder: (context, state) => const WorkoutTrackerView(),
      ),
      GoRoute(
        path: AppRoute.workoutSchedule,
        name: AppRoute.workoutScheduleName,
        builder: (context, state) => const WorkoutScheduleView(),
      ),
      GoRoute(
        path: AppRoute.addWorkoutSchedule,
        name: AppRoute.addWorkoutScheduleName,
        builder: (context, state) {
          final args = _requireExtra<AddScheduleArgs>(
            state,
            'AddScheduleView requires AddScheduleArgs as extra.',
          );
          return AddScheduleView(date: args.date);
        },
      ),
      GoRoute(
        path: AppRoute.workoutDetail,
        name: AppRoute.workoutDetailName,
        builder: (context, state) {
          final args = _requireExtra<WorkoutDetailArgs>(
            state,
            'WorkoutDetailView requires WorkoutDetailArgs as extra.',
          );
          return WorkoutDetailView(workout: args.workout);
        },
      ),
      GoRoute(
        path: AppRoute.exerciseSteps,
        name: AppRoute.exerciseStepsName,
        builder: (context, state) {
          final args = _requireExtra<ExerciseStepsArgs>(
            state,
            'ExercisesStepDetails requires ExerciseStepsArgs as extra.',
          );
          return ExercisesStepDetails(exercise: args.exercise);
        },
      ),
      GoRoute(
        path: AppRoute.mealPlanner,
        builder: (context, state) => const MealPlannerView(),
      ),
      GoRoute(
        path: AppRoute.mealSchedule,
        builder: (context, state) => const MealScheduleView(),
      ),
      GoRoute(
        path: AppRoute.mealFoodDetails,
        builder: (context, state) => _buildMealFoodDetailsView(state),
      ),
      GoRoute(
        path: AppRoute.foodInfo,
        builder: (context, state) => _buildFoodInfoDetailsView(state),
      ),
      GoRoute(
        path: AppRoute.sleepTracker,
        name: AppRoute.sleepTrackerName,
        builder: (context, state) => const SleepTrackerView(),
      ),
      GoRoute(
        path: AppRoute.sleepSchedule,
        name: AppRoute.sleepScheduleName,
        builder: (context, state) => const SleepScheduleView(),
      ),
      GoRoute(
        path: AppRoute.sleepAddAlarm,
        name: AppRoute.sleepAddAlarmName,
        builder: (context, state) => _buildSleepAddAlarmView(state),
      ),
    ],
  );
}

T _requireExtra<T extends Object>(GoRouterState state, String message) {
  final extra = state.extra;
  if (extra is! T) {
    throw ArgumentError(message);
  }
  return extra;
}

MealFoodDetailsView _buildMealFoodDetailsView(GoRouterState state) {
  final args = _requireExtra<MealFoodDetailsArgs>(
    state,
    'MealFoodDetailsView requires MealFoodDetailsArgs as extra.',
  );
  return MealFoodDetailsView(eObj: args.food);
}

FoodInfoDetailsView _buildFoodInfoDetailsView(GoRouterState state) {
  final args = _requireExtra<FoodInfoArgs>(
    state,
    'FoodInfoDetailsView requires FoodInfoArgs as extra.',
  );
  return FoodInfoDetailsView(meal: args.meal, detail: args.food);
}

ResultView _buildPhotoResultView(GoRouterState state) {
  final args = _requireExtra<PhotoResultArgs>(
    state,
    'ResultView requires PhotoResultArgs as extra.',
  );
  return ResultView(date1: args.firstDate, date2: args.secondDate);
}

SleepAddAlarmView _buildSleepAddAlarmView(GoRouterState state) {
  final args = _requireExtra<SleepAddAlarmArgs>(
    state,
    'SleepAddAlarmView requires SleepAddAlarmArgs as extra.',
  );
  return SleepAddAlarmView(date: args.date);
}
