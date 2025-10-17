// lib/view/shared/repositories/drift_meal_planner_repository.dart

import '../../common/localization/app_language.dart';
import '../../common/models/ingredient.dart';
import '../../common/models/instruction_step.dart';
import '../../common/models/nutrition_info.dart';
import '../../data/db/daos/meal_planner_dao.dart';
import '../models/meal/meal_category.dart';
import '../models/meal/meal_detail.dart';
import '../models/meal/meal_nutrition_progress.dart';
import '../models/meal/meal_period.dart';
import '../models/meal/meal_period_summary.dart';
import '../models/meal/meal_schedule_entry.dart';
import '../models/meal/meal_summary.dart';
import 'meal_planner_repository.dart';

class DriftMealPlannerRepository implements MealPlannerRepository {
  DriftMealPlannerRepository(this._store) {
    _seedFuture = _initialise();
  }

  final MealPlannerStore _store;
  late final Future<void> _seedFuture;

  Future<void> _initialise() async {
    final hasData = await _store.hasSeedData();
    if (!hasData) {
      await _store.seedData();
    }
  }

  Future<void> _ensureReady() => _seedFuture;

  @override
  Future<void> ensureSeeded() => _ensureReady();

  @override
  Stream<List<MealScheduleEntry>> watchMealsForDay(DateTime day) {
    return Stream.fromFuture(_ensureReady()).asyncExpand(
      (_) => _store.watchMealsForDay(day).map(
        (rows) => rows.map(_mapScheduleRow).toList(),
      ),
    );
  }

  @override
  Future<List<MealScheduleEntry>> fetchMealsForDay(DateTime day) async {
    await _ensureReady();
    final rows = await _store.listMealsForDay(day);
    return rows.map(_mapScheduleRow).toList();
  }

  @override
  Future<List<MealCategorySummary>> fetchCategories() async {
    await _ensureReady();
    final rows = await _store.listCategories();
    final counts = await _store.countMealsPerCategory();
    return rows
        .map(
          (row) => MealCategorySummary(
            id: row['id'] as int,
            title: LocalizedText(
              english: row['name_en'] as String,
              indonesian: row['name_id'] as String,
            ),
            imageAsset: row['image_asset'] as String,
            totalMeals: counts[row['id'] as int] ?? 0,
          ),
        )
        .toList();
  }

  @override
  Future<List<MealSummary>> fetchMealsByCategory(int categoryId) async {
    await _ensureReady();
    final rows = await _store.listMealsByCategory(categoryId);
    return rows.map(_mapMealSummary).toList();
  }

  @override
  Future<List<MealSummary>> fetchRecommendations() async {
    await _ensureReady();
    final rows = await _store.listMealsByCategory(2);
    return rows.take(4).map(_mapMealSummary).toList();
  }

  @override
  Future<List<MealSummary>> fetchPopularMeals() async {
    await _ensureReady();
    final rows = await _store.listPopularMeals();
    return rows.map(_mapMealSummary).toList();
  }

  @override
  Future<List<MealSummary>> searchMeals(String query) async {
    await _ensureReady();
    final rows = await _store.searchMealsByName(query);
    return rows.map(_mapMealSummary).toList();
  }

  @override
  Future<MealDetail?> fetchMealDetail(int id) async {
    await _ensureReady();
    final mealRow = await _store.findMealById(id);
    if (mealRow == null) return null;
    final facts = await _store.listNutritionFacts(id);
    final ingredients = await _store.listIngredients(id);
    final instructions = await _store.listInstructions(id);
    return MealDetail(
      id: id,
      name: LocalizedText(
        english: mealRow['name_en'] as String,
        indonesian: mealRow['name_id'] as String,
      ),
      description: LocalizedText(
        english: mealRow['description_en'] as String,
        indonesian: mealRow['description_id'] as String,
      ),
      imageAsset: mealRow['image_asset'] as String,
      heroImageAsset: mealRow['hero_image_asset'] as String,
      period: MealPeriodX.fromId(mealRow['period'] as String? ?? '') ??
          MealPeriod.breakfast,
      prepMinutes: mealRow['prep_minutes'] as int,
      nutrition: facts.map(_mapNutrition).toList(),
      ingredients: ingredients.map(_mapIngredient).toList(),
      instructions: instructions.map(_mapInstruction).toList(),
    );
  }

  @override
  Future<List<MealNutritionProgressPoint>> fetchWeeklyNutritionProgress() async {
    await _ensureReady();
    final today = DateTime.now();
    final end = DateTime(today.year, today.month, today.day);
    final start = end.subtract(const Duration(days: 6));
    final rows = await _store.listNutritionProgress(start, end);
    return rows
        .map(
          (row) => MealNutritionProgressPoint(
            day: DateTime.parse(row['day'] as String),
            completion: (row['completion'] as num).toDouble(),
          ),
        )
        .toList();
  }

  @override
  Future<List<MealPeriodSummary>> fetchPeriodSummaries() async {
    await _ensureReady();
    final counts = await _store.countMealsPerPeriod();
    return counts.entries
        .map(
          (entry) => MealPeriodSummary(
            period: MealPeriodX.fromId(entry.key) ?? MealPeriod.breakfast,
            totalMeals: entry.value,
          ),
        )
        .toList();
  }

  @override
  Future<List<NutritionInfo>> fetchDailyNutritionSummary(DateTime day) async {
    await _ensureReady();
    final entries = await fetchMealsForDay(day);
    final totals = <String, double>{
      'Calories': 0,
      'Proteins': 0,
      'Fats': 0,
      'Carbo': 0,
    };

    for (final entry in entries) {
      final facts = await _store.listNutritionFacts(entry.meal.id);
      for (final fact in facts) {
        final title = fact['title_en'] as String;
        final numeric = double.tryParse(
          (fact['value_en'] as String).replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        if (numeric == null) continue;
        totals.update(title, (value) => value + numeric, ifAbsent: () => numeric);
      }
    }

    return totals.entries
        .map(
          (entry) => NutritionInfo(
            image: _iconForNutrition(entry.key),
            title: entry.key,
            value: entry.value.toStringAsFixed(0),
          ),
        )
        .toList();
  }

  MealScheduleEntry _mapScheduleRow(Map<String, Object?> row) {
    final meal = _mapMealSummary(row);
    final scheduledAt = DateTime.parse(row['schedule_time'] as String);
    return MealScheduleEntry(
      id: row['schedule_id'] as int,
      meal: meal,
      scheduledAt: scheduledAt,
    );
  }

  MealSummary _mapMealSummary(Map<String, Object?> row) {
    final period = MealPeriodX.fromId(row['period'] as String? ?? '') ??
        MealPeriod.breakfast;
    return MealSummary(
      id: row['id'] as int,
      name: LocalizedText(
        english: row['name_en'] as String,
        indonesian: row['name_id'] as String,
      ),
      imageAsset: row['image_asset'] as String,
      heroImageAsset: row['hero_image_asset'] as String,
      period: period,
      prepMinutes: row['prep_minutes'] as int,
      sizeLabel: row['difficulty'] as String?,
      calories: row['calories'] as int?,
    );
  }

  NutritionInfo _mapNutrition(Map<String, Object?> row) {
    return NutritionInfo(
      image: row['image_asset'] as String,
      title: row['title_en'] as String,
      value: row['value_en'] as String,
    );
  }

  Ingredient _mapIngredient(Map<String, Object?> row) {
    return Ingredient(
      image: row['image_asset'] as String,
      name: row['name_en'] as String,
      amount: row['amount_en'] as String,
    );
  }

  InstructionStep _mapInstruction(Map<String, Object?> row) {
    return InstructionStep(
      number: (row['step_order'] as int).toString(),
      title: row['title_en'] as String?,
      description: row['description_en'] as String,
    );
  }

  String _iconForNutrition(String title) {
    switch (title) {
      case 'Proteins':
        return 'assets/img/proteins.png';
      case 'Fats':
        return 'assets/img/egg.png';
      case 'Carbo':
        return 'assets/img/carbo.png';
      default:
        return 'assets/img/burn.png';
    }
  }
}
