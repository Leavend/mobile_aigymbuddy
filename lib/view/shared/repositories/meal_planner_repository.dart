// lib/view/shared/repositories/meal_planner_repository.dart

import 'package:aigymbuddy/common/models/nutrition_info.dart';
import '../models/meal/meal_category.dart';
import '../models/meal/meal_detail.dart';
import '../models/meal/meal_nutrition_progress.dart';
import '../models/meal/meal_period_summary.dart';
import '../models/meal/meal_schedule_entry.dart';
import '../models/meal/meal_summary.dart';

abstract class MealPlannerRepository {
  Future<void> ensureSeeded();

  Stream<List<MealScheduleEntry>> watchMealsForDay(DateTime day);

  Future<List<MealScheduleEntry>> fetchMealsForDay(DateTime day);

  Future<List<MealCategorySummary>> fetchCategories();

  Future<List<MealSummary>> fetchMealsByCategory(int categoryId);

  Future<List<MealSummary>> fetchRecommendations();

  Future<List<MealSummary>> fetchPopularMeals();

  Future<List<MealSummary>> searchMeals(String query);

  Future<MealDetail?> fetchMealDetail(int id);

  Future<List<MealNutritionProgressPoint>> fetchWeeklyNutritionProgress();

  Future<List<MealPeriodSummary>> fetchPeriodSummaries();

  Future<List<NutritionInfo>> fetchDailyNutritionSummary(DateTime day);
}
