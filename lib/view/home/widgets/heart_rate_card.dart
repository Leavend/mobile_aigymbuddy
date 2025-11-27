import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeartRateCard extends StatefulWidget {
  const HeartRateCard({
    super.key,
    required this.title,
    required this.nowLabel,
    required this.spots,
  });

  final LocalizedText title;
  final LocalizedText nowLabel;
  final List<FlSpot> spots;

  @override
  State<HeartRateCard> createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard> {
  final List<int> _tooltipSpots = [21];

  LineChartBarData get _heartRateLine => LineChartBarData(
    showingIndicators: _tooltipSpots,
    spots: widget.spots,
    isCurved: true,
    barWidth: 3,
    gradient: LinearGradient(colors: TColor.primaryG),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          TColor.primaryColor2.withValues(alpha: .2),
          TColor.primaryColor1.withValues(alpha: .05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    dotData: const FlDotData(show: false),
  );

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.spacingMedium,
        horizontal: UIConstants.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(UIConstants.radiusXLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localize(widget.title),
            style: TextStyle(
              color: TColor.black,
              fontSize: UIConstants.fontSizeBody,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UIConstants.spacingXSmall),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
            },
            child: Text(
              '78 BPM',
              style: TextStyle(
                color: TColor.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
                fontSize: UIConstants.fontSizeLarge,
              ),
            ),
          ),
          const SizedBox(height: UIConstants.spacingSmall),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                showingTooltipIndicators: _tooltipSpots
                    .map(
                      (i) => ShowingTooltipIndicators([
                        LineBarSpot(_heartRateLine, 0, _heartRateLine.spots[i]),
                      ]),
                    )
                    .toList(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback: (event, response) {
                    if (response?.lineBarSpots == null) {
                      return;
                    }
                    if (event is FlTapUpEvent) {
                      setState(() {
                        _tooltipSpots
                          ..clear()
                          ..add(response!.lineBarSpots!.first.spotIndex);
                      });
                    }
                  },
                  getTouchedSpotIndicator: (_, indices) => indices
                      .map(
                        (index) => TouchedSpotIndicatorData(
                          const FlLine(color: Colors.transparent),
                          FlDotData(
                            show: true,
                            getDotPainter:
                                (spot, percent, barData, spotIndex) =>
                                    FlDotCirclePainter(
                                      radius: 4,
                                      color: Colors.white,
                                      strokeWidth: 2,
                                      strokeColor: TColor.secondaryColor1,
                                    ),
                          ),
                        ),
                      )
                      .toList(),
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => TColor.secondaryColor1,
                    getTooltipItems: (_) => [
                      LineTooltipItem(
                        localize(widget.nowLabel),
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                lineBarsData: [_heartRateLine],
                minY: 0,
                maxY: 130,
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
