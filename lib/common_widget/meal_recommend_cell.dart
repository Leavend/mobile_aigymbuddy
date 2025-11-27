// lib/common_widget/meal_recommend_cell.dart

import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

@immutable
class MealRecommendationItem {
  const MealRecommendationItem({
    required this.name,
    required this.size,
    required this.time,
    required this.kcal,
    required this.imageAsset,
  });

  factory MealRecommendationItem.fromJson(Map<String, dynamic> json) {
    return MealRecommendationItem(
      name: json['name']?.toString() ?? 'Meal',
      size: json['size']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      kcal: json['kcal']?.toString() ?? '',
      imageAsset: json['image']?.toString() ?? 'assets/img/m_1.png',
    );
  }

  final String name;
  final String size;
  final String time;
  final String kcal;
  final String imageAsset;
}

class MealRecommendCell extends StatelessWidget {
  const MealRecommendCell({
    super.key,
    required this.index,
    required this.meal,
    this.buttonLabel,
    this.onViewPressed,
  });

  factory MealRecommendCell.fromMap(
    Map<String, dynamic> map, {
    required int index,
    String? buttonLabel,
    VoidCallback? onViewPressed,
  }) {
    return MealRecommendCell(
      index: index,
      meal: MealRecommendationItem.fromJson(map),
      buttonLabel: buttonLabel,
      onViewPressed: onViewPressed,
    );
  }

  final int index;
  final MealRecommendationItem meal;
  final String? buttonLabel;
  final VoidCallback? onViewPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final isEven = index.isEven;

    final gradientColors = isEven
        ? [
            TColor.primaryColor2.withValues(alpha: 0.5),
            TColor.primaryColor1.withValues(alpha: 0.5),
          ]
        : [
            TColor.secondaryColor2.withValues(alpha: 0.5),
            TColor.secondaryColor1.withValues(alpha: 0.5),
          ];

    return Container(
      margin: const EdgeInsets.all(5),
      width: media.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            meal.imageAsset,
            width: media.width * 0.3,
            height: media.width * 0.25,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              meal.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              '${meal.size} | ${meal.time} | ${meal.kcal}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 35,
              child: RoundButton(
                fontSize: 12,
                type: isEven
                    ? RoundButtonType.bgGradient
                    : RoundButtonType.bgSGradient,
                title: buttonLabel ?? 'View',
                onPressed: onViewPressed ?? () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
