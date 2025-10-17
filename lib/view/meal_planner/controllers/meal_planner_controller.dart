import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../shared/models/meal/meal_category.dart';
import '../../shared/models/meal/meal_nutrition_progress.dart';
import '../../shared/models/meal/meal_period.dart';
import '../../shared/models/meal/meal_period_summary.dart';
import '../../shared/models/meal/meal_schedule_entry.dart';
import '../../shared/repositories/meal_planner_repository.dart';

class MealPlannerController extends ChangeNotifier {
  MealPlannerController(this._repository)
      : _today = _normalizeDay(DateTime.now());

  final MealPlannerRepository _repository;
  final DateTime _today;

  MealPlannerViewData? _data;
  Object? _error;
  bool _isLoading = true;
  MealNutritionRange _selectedRange = MealNutritionRange.weekly;
  MealPeriod _selectedMealPeriod = MealPeriod.breakfast;
  List<MealScheduleEntry> _schedule = const [];
  StreamSubscription<List<MealScheduleEntry>>? _scheduleSubscription;
  bool _initialised = false;

  MealPlannerViewData? get data => _data;
  Object? get error => _error;
  bool get isLoading => _isLoading;
  bool get hasError => _error != null;
  MealNutritionRange get selectedRange => _selectedRange;
  MealPeriod get selectedMealPeriod => _selectedMealPeriod;
  List<MealScheduleEntry> get schedule => _schedule;

  List<MealScheduleEntry> get filteredSchedule => _schedule
      .where((entry) => entry.meal.period == _selectedMealPeriod)
      .toList(growable: false);

  Future<void> initialise() async {
    if (_initialised) return;
    _initialised = true;
    await _loadData();
    await _startScheduleStream();
  }

  Future<void> refresh() async {
    await _loadData();
  }

  void selectRange(MealNutritionRange range) {
    if (range == _selectedRange) return;
    _selectedRange = range;
    notifyListeners();
  }

  void selectMealPeriod(MealPeriod period) {
    if (period == _selectedMealPeriod) return;
    _selectedMealPeriod = period;
    notifyListeners();
  }

  Future<void> _loadData() async {
    _setLoading(true);
    try {
      await _repository.ensureSeeded();
      final weekly = await _repository.fetchWeeklyNutritionProgress();
      final periods = await _repository.fetchPeriodSummaries();
      final categories = await _repository.fetchCategories();
      _data = MealPlannerViewData(
        weeklyProgress: weekly,
        periodSummaries: periods,
        categories: categories,
      );
      _error = null;
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'meal_planner',
        informationCollector: () => [
          DiagnosticsProperty<MealPlannerRepository>(
            'MealPlannerRepository',
            _repository,
          ),
        ],
      ));
      _error = error;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> _startScheduleStream() async {
    await _scheduleSubscription?.cancel();
    _scheduleSubscription = _repository
        .watchMealsForDay(_today)
        .listen(_onScheduleUpdate, onError: _onScheduleError);
  }

  void _onScheduleUpdate(List<MealScheduleEntry> entries) {
    _schedule = entries;
    notifyListeners();
  }

  void _onScheduleError(Object error, StackTrace stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'meal_planner',
      informationCollector: () => [
        DiagnosticsProperty<DateTime>('Schedule date', _today),
      ],
    ));
    _error = error;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  static DateTime _normalizeDay(DateTime input) {
    return DateTime(input.year, input.month, input.day);
  }

  @override
  void dispose() {
    _scheduleSubscription?.cancel();
    super.dispose();
  }
}

class MealPlannerViewData {
  const MealPlannerViewData({
    required this.weeklyProgress,
    required this.periodSummaries,
    required this.categories,
  });

  final List<MealNutritionProgressPoint> weeklyProgress;
  final List<MealPeriodSummary> periodSummaries;
  final List<MealCategorySummary> categories;
}

enum MealNutritionRange { weekly, monthly }

extension MealNutritionRangeX on MealNutritionRange {
  String get id => switch (this) {
        MealNutritionRange.weekly => 'weekly',
        MealNutritionRange.monthly => 'monthly',
      };
}
