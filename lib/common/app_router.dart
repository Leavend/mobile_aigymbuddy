import 'package:aigymbuddy/view/home/activity_tracker_view.dart';
import 'package:aigymbuddy/view/home/finished_workout_view.dart';
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
import 'package:aigymbuddy/view/workout_tracker/workout_schedule_view.dart';
import 'package:aigymbuddy/view/workout_tracker/workout_tracker_view.dart';
import 'package:aigymbuddy/view/workout_tracker/workour_detail_view.dart';
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
  static const String mealPlanner = '/meal-planner';
  static const String mealSchedule = '/meal-planner/schedule';
  static const String mealFoodDetails = '/meal-planner/food-details';
  static const String foodInfo = '/meal-planner/food-info';
  static const String photoProgress = '/photo-progress';
  static const String photoComparison = '/photo-progress/comparison';
  static const String photoResult = '/photo-progress/result';
  static const String sleepTracker = '/sleep-tracker';
  static const String sleepSchedule = '/sleep-tracker/schedule';
  static const String sleepAddAlarm = '/sleep-tracker/add-alarm';
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
        path: AppRoute.main,
        builder: (context, state) => const MainTabView(),
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
        builder: (context, state) => const WorkoutTrackerView(),
      ),
      GoRoute(
        path: AppRoute.workoutSchedule,
        builder: (context, state) => const WorkoutScheduleView(),
      ),
      GoRoute(
        path: AppRoute.addWorkoutSchedule,
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
        builder: (context, state) {
          final args = _requireExtra<WorkoutDetailArgs>(
            state,
            'WorkoutDetailView requires WorkoutDetailArgs as extra.',
          );
          return WorkoutDetailView(dObj: args.workout);
        },
      ),
      GoRoute(
        path: AppRoute.exerciseSteps,
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
        builder: (context, state) {
          final args = _requireExtra<MealFoodDetailsArgs>(
            state,
            'MealFoodDetailsView requires MealFoodDetailsArgs as extra.',
          );
          return MealFoodDetailsView(eObj: args.food);
        },
      ),
      GoRoute(
        path: AppRoute.foodInfo,
        builder: (context, state) {
          final args = _requireExtra<FoodInfoArgs>(
            state,
            'FoodInfoDetailsView requires FoodInfoArgs as extra.',
          );
          return FoodInfoDetailsView(meal: args.meal, detail: args.food);
        },
      ),
      GoRoute(
        path: AppRoute.photoProgress,
        builder: (context, state) => const PhotoProgressView(),
      ),
      GoRoute(
        path: AppRoute.photoComparison,
        builder: (context, state) => const ComparisonView(),
      ),
      GoRoute(
        path: AppRoute.photoResult,
        builder: (context, state) {
          final args = _requireExtra<PhotoResultArgs>(
            state,
            'ResultView requires PhotoResultArgs as extra.',
          );
          return ResultView(date1: args.firstDate, date2: args.secondDate);
        },
      ),
      GoRoute(
        path: AppRoute.sleepTracker,
        builder: (context, state) => const SleepTrackerView(),
      ),
      GoRoute(
        path: AppRoute.sleepSchedule,
        builder: (context, state) => const SleepScheduleView(),
      ),
      GoRoute(
        path: AppRoute.sleepAddAlarm,
        builder: (context, state) {
          final args = _requireExtra<SleepAddAlarmArgs>(
            state,
            'SleepAddAlarmView requires SleepAddAlarmArgs as extra.',
          );
          return SleepAddAlarmView(date: args.date);
        },
      ),
      GoRoute(
        path: AppRoute.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoute.select,
        builder: (context, state) => const SelectView(),
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
