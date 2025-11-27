import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class WaterIntakeEntry {

  const WaterIntakeEntry(this.timeRange, this.amount);
  final String timeRange;
  final String amount;
}

class HydrationRestSection extends StatelessWidget {
  const HydrationRestSection({
    required this.waterIntakeTitle, required this.realTimeUpdatesLabel, required this.waterSchedule, required this.sleepTitle, required this.caloriesTitle, required this.caloriesLeftLabel, required this.calorieProgressNotifier, super.key,
  });

  final LocalizedText waterIntakeTitle;
  final LocalizedText realTimeUpdatesLabel;
  final List<WaterIntakeEntry> waterSchedule;
  final LocalizedText sleepTitle;
  final LocalizedText caloriesTitle;
  final LocalizedText caloriesLeftLabel;
  final ValueNotifier<double> calorieProgressNotifier;

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(UIConstants.radiusXLarge),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
  );

  Widget _buildGradientText(String text, {double fontSize = 14}) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: TColor.primaryG,
        ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: TextStyle(
          color: TColor.white.withValues(alpha: 0.7),
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: UIConstants.spacingLarge,
              horizontal: UIConstants.spacingMedium,
            ),
            decoration: _cardDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleAnimationProgressBar(
                  height: 160,
                  width: 12,
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.purple,
                  ratio: .5,
                  direction: Axis.vertical,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: UIConstants.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localize(waterIntakeTitle),
                        style: const TextStyle(
                          color: TColor.black,
                          fontSize: UIConstants.fontSizeSmall,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingXSmall),
                      Text(
                        localize(realTimeUpdatesLabel),
                        style: const TextStyle(
                          color: TColor.gray,
                          fontSize: UIConstants.fontSizeSmall,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      ...waterSchedule.map(
                        (entry) => _WaterRow(
                          entry: entry,
                          isLast: entry == waterSchedule.last,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: UIConstants.spacingMedium),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: UIConstants.spacingLarge,
                  horizontal: UIConstants.spacingMedium,
                ),
                decoration: _cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localize(sleepTitle),
                      style: const TextStyle(
                        color: TColor.black,
                        fontSize: UIConstants.fontSizeSmall,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: UIConstants.spacingXSmall),
                    _buildGradientText('8h 20m'),
                    const SizedBox(height: UIConstants.spacingMedium),
                    Image.asset(
                      'assets/img/sleep_grap.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: UIConstants.spacingMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: UIConstants.spacingLarge,
                  horizontal: UIConstants.spacingMedium,
                ),
                decoration: _cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localize(caloriesTitle),
                      style: const TextStyle(
                        color: TColor.black,
                        fontSize: UIConstants.fontSizeSmall,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: UIConstants.spacingXSmall),
                    _buildGradientText('760 kCal'),
                    const SizedBox(height: UIConstants.spacingMedium),
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: TColor.primaryG,
                                ),
                                borderRadius: BorderRadius.circular(45),
                              ),
                              child: Text(
                                localize(caloriesLeftLabel),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: UIConstants.fontSizeSmall,
                                ),
                              ),
                            ),
                            SimpleCircularProgressBar(
                              progressStrokeWidth: 10,
                              backStrokeWidth: 10,
                              progressColors: TColor.primaryG,
                              backColor: Colors.grey.shade100,
                              valueNotifier: calorieProgressNotifier,
                              startAngle: -180,
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
        ),
      ],
    );
  }
}

class _WaterRow extends StatelessWidget {
  const _WaterRow({required this.entry, required this.isLast});

  final WaterIntakeEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: TColor.secondaryColor1.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: DottedDashedLine(
                  height: 25,
                  width: 0,
                  dashColor: TColor.secondaryColor1.withValues(alpha: .5),
                  axis: Axis.vertical,
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.timeRange,
                style: const TextStyle(color: TColor.gray, fontSize: 10),
              ),
              const SizedBox(height: 2),
              Text(
                entry.amount,
                style: const TextStyle(
                  color: TColor.secondaryColor1,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
