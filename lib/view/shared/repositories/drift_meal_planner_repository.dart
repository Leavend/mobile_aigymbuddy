// lib/view/shared/repositories/drift_meal_planner_repository.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/models/ingredient.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:aigymbuddy/common/models/nutrition_info.dart';
import 'package:aigymbuddy/data/db/daos/meal_planner_dao.dart';
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
    return _watchAfterReady(
      () => _store.watchMealsForDay(day).map(
            (rows) => List.unmodifiable(rows.map(_mapScheduleRow)),
          ),
    );
  }

  @override
  Future<List<MealScheduleEntry>> fetchMealsForDay(DateTime day) {
    return _runAfterReady(() async {
      final rows = await _store.listMealsForDay(day);
      return List.unmodifiable(rows.map(_mapScheduleRow));
    });
  }

  @override
  Future<List<MealCategorySummary>> fetchCategories() {
    return _runAfterReady(() async {
      final rows = await _store.listCategories();
      final counts = await _store.countMealsPerCategory();
      return List.unmodifiable(
        rows.map(
          (row) => MealCategorySummary(
            id: row['id'] as int,
            title: _localizedText(row, 'name_en', 'name_id'),
            imageAsset: row['image_asset'] as String,
            totalMeals: counts[row['id'] as int] ?? 0,
          ),
        ),
      );
    });
  }

  @override
  Future<List<MealSummary>> fetchMealsByCategory(int categoryId) {
    return _fetchMealSummaries(() => _store.listMealsByCategory(categoryId));
  }

  @override
  Future<List<MealSummary>> fetchRecommendations() {
    return _fetchMealSummaries(() async {
      final rows = await _store.listMealsByCategory(2);
      return rows.take(4).toList();
    });
  }

  @override
  Future<List<MealSummary>> fetchPopularMeals() {
    return _fetchMealSummaries(_store.listPopularMeals);
  }

  @override
  Future<List<MealSummary>> searchMeals(String query) {
    return _fetchMealSummaries(() => _store.searchMealsByName(query));
  }

  @override
  Future<MealDetail?> fetchMealDetail(int id) {
    return _runAfterReady(() async {
      final mealRow = await _store.findMealById(id);
      if (mealRow == null) return null;

      final facts = await _store.listNutritionFacts(id);
      final ingredients = await _store.listIngredients(id);
      final instructions = await _store.listInstructions(id);

      return MealDetail(
        id: id,
        name: _localizedText(mealRow, 'name_en', 'name_id'),
        description: _localizedText(
          mealRow,
          'description_en',
          'description_id',
        ),
        imageAsset: mealRow['image_asset'] as String,
        heroImageAsset: mealRow['hero_image_asset'] as String,
        period: MealPeriodX.fromId(mealRow['period'] as String? ?? '') ??
            MealPeriod.breakfast,
        prepMinutes: mealRow['prep_minutes'] as int,
        nutrition: List.unmodifiable(facts.map(_mapNutrition)),
        ingredients: List.unmodifiable(ingredients.map(_mapIngredient)),
        instructions: List.unmodifiable(instructions.map(_mapInstruction)),
      );
    });
  }

  @override
  Future<List<MealNutritionProgressPoint>> fetchWeeklyNutritionProgress() {
    return _runAfterReady(() async {
      final today = DateTime.now();
      final end = DateTime(today.year, today.month, today.day);
      final start = end.subtract(const Duration(days: 6));
      final rows = await _store.listNutritionProgress(start, end);
      return List.unmodifiable(
        rows.map(
          (row) => MealNutritionProgressPoint(
            day: DateTime.parse(row['day'] as String),
            completion: (row['completion'] as num).toDouble(),
          ),
        ),
      );
    });
  }

  @override
  Future<List<MealPeriodSummary>> fetchPeriodSummaries() {
    return _runAfterReady(() async {
      final counts = await _store.countMealsPerPeriod();
      return List.unmodifiable(
        counts.entries.map(
          (entry) => MealPeriodSummary(
            period: MealPeriodX.fromId(entry.key) ?? MealPeriod.breakfast,
            totalMeals: entry.value,
          ),
        ),
      );
    });
  }

  @override
  Future<List<NutritionInfo>> fetchDailyNutritionSummary(DateTime day) {
    return _runAfterReady(() async {
      final entries = await fetchMealsForDay(day);
      if (entries.isEmpty) {
        return const <NutritionInfo>[];
      }

      final totals = <String, double>{
        'Calories': 0,
        'Proteins': 0,
        'Fats': 0,
        'Carbo': 0,
      };

      final nutritionRows = await Future.wait(
        entries.map((entry) => _store.listNutritionFacts(entry.meal.id)),
      );

      for (final facts in nutritionRows) {
        for (final fact in facts) {
          final title = fact['title_en'] as String;
          final numeric = _parseNutritionValue(fact['value_en'] as String?);
          if (numeric == null) continue;
          totals.update(title, (value) => value + numeric,
              ifAbsent: () => numeric);
        }
      }

      return List.unmodifiable(
        totals.entries.map(
          (entry) => NutritionInfo(
            image: _iconForNutrition(entry.key),
            title: entry.key,
            value: entry.value.toStringAsFixed(0),
          ),
        ),
      );
    });
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
      name: _localizedText(row, 'name_en', 'name_id'),
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

  LocalizedText _localizedText(
    Map<String, Object?> row,
    String englishKey,
    String indonesianKey,
  ) {
    return LocalizedText(
      english: row[englishKey] as String,
      indonesian: row[indonesianKey] as String,
    );
  }

  double? _parseNutritionValue(String? value) {
    if (value == null) return null;
    final match = RegExp(r'[0-9]+(?:\.[0-9]+)?').firstMatch(value);
    if (match == null) return null;
    return double.tryParse(match.group(0)!);
  }

  String _iconForNutrition(String title) {
    return _nutritionIcons[title] ?? 'assets/img/burn.png';
  }

  Future<T> _runAfterReady<T>(Future<T> Function() action) async {
    await _ensureReady();
    return action();
  }

  Stream<T> _watchAfterReady<T>(Stream<T> Function() streamFactory) {
    return Stream.fromFuture(_ensureReady()).asyncExpand((_) => streamFactory());
  }

  static const Map<String, String> _nutritionIcons = {
    'Proteins': 'assets/img/proteins.png',
    'Fats': 'assets/img/egg.png',
    'Carbo': 'assets/img/carbo.png',
  };

  Future<List<MealSummary>> _fetchMealSummaries(
    Future<List<Map<String, Object?>>> Function() query,
  ) {
    return _runAfterReady(() async {
      final rows = await query();
      return List.unmodifiable(rows.map(_mapMealSummary));
    });
  }
}
