class BodyWeightEntry {
  const BodyWeightEntry({required this.timestamp, required this.weightKg});

  final DateTime timestamp;
  final double weightKg;
}

class WorkoutSetLog {
  const WorkoutSetLog({
    required this.id,
    required this.exerciseName,
    required this.setIndex,
    required this.performedAt,
    this.reps,
    this.weight,
    this.note,
  });

  final int id;
  final String exerciseName;
  final int setIndex;
  final DateTime performedAt;
  final int? reps;
  final double? weight;
  final String? note;
}

class WeeklyVolumePoint {
  const WeeklyVolumePoint({required this.weekKey, required this.totalVolume});

  final String weekKey;
  final double totalVolume;
}
