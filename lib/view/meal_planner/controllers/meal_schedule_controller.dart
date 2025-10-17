import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../shared/models/meal/meal_schedule_entry.dart';
import '../../shared/repositories/meal_planner_repository.dart';
import '../../../common/models/nutrition_info.dart';

class MealScheduleController extends ChangeNotifier {
  MealScheduleController(this._repository)
      : _selectedDate = _normalizeDay(DateTime.now());

  final MealPlannerRepository _repository;

  DateTime _selectedDate;
  List<MealScheduleEntry> _schedule = const [];
  List<NutritionInfo> _nutrition = const [];
  bool _isLoadingSchedule = true;
  bool _isLoadingNutrition = true;
  Object? _error;
  bool _initialised = false;
  StreamSubscription<List<MealScheduleEntry>>? _scheduleSubscription;

  DateTime get selectedDate => _selectedDate;
  List<MealScheduleEntry> get schedule => _schedule;
  List<NutritionInfo> get nutrition => _nutrition;
  bool get isLoadingSchedule => _isLoadingSchedule;
  bool get isLoadingNutrition => _isLoadingNutrition;
  bool get hasError => _error != null;
  Object? get error => _error;

  Future<void> initialise() async {
    if (_initialised) return;
    _initialised = true;
    await _loadForDate(_selectedDate);
  }

  Future<void> changeDate(DateTime date) async {
    await _loadForDate(date);
  }

  Future<void> refresh() async {
    await _loadForDate(_selectedDate);
  }

  Future<void> _loadForDate(DateTime date) async {
    final normalized = _normalizeDay(date);
    if (normalized != _selectedDate) {
      _selectedDate = normalized;
      notifyListeners();
    }
    await _repository.ensureSeeded();
    await Future.wait([
      _loadSchedule(normalized),
      _loadNutrition(normalized),
    ]);
  }

  Future<void> _loadSchedule(DateTime day) async {
    _isLoadingSchedule = true;
    notifyListeners();

    await _scheduleSubscription?.cancel();
    _scheduleSubscription = _repository
        .watchMealsForDay(day)
        .listen(_onScheduleUpdate, onError: _onScheduleError);

    try {
      final entries = await _repository.fetchMealsForDay(day);
      _schedule = entries;
      _error = null;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace, {'day': day});
    } finally {
      _isLoadingSchedule = false;
      notifyListeners();
    }
  }

  Future<void> _loadNutrition(DateTime day) async {
    _isLoadingNutrition = true;
    notifyListeners();
    try {
      final infos = await _repository.fetchDailyNutritionSummary(day);
      _nutrition = infos;
      _error = null;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace, {'day': day});
    } finally {
      _isLoadingNutrition = false;
      notifyListeners();
    }
  }

  void _onScheduleUpdate(List<MealScheduleEntry> entries) {
    _schedule = entries;
    notifyListeners();
  }

  void _onScheduleError(Object error, StackTrace stackTrace) {
    _handleError(error, stackTrace, {'day': _selectedDate});
  }

  void _handleError(Object error, StackTrace stackTrace, Map<String, Object> context) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'meal_planner',
      informationCollector: () => context.entries
          .map((entry) => DiagnosticsProperty<Object>(entry.key, entry.value))
          .toList(),
    ));
    _error = error;
    notifyListeners();
  }

  static DateTime _normalizeDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void dispose() {
    _scheduleSubscription?.cancel();
    super.dispose();
  }
}
