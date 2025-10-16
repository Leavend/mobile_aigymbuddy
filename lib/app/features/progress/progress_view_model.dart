import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/progress_models.dart';
import '../../../domain/entities/weight_entry.dart';
import '../../../domain/usecases/add_body_weight_entry.dart';
import '../../../domain/usecases/get_weekly_volume.dart';
import '../../../domain/usecases/watch_body_weight_history.dart';
import '../../../domain/usecases/watch_recent_sessions.dart';

class ProgressViewModel extends ChangeNotifier {
  ProgressViewModel({
    required WatchBodyWeightHistory watchBodyWeightHistory,
    required WatchRecentSessions watchRecentSessions,
    required AddBodyWeightEntry addBodyWeightEntry,
    required GetWeeklyVolume getWeeklyVolume,
  })  : _watchBodyWeightHistory = watchBodyWeightHistory,
        _watchRecentSessions = watchRecentSessions,
        _addBodyWeightEntry = addBodyWeightEntry,
        _getWeeklyVolume = getWeeklyVolume {
    _weightSubscription = _watchBodyWeightHistory().listen(
      (entries) {
        _weightHistory = entries;
        _error = null;
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Failed to watch weight history: $error\n$stackTrace');
        _error = 'Tidak dapat memuat riwayat berat badan.';
        notifyListeners();
      },
    );
    _sessionSubscription = _watchRecentSessions().listen(
      (sessions) {
        _sessions = sessions;
        _error = null;
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Failed to watch sessions: $error\n$stackTrace');
        _error = 'Tidak dapat memuat riwayat sesi.';
        notifyListeners();
      },
    );
    _loadWeeklyVolume();
  }

  final WatchBodyWeightHistory _watchBodyWeightHistory;
  final WatchRecentSessions _watchRecentSessions;
  final AddBodyWeightEntry _addBodyWeightEntry;
  final GetWeeklyVolume _getWeeklyVolume;

  StreamSubscription<List<WeightEntry>>? _weightSubscription;
  StreamSubscription<List<SessionSummary>>? _sessionSubscription;

  List<WeightEntry> _weightHistory = const [];
  List<SessionSummary> _sessions = const [];
  List<WeeklyVolumePoint> _weeklyVolume = const [];

  bool _isAddingWeight = false;
  String? _error;

  List<WeightEntry> get weightHistory => _weightHistory;
  List<SessionSummary> get sessions => _sessions;
  List<WeeklyVolumePoint> get weeklyVolume => _weeklyVolume;
  bool get isAddingWeight => _isAddingWeight;
  String? get error => _error;

  Future<void> _loadWeeklyVolume() async {
    try {
      final data = await _getWeeklyVolume();
      _weeklyVolume = data;
      _error = null;
    } catch (error, stackTrace) {
      debugPrint('Failed to load weekly volume: $error\n$stackTrace');
      _error = 'Tidak dapat memuat ringkasan volume latihan.';
    }
    notifyListeners();
  }

  Future<bool> addBodyWeight(double weightKg) async {
    _isAddingWeight = true;
    _error = null;
    notifyListeners();
    try {
      await _addBodyWeightEntry(weightKg: weightKg);
      await _loadWeeklyVolume();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to add weight entry: $error\n$stackTrace');
      _error = 'Tidak dapat menyimpan berat badan.';
      return false;
    } finally {
      _isAddingWeight = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _weightSubscription?.cancel();
    _sessionSubscription?.cancel();
    super.dispose();
  }
}
