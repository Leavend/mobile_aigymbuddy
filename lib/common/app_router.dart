// lib/common/app_router.dart

/// Central place for keeping route path constants used across the app.
///
/// The actual GoRouter configuration lives in `lib/app/router.dart`. Keeping
/// the path strings in a dedicated class ensures that existing widgets can
/// navigate without depending on the router implementation details.
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
