import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PeriodOption {
  final String key;
  final LocalizedText label;

  const PeriodOption({required this.key, required this.label});
}

class WorkoutProgressSection extends StatefulWidget {
  const WorkoutProgressSection({
    super.key,
    required this.title,
    required this.periodOptions,
    required this.nowLabel,
    required this.weekdayAbbreviations,
  });

  final LocalizedText title;
  final List<PeriodOption> periodOptions;
  final LocalizedText nowLabel;
  final List<LocalizedText> weekdayAbbreviations;

  @override
  State<WorkoutProgressSection> createState() => _WorkoutProgressSectionState();
}

class _WorkoutProgressSectionState extends State<WorkoutProgressSection> {
  late PeriodOption _selectedWorkoutPeriod;
  final List<int> _tooltipSpots = [];

  @override
  void initState() {
    super.initState();
    _selectedWorkoutPeriod = widget.periodOptions.first;
  }

  LineChartBarData get _workoutLine1 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(
      colors: [
        TColor.primaryColor2.withValues(alpha: .5),
        TColor.primaryColor1.withValues(alpha: .5),
      ],
    ),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    spots: const [
      FlSpot(1, 35),
      FlSpot(2, 70),
      FlSpot(3, 40),
      FlSpot(4, 80),
      FlSpot(5, 25),
      FlSpot(6, 70),
      FlSpot(7, 35),
    ],
  );

  LineChartBarData get _workoutLine2 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(
      colors: [
        TColor.secondaryColor2.withValues(alpha: .5),
        TColor.secondaryColor1.withValues(alpha: .5),
      ],
    ),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    spots: const [
      FlSpot(1, 80),
      FlSpot(2, 50),
      FlSpot(3, 90),
      FlSpot(4, 40),
      FlSpot(5, 80),
      FlSpot(6, 35),
      FlSpot(7, 60),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    final language = context.appLanguage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localize(widget.title),
              style: TextStyle(
                color: TColor.black,
                fontSize: UIConstants.fontSizeMedium,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PeriodOption>(
                  value: _selectedWorkoutPeriod,
                  icon: Icon(Icons.expand_more, color: TColor.white),
                  items: widget.periodOptions
                      .map(
                        (option) => DropdownMenuItem<PeriodOption>(
                          value: option,
                          child: Text(
                            option.label.resolve(language),
                            style: TextStyle(color: TColor.gray),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null || value == _selectedWorkoutPeriod) {
                      return;
                    }
                    setState(() => _selectedWorkoutPeriod = value);
                  },
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(UIConstants.radiusLarge),
                  style: TextStyle(color: TColor.gray),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.spacingMedium),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              showingTooltipIndicators: _tooltipSpots
                  .map(
                    (i) => ShowingTooltipIndicators([
                      LineBarSpot(_workoutLine1, 0, _workoutLine1.spots[i]),
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
                          getDotPainter: (spot, percent, barData, spotIndex) =>
                              FlDotCirclePainter(
                                radius: 6,
                                color: TColor.secondaryColor1,
                                strokeWidth: 2.5,
                                strokeColor: Colors.white,
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
              lineBarsData: [_workoutLine1, _workoutLine2],
              minY: 0,
              maxY: 100,
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final labels = widget.weekdayAbbreviations;
                      final index = value.toInt() - 1;
                      final text = (index >= 0 && index < labels.length)
                          ? labels[index].resolve(language)
                          : '';
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          text,
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 20,
                    getTitlesWidget: (value, _) {
                      const labels = ['0%', '20%', '40%', '60%', '80%', '100%'];
                      final index = (value ~/ 20).clamp(0, labels.length - 1);
                      return Text(
                        labels[index],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8E8E93),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: TColor.gray.withValues(alpha: .15),
                  strokeWidth: 2,
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
