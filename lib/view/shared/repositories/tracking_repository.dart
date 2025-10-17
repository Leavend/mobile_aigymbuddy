import '../models/tracking.dart';

abstract class TrackingRepository {
  Future<void> addBodyWeight(double weightKg);
  Stream<List<BodyWeightEntry>> watchBodyWeight({int days = 30});
  Future<void> logManualSet({
    required int exerciseId,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  });
  Stream<List<WorkoutSetLog>> watchRecentSetLogs({int limit = 20});
  Future<List<WeeklyVolumePoint>> loadWeeklyVolume({int weeks = 8});
}
