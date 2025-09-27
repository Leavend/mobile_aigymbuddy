// lib/common_widget/meal_recommend_cell.dart

import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class MealRecommendCell extends StatelessWidget {
  final Map<String, dynamic> fObj;
  final int index;

  const MealRecommendCell({super.key, required this.index, required this.fObj});

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
            (fObj['image'] ?? '').toString(),
            width: media.width * 0.3,
            height: media.width * 0.25,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              (fObj['name'] ?? '').toString(),
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
              '${(fObj['size'] ?? '').toString()} | ${(fObj['time'] ?? '').toString()} | ${(fObj['kcal'] ?? '').toString()}',
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
                title: 'View',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
