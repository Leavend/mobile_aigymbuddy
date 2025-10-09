import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class ExerciseListItem {
  const ExerciseListItem({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  factory ExerciseListItem.fromJson(Map<String, dynamic> json) {
    return ExerciseListItem(
      imageAsset: json['image']?.toString() ?? 'assets/img/placeholder.png',
      title: json['title']?.toString() ?? 'Exercise',
      subtitle: json['value']?.toString() ?? '',
    );
  }

  final String imageAsset;
  final String title;
  final String subtitle;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'image': imageAsset,
        'title': title,
        'value': subtitle,
      };
}

class ExercisesRow extends StatelessWidget {
  const ExercisesRow({
    super.key,
    required this.exercise,
    required this.onPressed,
  });

  final ExerciseListItem exercise;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              exercise.imageAsset,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.title,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  exercise.subtitle,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Image.asset(
              'assets/img/next_go.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
