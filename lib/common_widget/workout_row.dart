// lib/common_widget/workout_row.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

@immutable
class WorkoutSummaryItem {
  const WorkoutSummaryItem({
    required this.imageAsset,
    required this.name,
    required this.calories,
    required this.durationMinutes,
    required this.progress,
    this.subtitle,
  });

  factory WorkoutSummaryItem.fromJson(Map<String, dynamic> json) {
    final progressValue = double.tryParse(json['progress']?.toString() ?? '') ??
        (json['progress'] is num ? (json['progress'] as num).toDouble() : 0);
    return WorkoutSummaryItem(
      imageAsset: json['image']?.toString() ?? 'assets/img/workout.png',
      name: json['name']?.toString() ?? 'Workout',
      calories: json['kcal']?.toString() ?? '0',
      durationMinutes: json['time']?.toString() ?? '0',
      progress: progressValue.clamp(0, 1).toDouble(),
      subtitle: json['subtitle']?.toString(),
    );
  }

  final String imageAsset;
  final String name;
  final String calories;
  final String durationMinutes;
  final double progress;
  final String? subtitle;
}

class WorkoutRow extends StatelessWidget {
  const WorkoutRow({super.key, required this.workout, this.onTap});

  factory WorkoutRow.fromMap(Map<String, dynamic> map, {VoidCallback? onTap}) {
    return WorkoutRow(workout: WorkoutSummaryItem.fromJson(map), onTap: onTap);
  }

  final WorkoutSummaryItem workout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final content = Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              workout.imageAsset,
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
                  workout.name,
                  style: TextStyle(color: TColor.black, fontSize: 12),
                ),
                Text(
                  workout.subtitle ??
                      '${workout.calories} Calories Burned | ${workout.durationMinutes} minutes',
                  style: TextStyle(color: TColor.gray, fontSize: 10),
                ),
                const SizedBox(height: 4),
                SimpleAnimationProgressBar(
                  height: 15,
                  width: media.width * 0.5,
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.purple,
                  ratio: workout.progress,
                  direction: Axis.horizontal,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(seconds: 3),
                  borderRadius: BorderRadius.circular(7.5),
                  gradientColor: LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/img/next_icon.png', width: 30, height: 30),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: content,
    );
  }
}
