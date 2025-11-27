// lib/common_widget/today_target_cell.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class TodayTargetCell extends StatelessWidget {
  const TodayTargetCell({
    required this.icon, required this.value, required this.title, super.key,
  });
  final String icon;
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 40, height: 40, fit: BoxFit.contain),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: TColor.primaryG,
                    ).createShader(
                      Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                    );
                  },
                  child: Text(
                    value,
                    style: TextStyle(
                      color: TColor.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(color: TColor.black, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
