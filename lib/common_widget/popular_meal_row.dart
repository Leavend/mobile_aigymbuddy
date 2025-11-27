// lib/common_widget/popular_meal_row.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

@immutable
class PopularMealItem {
  const PopularMealItem({
    required this.name,
    required this.size,
    required this.time,
    required this.kcal,
    required this.imageAsset,
  });

  factory PopularMealItem.fromJson(Map<String, dynamic> json) {
    return PopularMealItem(
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

class PopularMealRow extends StatelessWidget {
  const PopularMealRow({required this.meal, super.key, this.onTap});

  factory PopularMealRow.fromMap(
    Map<String, dynamic> map, {
    VoidCallback? onTap,
  }) {
    return PopularMealRow(meal: PopularMealItem.fromJson(map), onTap: onTap);
  }

  final PopularMealItem meal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          Image.asset(
            meal.imageAsset,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${meal.size} | ${meal.time} | ${meal.kcal}',
                  style: const TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ],
            ),
          ),
          Image.asset('assets/img/next_icon.png', width: 25, height: 25),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: content,
    );
  }
}
