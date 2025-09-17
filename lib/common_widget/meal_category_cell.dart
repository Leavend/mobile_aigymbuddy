// lib/common_widget/meal_category_cell.dart

import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class MealCategoryCell extends StatelessWidget {
  final Map<String, dynamic> cObj;
  final int index;

  const MealCategoryCell({
    super.key,
    required this.index,
    required this.cObj,
  });

  @override
  Widget build(BuildContext context) {
    final isEven = index.isEven;

    return Container(
      margin: const EdgeInsets.all(4),
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEven
              ? [
                  TColor.primaryColor2.withValues(alpha: 0.5),
                  TColor.primaryColor1.withValues(alpha: 0.5),
                ]
              : [
                  TColor.secondaryColor2.withValues(alpha: 0.5),
                  TColor.secondaryColor1.withValues(alpha: 0.5),
                ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(17.5),
            child: Container(
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Image.asset(
                cObj["image"].toString(),
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              cObj["name"].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
