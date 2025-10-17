import 'package:flutter/foundation.dart';

import '../../app/dependencies.dart';
import '../shared/models/exercise.dart';
import '../shared/repositories/exercise_repository.dart';
import '../shared/repositories/profile_repository.dart';
import '../shared/repositories/tracking_repository.dart';
import 'home_action_result.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required ProfileRepository profileRepository,
    required TrackingRepository trackingRepository,
    required ExerciseRepository exerciseRepository,
  })  : _profileRepository = profileRepository,
        _trackingRepository = trackingRepository,
        _exerciseRepository = exerciseRepository,
        _state = HomeState.initial();

  factory HomeController.fromContext(AppDependencies dependencies) {
    return HomeController(
      profileRepository: dependencies.profileRepository,
      trackingRepository: dependencies.trackingRepository,
      exerciseRepository: dependencies.exerciseRepository,
    );
  }

  final ProfileRepository _profileRepository;
  final TrackingRepository _trackingRepository;
  final ExerciseRepository _exerciseRepository;

  HomeState _state;
  bool _isInitialized = false;

  HomeState get state => _state;
  ProfileRepository get profileRepository => _profileRepository;
  TrackingRepository get trackingRepository => _trackingRepository;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    _updateWeeklyVolume();
    await _loadExercises();
  }

  Future<void> refreshData() async {
    await Future.wait([
      _loadExercises(),
      _updateWeeklyVolume(),
    ]);
  }

  Future<void> _loadExercises() async {
    final exercises = await _exerciseRepository.listExercises();
    final selected = _state.selectedExercise;
    ExerciseSummary? resolvedSelection;
    if (selected != null && exercises.any((e) => e.id == selected.id)) {
      resolvedSelection = exercises.firstWhere((e) => e.id == selected.id);
    } else if (exercises.isNotEmpty) {
      resolvedSelection = exercises.first;
    }

    _updateState(
      _state.copyWith(
        exercises: exercises,
        selectedExercise: resolvedSelection,
        setSelectedExercise: true,
      ),
    );
  }

  void selectExercise(ExerciseSummary? exercise) {
    if (exercise == null) return;
    _updateState(
      _state.copyWith(
        selectedExercise: exercise,
        setSelectedExercise: true,
      ),
    );
  }

  Future<HomeActionResult> addBodyWeight(String rawValue) async {
    final value = double.tryParse(rawValue.trim());
    if (value == null || value <= 0) {
      return HomeActionResult.validationError(
        'Masukkan berat badan yang valid.',
      );
    }

    _updateState(_state.copyWith(isAddingWeight: true));
    try {
      await _trackingRepository.addBodyWeight(value);
      return HomeActionResult.success(
        'Berat badan tersimpan.',
        shouldResetForm: true,
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to add body weight: $error\n$stackTrace');
      return HomeActionResult.failure('Gagal menyimpan berat badan: $error');
    } finally {
      _updateState(_state.copyWith(isAddingWeight: false));
    }
  }

  Future<HomeActionResult> logManualSet({
    required String setIndex,
    required String reps,
    required String weight,
    required String note,
  }) async {
    final exercise = _state.selectedExercise;
    if (exercise == null) {
      return HomeActionResult.failure('Data latihan belum siap.');
    }

    final setIndexValue = int.tryParse(setIndex.trim());
    if (setIndexValue == null || setIndexValue <= 0) {
      return HomeActionResult.validationError(
        'Index set harus lebih dari 0.',
      );
    }

    final repsTrimmed = reps.trim();
    final weightTrimmed = weight.trim();
    final repsValue = repsTrimmed.isEmpty ? null : int.tryParse(repsTrimmed);
    final weightValue =
        weightTrimmed.isEmpty ? null : double.tryParse(weightTrimmed);

    if (repsTrimmed.isNotEmpty && repsValue == null) {
      return HomeActionResult.validationError('Reps harus berupa angka.');
    }
    if (weightTrimmed.isNotEmpty && weightValue == null) {
      return HomeActionResult.validationError('Beban harus berupa angka.');
    }

    _updateState(_state.copyWith(isLoggingSet: true));
    try {
      await _trackingRepository.logManualSet(
        exerciseId: exercise.id,
        setIndex: setIndexValue,
        reps: repsValue,
        weight: weightValue,
        note: note.trim().isEmpty ? null : note.trim(),
      );
      await _updateWeeklyVolume();
      return HomeActionResult.success(
        'Catatan latihan tersimpan.',
        shouldResetForm: true,
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to log set: $error\n$stackTrace');
      return HomeActionResult.failure('Gagal menyimpan latihan: $error');
    } finally {
      _updateState(_state.copyWith(isLoggingSet: false));
    }
  }

  Future<void> _updateWeeklyVolume() async {
    final future = _trackingRepository.loadWeeklyVolume();
    _updateState(_state.copyWith(weeklyVolumeFuture: future));
  }

  void _updateState(HomeState newState) {
    if (identical(_state, newState)) return;
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _isInitialized = false;
    super.dispose();
  }
}
