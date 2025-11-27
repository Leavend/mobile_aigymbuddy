// lib/common_widget/meal_category_cell.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

@immutable
class MealCategoryItem {
  const MealCategoryItem({required this.name, required this.imageAsset});

  factory MealCategoryItem.fromJson(Map<String, dynamic> json) {
    return MealCategoryItem(
      name: json['name']?.toString() ?? 'Category',
      imageAsset: json['image']?.toString() ?? 'assets/img/m_1.png',
    );
  }

  final String name;
  final String imageAsset;
}

class MealCategoryCell extends StatelessWidget {
  const MealCategoryCell({
    required this.index, required this.category, super.key,
    this.onTap,
  });

  factory MealCategoryCell.fromMap(
    Map<String, dynamic> map, {
    required int index,
    VoidCallback? onTap,
  }) {
    return MealCategoryCell(
      index: index,
      category: MealCategoryItem.fromJson(map),
      onTap: onTap,
    );
  }

  final int index;
  final MealCategoryItem category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEven = index.isEven;

    final cell = Container(
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Image.asset(
                category.imageAsset,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: TColor.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return cell;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: cell,
    );
  }
}
