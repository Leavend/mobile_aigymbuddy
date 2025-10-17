import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssistantButton extends StatelessWidget {
  const AssistantButton({
    super.key,
    required this.diameter,
    required this.label,
    this.onPressed,
  });

  final double diameter;
  final LocalizedText label;
  final VoidCallback? onPressed;

  void _handleTap(BuildContext context) {
    Feedback.forTap(context);
    HapticFeedback.mediumImpact();
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final semanticsLabel = context.localize(label);

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
              ),
              child: InkWell(
                onTap: () => _handleTap(context),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.chat_bubble_text_fill,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
