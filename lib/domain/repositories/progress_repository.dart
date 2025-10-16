import '../entities/progress_models.dart';
import '../entities/weight_entry.dart';

abstract class ProgressRepository {
  Future<WeightEntry> addBodyWeight({required double weightKg, DateTime? recordedAt});
  Future<List<WeightEntry>> loadBodyWeightHistory({int days = 30});
  Stream<List<WeightEntry>> watchBodyWeightHistory({int days = 30});
  Future<List<WeeklyVolumePoint>> loadWeeklyVolume({int weeks = 6});
  Stream<List<SessionSummary>> watchRecentSessions({int limit = 10});
  Stream<List<LoggedSet>> watchSessionSets(int sessionId);
  Future<int> startSession({
    required String title,
    String? note,
    required String goal,
    required String level,
    required String mode,
  });
  Future<void> finishSession({required int sessionId, String? note});
  Future<void> addSet({
    required int sessionId,
    required String exerciseName,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  });
}
