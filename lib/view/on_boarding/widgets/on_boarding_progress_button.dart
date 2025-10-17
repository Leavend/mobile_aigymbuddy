import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class OnBoardingProgressButton extends StatelessWidget {
  const OnBoardingProgressButton({
    super.key,
    required this.progress,
    required this.gradient,
    required this.onPressed,
    required this.isLastPage,
  });

  final double progress;
  final List<Color> gradient;
  final VoidCallback onPressed;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, bottom: 40),
      child: SizedBox(
        width: 88,
        height: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: CircularProgressIndicator(
                color: TColor.primaryColor1,
                value: progress.clamp(0, 1).toDouble(),
                strokeWidth: 3,
                backgroundColor: TColor.lightGray,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.last.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SizedBox(
                width: 56,
                height: 56,
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    isLastPage
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    color: TColor.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
