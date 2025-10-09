// lib/common_widget/meal_food_schedule_row.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

@immutable
class MealScheduleItem {
  const MealScheduleItem({
    required this.name,
    required this.timeLabel,
    required this.imageAsset,
  });

  factory MealScheduleItem.fromJson(Map<String, dynamic> json) {
    return MealScheduleItem(
      name: json['name']?.toString() ?? 'Meal',
      timeLabel: json['time']?.toString() ?? '',
      imageAsset: json['image']?.toString() ?? 'assets/img/m_1.png',
    );
  }

  final String name;
  final String timeLabel;
  final String imageAsset;
}

class MealFoodScheduleRow extends StatelessWidget {
  const MealFoodScheduleRow({
    super.key,
    required this.index,
    required this.schedule,
    this.onTap,
  });

  factory MealFoodScheduleRow.fromMap(
    Map<String, dynamic> map, {
    required int index,
    VoidCallback? onTap,
  }) {
    return MealFoodScheduleRow(
      index: index,
      schedule: MealScheduleItem.fromJson(map),
      onTap: onTap,
    );
  }

  final int index;
  final MealScheduleItem schedule;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = index.isEven
        ? TColor.primaryColor2.withValues(alpha: 0.4)
        : TColor.secondaryColor2.withValues(alpha: 0.4);

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
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
                  schedule.imageAsset,
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
                    schedule.name,
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    schedule.timeLabel,
                    style: TextStyle(color: TColor.gray, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: Image.asset(
                'assets/img/next_go.png',
                width: 25,
                height: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
