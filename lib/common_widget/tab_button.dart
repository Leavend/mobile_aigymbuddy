import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    required this.icon,
    required this.selectIcon,
    required this.isActive,
    required this.onTap,
    this.width = 56,
  });

  final String icon;
  final String selectIcon;
  final VoidCallback onTap;
  final bool isActive;
  final double width;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(width / 2);

    return Semantics(
      selected: isActive,
      button: true,
      child: SizedBox(
        width: width,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isActive ? selectIcon : icon,
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: isActive ? 6 : 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 6,
                  height: isActive ? 6 : 0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: TColor.secondaryG),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
