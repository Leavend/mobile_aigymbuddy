class WeeklyVolumePoint {
  const WeeklyVolumePoint({
    required this.weekKey,
    required this.totalVolume,
  });

  final String weekKey;
  final double totalVolume;
}

class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.title,
    required this.startedAt,
    this.endedAt,
    this.note,
    required this.totalVolume,
    required this.totalSets,
  });

  final int id;
  final String title;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? note;
  final double totalVolume;
  final int totalSets;
}

class LoggedSet {
  const LoggedSet({
    required this.id,
    required this.sessionId,
    required this.exerciseName,
    required this.setIndex,
    this.reps,
    this.weight,
    this.note,
  });

  final int id;
  final int sessionId;
  final String exerciseName;
  final int setIndex;
  final int? reps;
  final double? weight;
  final String? note;
}
