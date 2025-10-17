import 'package:flutter/foundation.dart';

import '../../shared/models/meal/meal_category.dart';
import '../../shared/models/meal/meal_summary.dart';
import '../../shared/repositories/meal_planner_repository.dart';

class MealFoodDetailsController extends ChangeNotifier {
  MealFoodDetailsController(this._repository);

  final MealPlannerRepository _repository;

  MealFoodOverview? _overview;
  List<MealSummary> _categoryMeals = const [];
  List<MealSummary> _searchResults = const [];
  Object? _error;
  bool _isLoading = true;
  bool _isLoadingCategoryMeals = false;
  bool _isSearching = false;
  int? _selectedCategoryId;
  bool _initialised = false;

  MealFoodOverview? get overview => _overview;
  List<MealSummary> get categoryMeals => _categoryMeals;
  List<MealSummary> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isLoadingCategoryMeals => _isLoadingCategoryMeals;
  bool get isSearching => _isSearching;
  bool get hasError => _error != null;
  Object? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;

  Future<void> initialise({int? initialCategoryId}) async {
    if (_initialised) return;
    _initialised = true;
    await _loadOverview(initialCategoryId: initialCategoryId);
  }

  Future<void> refresh() async {
    await _loadOverview(initialCategoryId: _selectedCategoryId);
  }

  Future<void> selectCategory(int categoryId) async {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    await _loadMealsForCategory(categoryId);
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _isSearching = false;
      _searchResults = const [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      await _repository.ensureSeeded();
      final results = await _repository.searchMeals(trimmed);
      _searchResults = results;
      _error = null;
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'meal_planner',
        informationCollector: () => [
          DiagnosticsProperty<String>('Query', trimmed),
        ],
      ));
      _error = error;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> _loadOverview({int? initialCategoryId}) async {
    _setLoading(true);
    try {
      await _repository.ensureSeeded();
      final categories = await _repository.fetchCategories();
      final recommendations = await _repository.fetchRecommendations();
      final popular = await _repository.fetchPopularMeals();
      final resolvedCategoryId = _resolveCategoryId(
        categories,
        initialCategoryId,
      );
      _overview = MealFoodOverview(
        categories: categories,
        recommendations: recommendations,
        popularMeals: popular,
      );
      _selectedCategoryId = resolvedCategoryId;
      _error = null;
      await _loadMealsForCategory(resolvedCategoryId);
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'meal_planner',
      ));
      _error = error;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> _loadMealsForCategory(int categoryId) async {
    _isLoadingCategoryMeals = true;
    notifyListeners();
    try {
      await _repository.ensureSeeded();
      final meals = await _repository.fetchMealsByCategory(categoryId);
      _categoryMeals = meals;
      _error = null;
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'meal_planner',
        informationCollector: () => [
          DiagnosticsProperty<int>('Category ID', categoryId),
        ],
      ));
      _error = error;
    } finally {
      _isLoadingCategoryMeals = false;
      notifyListeners();
    }
  }

  int _resolveCategoryId(
    List<MealCategorySummary> categories,
    int? preferred,
  ) {
    if (categories.isEmpty) {
      return 0;
    }
    return categories
        .firstWhere(
          (category) => category.id == preferred,
          orElse: () => categories.first,
        )
        .id;
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }
}

class MealFoodOverview {
  const MealFoodOverview({
    required this.categories,
    required this.recommendations,
    required this.popularMeals,
  });

  final List<MealCategorySummary> categories;
  final List<MealSummary> recommendations;
  final List<MealSummary> popularMeals;
}
