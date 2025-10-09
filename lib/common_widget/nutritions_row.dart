import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../common/color_extension.dart';

@immutable
class NutritionProgress {
  const NutritionProgress({
    required this.title,
    required this.unitName,
    required this.imageAsset,
    required this.value,
    required this.maxValue,
  });

  factory NutritionProgress.fromJson(Map<String, dynamic> json) {
    final value = double.tryParse(json['value']?.toString() ?? '') ?? 0;
    final maxValue = double.tryParse(json['max_value']?.toString() ?? '') ?? 0;
    return NutritionProgress(
      title: json['title']?.toString() ?? 'Nutrition',
      unitName: json['unit_name']?.toString() ?? '',
      imageAsset: json['image']?.toString() ?? 'assets/img/n_1.png',
      value: value,
      maxValue: maxValue <= 0 ? 1 : maxValue,
    );
  }

  final String title;
  final String unitName;
  final String imageAsset;
  final double value;
  final double maxValue;

  double get ratio =>
      maxValue == 0 ? 0 : (value / maxValue).clamp(0.0, 1.0).toDouble();

  String get formattedValue => '${value.toStringAsFixed(0)} $unitName';
}

class NutritionRow extends StatelessWidget {
  const NutritionRow({
    super.key,
    required this.progress,
  });

  factory NutritionRow.fromMap(Map<String, dynamic> map) {
    return NutritionRow(progress: NutritionProgress.fromJson(map));
  }

  final NutritionProgress progress;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                progress.title,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Image.asset(progress.imageAsset, width: 15, height: 15),
              const Spacer(),
              Text(
                progress.formattedValue,
                style: TextStyle(color: TColor.gray, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SimpleAnimationProgressBar(
            height: 10,
            width: media.width - 30,
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.purple,
            ratio: progress.ratio,
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
    );
  }
}
