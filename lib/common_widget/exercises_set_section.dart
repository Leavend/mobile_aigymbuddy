import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';
import 'exercises_row.dart';

@immutable
class ExerciseSet {
  const ExerciseSet({
    required this.name,
    required this.exercises,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      name: json['name']?.toString() ?? 'Workout Set',
      exercises: _parseExercises(json['set']),
    );
  }

  final String name;
  final List<ExerciseListItem> exercises;
}

List<ExerciseListItem> _parseExercises(Object? raw) {
  if (raw is! List) {
    return const <ExerciseListItem>[];
  }

  return raw
      .whereType<Map<Object?, Object?>>()
      .map((item) =>
          ExerciseListItem.fromJson(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

class ExercisesSetSection extends StatelessWidget {
  const ExercisesSetSection({
    super.key,
    required this.set,
    required this.onPressed,
  });

  final ExerciseSet set;
  final ValueChanged<ExerciseListItem> onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          set.name,
          style: TextStyle(
            color: TColor.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: set.exercises.length,
          itemBuilder: (context, index) {
            final exercise = set.exercises[index];
            return ExercisesRow(
              exercise: exercise,
              onPressed: () => onPressed(exercise),
            );
          },
        ),
      ],
    );
  }
}
