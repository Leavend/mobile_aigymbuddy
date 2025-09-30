import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    required this.icon,
    required this.selectIcon,
    required this.isActive,
    required this.onTap,
    this.width = 56,
    this.semanticsLabel,
    this.enableHaptics = true,
  });

  final String icon;
  final String selectIcon;
  final VoidCallback onTap;
  final bool isActive;
  final double width;

  final String? semanticsLabel;
  final bool enableHaptics;


  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(width / 2);


    final tooltipMessage = semanticsLabel?.trim();

    Widget button = InkWell(
      borderRadius: borderRadius,
      onTap: () {
        Feedback.forTap(context);
        if (enableHaptics) {
          HapticFeedback.lightImpact();
        }
        onTap();
      },
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
    );

    if (tooltipMessage != null && tooltipMessage.isNotEmpty) {
      button = Tooltip(
        message: tooltipMessage,
        enableFeedback: true,
        preferBelow: false,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        child: button,
      );
    }

    return Semantics(
      selected: isActive,
      button: true,
      label: semanticsLabel,
      child: SizedBox(
        width: width,
        child: button,

      ),
    );
  }
}
