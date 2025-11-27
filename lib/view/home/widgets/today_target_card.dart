import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodayTargetCard extends StatelessWidget {
  const TodayTargetCard({
    required this.title, required this.buttonText, super.key,
  });

  final LocalizedText title;
  final LocalizedText buttonText;

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: UIConstants.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              localize(title),
              style: const TextStyle(
                color: TColor.black,
                fontSize: UIConstants.fontSizeBody,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 95,
            height: 36,
            child: RoundButton(
              title: localize(buttonText),
              fontSize: UIConstants.fontSizeSmall,
              fontWeight: FontWeight.w500,
              onPressed: () => context.push(AppRoute.activityTracker),
            ),
          ),
        ],
      ),
    );
  }
}
