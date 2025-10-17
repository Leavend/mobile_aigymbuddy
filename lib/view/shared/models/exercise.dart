import 'package:meta/meta.dart';

/// Lightweight projection of an exercise used across multiple features.
@immutable
class ExerciseSummary {
  const ExerciseSummary({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.mode,
  });

  final int id;
  final String name;
  final String difficulty;
  final String mode;

  ExerciseSummary copyWith({
    int? id,
    String? name,
    String? difficulty,
    String? mode,
  }) {
    return ExerciseSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      mode: mode ?? this.mode,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ExerciseSummary &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            difficulty == other.difficulty &&
            mode == other.mode;
  }

  @override
  int get hashCode => Object.hash(id, name, difficulty, mode);

  @override
  String toString() {
    return 'ExerciseSummary(id: $id, name: $name, difficulty: $difficulty, mode: $mode)';
  }
}
