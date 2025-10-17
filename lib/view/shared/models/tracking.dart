import 'package:flutter/foundation.dart';

@immutable
class BodyWeightEntry {
  const BodyWeightEntry({required this.timestamp, required this.weightKg})
      : assert(weightKg > 0, 'Weight must be greater than zero');

  final DateTime timestamp;
  final double weightKg;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BodyWeightEntry &&
            runtimeType == other.runtimeType &&
            timestamp == other.timestamp &&
            weightKg == other.weightKg;
  }

  @override
  int get hashCode => Object.hash(timestamp, weightKg);

  @override
  String toString() =>
      'BodyWeightEntry(timestamp: $timestamp, weightKg: $weightKg)';
}

@immutable
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkoutSetLog &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            exerciseName == other.exerciseName &&
            setIndex == other.setIndex &&
            performedAt == other.performedAt &&
            reps == other.reps &&
            weight == other.weight &&
            note == other.note;
  }

  @override
  int get hashCode => Object.hash(
        id,
        exerciseName,
        setIndex,
        performedAt,
        reps,
        weight,
        note,
      );

  @override
  String toString() =>
      'WorkoutSetLog(id: $id, exercise: $exerciseName, setIndex: $setIndex)';
}

@immutable
class WeeklyVolumePoint {
  const WeeklyVolumePoint({required this.weekKey, required this.totalVolume});

  final String weekKey;
  final double totalVolume;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WeeklyVolumePoint &&
            runtimeType == other.runtimeType &&
            weekKey == other.weekKey &&
            totalVolume == other.totalVolume;
  }

  @override
  int get hashCode => Object.hash(weekKey, totalVolume);

  @override
  String toString() =>
      'WeeklyVolumePoint(weekKey: $weekKey, totalVolume: $totalVolume)';
}
