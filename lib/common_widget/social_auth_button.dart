import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

/// Square social authentication button with rounded corners.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.assetPath,
    this.onTap,
  });

  final String assetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.white,
          border: Border.all(
            width: 1,
            color: TColor.gray.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(assetPath, width: 20, height: 20),
      ),
    );
  }
}
