// lib/common_widget/title_subtitle_cell.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class TitleSubtitleCell extends StatelessWidget {

  const TitleSubtitleCell({
    required this.title, required this.subtitle, super.key,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: TColor.primaryG,
              ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
            },
            child: Text(
              title,
              style: TextStyle(
                color: TColor.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(subtitle, style: const TextStyle(color: TColor.gray, fontSize: 12)),
        ],
      ),
    );
  }
}
