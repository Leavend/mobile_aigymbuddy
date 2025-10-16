import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/progress_models.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/add_set_to_session.dart';
import '../../../domain/usecases/finish_session.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/start_session.dart';
import '../../../domain/usecases/watch_session_sets.dart';

class LogSessionViewModel extends ChangeNotifier {
  LogSessionViewModel({
    required StartSession startSession,
    required AddSetToSession addSetToSession,
    required FinishSession finishSession,
    required WatchSessionSets watchSessionSets,
    required GetUserProfile getUserProfile,
  })  : _startSession = startSession,
        _addSetToSession = addSetToSession,
        _finishSession = finishSession,
        _watchSessionSets = watchSessionSets,
        _getUserProfile = getUserProfile {
    _loadDefaults();
  }

  final StartSession _startSession;
  final AddSetToSession _addSetToSession;
  final FinishSession _finishSession;
  final WatchSessionSets _watchSessionSets;
  final GetUserProfile _getUserProfile;

  int? _sessionId;
  List<LoggedSet> _sets = const [];
  bool _isLoading = false;
  bool _sessionActive = false;
  String? _error;
  StreamSubscription<List<LoggedSet>>? _subscription;

  String title = 'Sesi Latihan';
  FitnessGoal selectedGoal = FitnessGoal.buildMuscle;
  ExperienceLevel selectedLevel = ExperienceLevel.beginner;
  WorkoutMode selectedMode = WorkoutMode.home;
  String? note;

  int? get sessionId => _sessionId;
  List<LoggedSet> get sets => _sets;
  bool get isLoading => _isLoading;
  bool get isSessionActive => _sessionActive;
  String? get error => _error;

  Future<void> _loadDefaults() async {
    final profile = await _getUserProfile();
    if (profile != null) {
      selectedGoal = profile.goal;
      selectedLevel = profile.level;
      selectedMode = profile.preferredMode;
      title = 'Latihan ${profile.goal.label}';
      note = 'Catatan ${profile.name ?? 'Gym Buddy'}';
    }
    notifyListeners();
  }

  void setGoal(FitnessGoal value) {
    selectedGoal = value;
    notifyListeners();
  }

  void setLevel(ExperienceLevel value) {
    selectedLevel = value;
    notifyListeners();
  }

  void setMode(WorkoutMode value) {
    selectedMode = value;
    notifyListeners();
  }

  Future<bool> startNewSession() async {
    if (_sessionActive) {
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final id = await _startSession(
        title: title.isEmpty ? 'Sesi Latihan' : title,
        note: note,
        goal: _goalToDb(selectedGoal),
        level: _levelToDb(selectedLevel),
        mode: _modeToDb(selectedMode),
      );
      _sessionId = id;
      _sessionActive = true;
      _sets = const [];
      _subscribeToSets(id);
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to start session: $error\n$stackTrace');
      _error = 'Tidak dapat memulai sesi.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _subscribeToSets(int sessionId) {
    _subscription?.cancel();
    _subscription = _watchSessionSets(sessionId).listen((event) {
      _sets = event;
      notifyListeners();
    });
  }

  Future<void> _clearSessionState() async {
    await _subscription?.cancel();
    _subscription = null;
    _sessionId = null;
    _sets = const [];
    _sessionActive = false;
  }

  Future<bool> addSet({
    required String exerciseName,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  }) async {
    if (_sessionId == null) {
      _error = 'Mulai sesi terlebih dahulu.';
      notifyListeners();
      return false;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _addSetToSession(
        sessionId: _sessionId!,
        exerciseName: exerciseName,
        setIndex: setIndex,
        reps: reps,
        weight: weight,
        note: note,
      );
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to add set: $error\n$stackTrace');
      _error = 'Tidak dapat menyimpan set latihan.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> finishCurrentSession({String? finalNote}) async {
    if (_sessionId == null) {
      return false;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _finishSession(sessionId: _sessionId!, note: finalNote ?? note);
      await _clearSessionState();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to finish session: $error\n$stackTrace');
      _error = 'Tidak dapat mengakhiri sesi.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  String _goalToDb(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.loseWeight:
        return 'lose_weight';
      case FitnessGoal.buildMuscle:
        return 'build_muscle';
      case FitnessGoal.endurance:
        return 'endurance';
    }
  }

  String _levelToDb(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.beginner:
        return 'beginner';
      case ExperienceLevel.intermediate:
        return 'intermediate';
      case ExperienceLevel.advanced:
        return 'advanced';
    }
  }

  String _modeToDb(WorkoutMode mode) {
    switch (mode) {
      case WorkoutMode.home:
        return 'home';
      case WorkoutMode.gym:
        return 'gym';
    }
  }
}
