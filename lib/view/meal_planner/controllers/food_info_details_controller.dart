import 'package:flutter/foundation.dart';

import '../../shared/models/meal/meal_detail.dart';
import '../../shared/repositories/meal_planner_repository.dart';

class FoodInfoDetailsController extends ChangeNotifier {
  FoodInfoDetailsController(this._repository, this._mealId);

  final MealPlannerRepository _repository;
  final int _mealId;

  MealDetail? _detail;
  bool _isLoading = true;
  Object? _error;
  bool _initialised = false;

  MealDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  bool get hasError => _error != null;
  Object? get error => _error;

  Future<void> initialise() async {
    if (_initialised) return;
    _initialised = true;
    await _load();
  }

  Future<void> reload() async {
    await _load();
  }

  Future<void> _load() async {
    _setLoading(true);
    try {
      await _repository.ensureSeeded();
      _detail = await _repository.fetchMealDetail(_mealId);
      _error = null;
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'meal_planner',
        informationCollector: () => [
          DiagnosticsProperty<int>('Meal ID', _mealId),
        ],
      ));
      _error = error;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }
}
