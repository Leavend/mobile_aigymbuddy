import 'package:go_router/go_router.dart';

import '../view/home/activity_tracker_view.dart';
import '../view/home/finished_workout_view.dart';
import '../view/home/notification_view.dart';
import '../view/login/complete_profile_view.dart';
import '../view/login/login_view.dart';
import '../view/login/signup_view.dart';
import '../view/login/welcome_view.dart';
import '../view/login/what_your_goal_view.dart';
import '../view/main_tab/main_tab_view.dart';
import '../view/main_tab/select_view.dart';
import '../view/meal_planner/food_info_details_view.dart';
import '../view/meal_planner/meal_food_details_view.dart';
import '../view/meal_planner/meal_planner_view.dart';
import '../view/meal_planner/meal_schedule_view.dart';
import '../view/on_boarding/on_boarding_view.dart';
import '../view/photo_progress/comparison_view.dart';
import '../view/photo_progress/photo_progress_view.dart';
import '../view/photo_progress/result_view.dart';
import '../view/profile/profile_view.dart';
import '../view/sleep_tracker/sleep_add_alarm_view.dart';
import '../view/sleep_tracker/sleep_schedule_view.dart';
import '../view/sleep_tracker/sleep_tracker_view.dart';
import '../view/workout_tracker/add_schedule_view.dart';
import '../view/workout_tracker/exercises_stpe_details.dart';
import '../view/workout_tracker/workout_schedule_view.dart';
import '../view/workout_tracker/workout_tracker_view.dart';
import '../view/workout_tracker/workour_detail_view.dart';

class AppRoute {
  static const String main = '/';
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
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.main,
    routes: [
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
          final extra = state.extra;
          if (extra is! DateTime) {
            throw ArgumentError('AddScheduleView requires a DateTime extra.');
          }
          return AddScheduleView(date: extra);
        },
      ),
      GoRoute(
        path: AppRoute.workoutDetail,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map) {
            throw ArgumentError('WorkoutDetailView requires a Map extra.');
          }
          return WorkoutDetailView(dObj: Map<String, dynamic>.from(extra as Map));
        },
      ),
      GoRoute(
        path: AppRoute.exerciseSteps,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map) {
            throw ArgumentError('ExercisesStepDetails requires a Map extra.');
          }
          return ExercisesStepDetails(eObj: Map<String, dynamic>.from(extra as Map));
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
          final extra = state.extra;
          if (extra is! Map) {
            throw ArgumentError('MealFoodDetailsView requires a Map extra.');
          }
          return MealFoodDetailsView(eObj: Map<String, dynamic>.from(extra as Map));
        },
      ),
      GoRoute(
        path: AppRoute.foodInfo,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map) {
            throw ArgumentError('FoodInfoDetailsView requires a Map extra.');
          }
          final map = Map<String, dynamic>.from(extra as Map);
          final meal = map['meal'];
          final food = map['food'];
          if (meal is! Map || food is! Map) {
            throw ArgumentError('FoodInfoDetailsView requires meal and food Map extras.');
          }
          return FoodInfoDetailsView(
            mObj: Map<String, dynamic>.from(meal),
            dObj: Map<String, dynamic>.from(food),
          );
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
          final extra = state.extra;
          if (extra is! Map) {
            throw ArgumentError('ResultView requires a Map extra.');
          }
          final map = Map<String, dynamic>.from(extra as Map);
          final date1 = map['date1'];
          final date2 = map['date2'];
          if (date1 is! DateTime || date2 is! DateTime) {
            throw ArgumentError('ResultView requires DateTime extras.');
          }
          return ResultView(date1: date1, date2: date2);
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
          final extra = state.extra;
          if (extra is! DateTime) {
            throw ArgumentError('SleepAddAlarmView requires a DateTime extra.');
          }
          return SleepAddAlarmView(date: extra);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/select',
        builder: (context, state) => const SelectView(),
      ),
    ],
  );
}