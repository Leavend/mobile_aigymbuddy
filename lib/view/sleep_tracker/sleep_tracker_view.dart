// lib/view/sleep_tracker/sleep_tracker_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common/models/sleep_schedule_entry.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_sleep_schedule_row.dart';
import 'data/mock_sleep_schedule.dart';

class SleepTrackerView extends StatefulWidget {
  const SleepTrackerView({super.key});

  @override
  State<SleepTrackerView> createState() => _SleepTrackerViewState();
}

class _SleepTrackerViewState extends State<SleepTrackerView> {
  late final List<SleepScheduleEntry> _todaySchedule;

  final List<int> _highlightedTooltipIndices = [4];

  @override
  void initState() {
    super.initState();
    _todaySchedule = mockTodaySleepSchedule;
  }

  @override
  Widget build(BuildContext context) {
    final lineBars = _lineBarsData;
    final focusedBar = lineBars.first;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        centerTitle: true,
        leading: _buildBackButton(context),
        title: Text(
          "Sleep Tracker",
          style: TextStyle(
            color: TColor.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset("assets/img/more_btn.png"),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Chart =====
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: LineChart(
                      LineChartData(
                        showingTooltipIndicators: _highlightedTooltipIndices
                            .map(
                              (index) => ShowingTooltipIndicators([
                                LineBarSpot(
                                  focusedBar,
                                  lineBars.indexOf(focusedBar),
                                  focusedBar.spots[index],
                                ),
                              ]),
                            )
                            .toList(),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          touchCallback: (event, response) {
                            if (event is! FlTapUpEvent) return;
                            final spots = response?.lineBarSpots;
                            if (spots == null || spots.isEmpty) return;

                            final selectedIndex = spots.first.spotIndex;
                            setState(() {
                              _highlightedTooltipIndices
                                ..clear()
                                ..add(selectedIndex);
                            });
                          },
                          mouseCursorResolver: (event, response) =>
                              (response?.lineBarSpots?.isNotEmpty ?? false)
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          getTouchedSpotIndicator: (barData, spotIndexes) =>
                              spotIndexes
                                  .map(
                                    (index) => TouchedSpotIndicatorData(
                                      const FlLine(color: Colors.transparent),
                                      FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, bar, i) =>
                                                FlDotCirclePainter(
                                                  radius: 3,
                                                  color: Colors.white,
                                                  strokeWidth: 1.5,
                                                  strokeColor:
                                                      TColor.primaryColor2,
                                                ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (spots) => spots
                                .map(
                                  (spot) => LineTooltipItem(
                                    "${spot.y.toInt()} hours",
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        lineBarsData: lineBars,
                        minY: -0.01,
                        maxY: 10.01,
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                          rightTitles: AxisTitles(sideTitles: _rightTitles),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 2,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: TColor.gray.withValues(alpha: 0.15),
                            strokeWidth: 2,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Last Night Sleep card =====
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Last Night Sleep",
                            style: TextStyle(color: TColor.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "8h 20m",
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            "assets/img/SleepGraph.png",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Daily Sleep Schedule CTA =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Daily Sleep Schedule",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 30,
                          child: RoundButton(
                            title: "Check",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            onPressed: () =>
                                context.pushNamed(AppRoute.sleepScheduleName),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Today Schedule =====
                  Text(
                    "Today Schedule",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _todaySchedule.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) => TodaySleepScheduleRow(
                      schedule: _todaySchedule[index],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------- Chart config ---------

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      child: Container(
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset("assets/img/black_btn.png"),
      ),
    );
  }

  List<LineChartBarData> get _lineBarsData => [_primaryLineBarData];

  LineChartBarData get _primaryLineBarData => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(
      colors: [TColor.primaryColor2, TColor.primaryColor1],
    ),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [TColor.primaryColor2.withValues(alpha: .35), TColor.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    spots: const [
      FlSpot(1, 3),
      FlSpot(2, 5),
      FlSpot(3, 4),
      FlSpot(4, 7),
      FlSpot(5, 4),
      FlSpot(6, 8),
      FlSpot(7, 5),
    ],
  );

  static SideTitles get _rightTitles => SideTitles(
    showTitles: true,
    interval: 2,
    reservedSize: 42,
    getTitlesWidget: (value, meta) {
      final labels = <int, String>{
        0: '0h',
        2: '2h',
        4: '4h',
        6: '6h',
        8: '8h',
        10: '10h',
      };
      final text = labels[value.toInt()];
      if (text == null) return const SizedBox.shrink();
      return SideTitleWidget(
        meta: meta,
        space: 8,
        child: Text(text, style: TextStyle(color: TColor.gray, fontSize: 12)),
      );
    },
  );

  static SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 28,
    interval: 1,
    getTitlesWidget: (value, meta) {
      final labels = <int, String>{
        1: 'Sun',
        2: 'Mon',
        3: 'Tue',
        4: 'Wed',
        5: 'Thu',
        6: 'Fri',
        7: 'Sat',
      };
      final text = labels[value.toInt()];
      if (text == null) return const SizedBox.shrink();
      return SideTitleWidget(
        meta: meta,
        space: 6,
        child: Text(text, style: TextStyle(color: TColor.gray, fontSize: 12)),
      );
    },
  );
}
