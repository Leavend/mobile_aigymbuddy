// lib/common_widget/what_train_row.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';

@immutable
class TrainingOptionItem {
  const TrainingOptionItem({
    required this.title,
    required this.exercises,
    required this.duration,
    required this.imageAsset,
  });

  factory TrainingOptionItem.fromJson(Map<String, dynamic> json) {
    return TrainingOptionItem(
      title: json['title']?.toString() ?? 'Training',
      exercises: json['exercises']?.toString() ?? '',
      duration: json['time']?.toString() ?? '',
      imageAsset: json['image']?.toString() ?? 'assets/img/img_1.png',
    );
  }

  final String title;
  final String exercises;
  final String duration;
  final String imageAsset;
}

class WhatTrainRow extends StatelessWidget {
  const WhatTrainRow({required this.option, super.key, this.onViewMore});

  factory WhatTrainRow.fromMap(
    Map<String, dynamic> map, {
    VoidCallback? onViewMore,
  }) {
    return WhatTrainRow(
      option: TrainingOptionItem.fromJson(map),
      onViewMore: onViewMore,
    );
  }

  final TrainingOptionItem option;
  final VoidCallback? onViewMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColor.primaryColor2.withValues(alpha: 0.3),
              TColor.primaryColor1.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${option.exercises} | ${option.duration}',
                    style: const TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 100,
                    height: 30,
                    child: RoundButton(
                      title: 'View More',
                      fontSize: 10,
                      type: RoundButtonType.textGradient,
                      elevation: 0.05,
                      fontWeight: FontWeight.w400,
                      onPressed: onViewMore ?? () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.54),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    option.imageAsset,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
