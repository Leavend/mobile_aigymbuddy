// lib/common_widget/meal_food_schedule_row.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class MealFoodScheduleRow extends StatelessWidget {
  final Map<String, dynamic> mObj;
  final int index;

  const MealFoodScheduleRow({
    super.key,
    required this.mObj,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = index.isEven
        ? TColor.primaryColor2.withValues(alpha: 0.4)
        : TColor.secondaryColor2.withValues(alpha: 0.4);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 55,
              width: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                (mObj['image'] ?? '').toString(),
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (mObj['name'] ?? '').toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  (mObj['time'] ?? '').toString(),
                  style: TextStyle(
                    color: TColor.yellow,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/img/next_go.png',
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}
