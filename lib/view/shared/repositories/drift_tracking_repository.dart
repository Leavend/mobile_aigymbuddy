import '../../../data/db/daos/exercise_dao.dart';
import '../../../data/db/daos/tracking_dao.dart';
import '../models/tracking.dart';
import '../models/user_profile.dart';
import 'profile_repository.dart';
import 'tracking_repository.dart';

class DriftTrackingRepository implements TrackingRepository {
  DriftTrackingRepository(
      this._dao, this._profileRepository, this._exerciseDao);

  final TrackingDao _dao;
  final ProfileRepository _profileRepository;
  final ExerciseDao _exerciseDao;

  @override
  Future<void> addBodyWeight(double weightKg) {
    if (weightKg <= 0) {
      throw ArgumentError.value(weightKg, 'weightKg', 'Must be greater than 0');
    }
    return _dao.insertBodyWeight(weightKg);
  }

  @override
  Stream<List<BodyWeightEntry>> watchBodyWeight({int days = 30}) {
    return _dao.watchWeightSeries(days: days).map(
          (points) => List.unmodifiable(points.map(_mapWeight)),
        );
  }

  @override
  Future<void> logManualSet({
    required int exerciseId,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  }) async {
    if (setIndex <= 0) {
      throw ArgumentError.value(setIndex, 'setIndex', 'Must be greater than 0');
    }
    if (reps != null && reps <= 0) {
      throw ArgumentError.value(reps, 'reps', 'Must be greater than 0');
    }
    if (weight != null && weight <= 0) {
      throw ArgumentError.value(weight, 'weight', 'Must be greater than 0');
    }

    final exercise = await _exerciseDao.getById(exerciseId);
    if (exercise == null) {
      throw ArgumentError.value(exerciseId, 'exerciseId', 'Exercise not found');
    }

    final profile = await _profileRepository.loadProfile();
    if (profile == null) {
      throw StateError('Cannot log a workout without a profile');
    }

    await _dao.insertManualSet(
      exerciseId: exerciseId,
      setIndex: setIndex,
      goal: profile.goal.dbValue,
      level: profile.level.dbValue,
      mode: profile.mode.dbValue,
      reps: reps,
      weight: weight,
      note: note,
    );
  }

  @override
  Stream<List<WorkoutSetLog>> watchRecentSetLogs({int limit = 20}) {
    return _dao.watchRecentSetLogs(limit: limit).map(
          (rows) => List.unmodifiable(rows.map(_mapSetLog)),
        );
  }

  @override
  Future<List<WeeklyVolumePoint>> loadWeeklyVolume({int weeks = 8}) async {
    final rows = await _dao.getWeeklyVolume(weeks);
    return List.unmodifiable(rows.map(_mapWeeklyVolume));
  }

  BodyWeightEntry _mapWeight(WeightPoint point) {
    return BodyWeightEntry(
      timestamp: point.recordedAt,
      weightKg: point.weightKg,
    );
  }

  WorkoutSetLog _mapSetLog(RecentSetLogRow row) {
    return WorkoutSetLog(
      id: row.id,
      exerciseName: row.exerciseName,
      setIndex: row.setIndex,
      performedAt: row.startedAt,
      reps: row.reps,
      weight: row.weight,
      note: row.note,
    );
  }

  WeeklyVolumePoint _mapWeeklyVolume(WeeklyVolume row) {
    return WeeklyVolumePoint(
      weekKey: row.weekKey,
      totalVolume: row.totalVolume,
    );
  }
}
