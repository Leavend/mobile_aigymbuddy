import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BmiCard extends StatelessWidget {
  const BmiCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onPressed,
  });

  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(UIConstants.radiusXLarge),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/img/dots.png',
            height: 140,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: UIConstants.spacingLarge,
              horizontal: UIConstants.spacingLarge,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localize(title),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: UIConstants.fontSizeBody,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      localize(subtitle),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: UIConstants.fontSizeSmall,
                      ),
                    ),
                    const SizedBox(height: UIConstants.spacingMedium),
                    SizedBox(
                      width: 120,
                      height: 35,
                      child: RoundButton(
                        title: localize(buttonText),
                        type: RoundButtonType.bgSGradient,
                        fontSize: UIConstants.fontSizeSmall,
                        fontWeight: FontWeight.w400,
                        onPressed: onPressed ?? () {},
                      ),
                    ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {},
                      ),
                      startDegreeOffset: 250,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          color: TColor.secondaryColor1,
                          value: 33,
                          title: '',
                          radius: 55,
                          titlePositionPercentageOffset: 0.55,
                        ),
                        PieChartSectionData(
                          color: Colors.white,
                          value: 67,
                          title: '',
                          radius: 45,
                          titlePositionPercentageOffset: 0.55,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
