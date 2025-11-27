// lib/common_widget/find_eat_cell.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';

class FindEatCell extends StatelessWidget {
  const FindEatCell({
    required this.index, required this.title, required this.subtitle, required this.imageAsset, super.key,
    this.buttonLabel,
    this.onSelect,
  });

  factory FindEatCell.fromMap(
    Map<String, String> data, {
    required int index,
    String? buttonLabel,
    VoidCallback? onSelect,
  }) {
    return FindEatCell(
      index: index,
      title: data['name'] ?? 'Meal',
      subtitle: data['number'] ?? '0 Item',
      imageAsset: data['image'] ?? 'assets/img/m_3.png',
      buttonLabel: buttonLabel,
      onSelect: onSelect,
    );
  }

  final int index;
  final String title;
  final String subtitle;
  final String imageAsset;
  final String? buttonLabel;
  final VoidCallback? onSelect;

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
      margin: const EdgeInsets.all(8),
      width: media.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(75),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                imageAsset,
                width: media.width * 0.3,
                height: media.width * 0.25,
                fit: BoxFit.contain,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              title,
              style: const TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              subtitle,
              style: const TextStyle(color: TColor.gray, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 25,
              child: RoundButton(
                fontSize: 12,
                type: isEven
                    ? RoundButtonType.bgGradient
                    : RoundButtonType.bgSGradient,
                title: buttonLabel ?? 'Select',
                onPressed: onSelect ?? () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
