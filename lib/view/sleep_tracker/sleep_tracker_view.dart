// lib/view/sleep_tracker/sleep_tracker_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_sleep_schedule_row.dart';

class SleepTrackerView extends StatefulWidget {
  const SleepTrackerView({super.key});

  @override
  State<SleepTrackerView> createState() => _SleepTrackerViewState();
}

class _SleepTrackerViewState extends State<SleepTrackerView> {
  final List<Map<String, String>> todaySleepArr = const [
    {
      "name": "Bedtime",
      "image": "assets/img/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes",
    },
    {
      "name": "Alarm",
      "image": "assets/img/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes",
    },
  ];

  // titik tooltip default pada chart
  final List<int> showingTooltipOnSpots = [4];

  @override
  Widget build(BuildContext context) {
    final toolbars = lineBarsData1;
    final tooltipsOnBar = toolbars[0];

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Container(
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset("assets/img/black_btn.png"),
          ),
        ),
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
                        showingTooltipIndicators: showingTooltipOnSpots.map((
                          index,
                        ) {
                          return ShowingTooltipIndicators([
                            LineBarSpot(
                              tooltipsOnBar,
                              lineBarsData1.indexOf(tooltipsOnBar),
                              tooltipsOnBar.spots[index],
                            ),
                          ]);
                        }).toList(),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          touchCallback: (event, response) {
                            if (response == null ||
                                response.lineBarSpots == null)
                              return;
                            if (event is FlTapUpEvent) {
                              final idx =
                                  response.lineBarSpots!.first.spotIndex;
                              setState(() {
                                showingTooltipOnSpots
                                  ..clear()
                                  ..add(idx);
                              });
                            }
                          },
                          mouseCursorResolver: (event, response) =>
                              (response == null ||
                                  response.lineBarSpots == null)
                              ? SystemMouseCursors.basic
                              : SystemMouseCursors.click,
                          getTouchedSpotIndicator: (barData, spotIndexes) {
                            return spotIndexes.map((index) {
                              return TouchedSpotIndicatorData(
                                const FlLine(color: Colors.transparent),
                                FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, bar, i) =>
                                      FlDotCirclePainter(
                                        radius: 3,
                                        color: Colors.white,
                                        strokeWidth: 1.5,
                                        strokeColor: TColor.primaryColor2,
                                      ),
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            // warna tooltip auto (pakai theme) – jika ingin, set getTooltipColor
                            getTooltipItems: (spots) => spots
                                .map(
                                  (s) => LineTooltipItem(
                                    "${s.y.toInt()} hours",
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
                        lineBarsData: lineBarsData1,
                        minY: -0.01,
                        maxY: 10.01,
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                          bottomTitles: AxisTitles(sideTitles: bottomTitles),
                          rightTitles: AxisTitles(sideTitles: rightTitles),
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
                            onPressed: () {
                              context.push(AppRoute.sleepSchedule);
                            },
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
                    itemCount: todaySleepArr.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final sObj = todaySleepArr[index];
                      return TodaySleepScheduleRow(sObj: sObj);
                    },
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

  List<LineChartBarData> get lineBarsData1 => [lineChartBarData1_1];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
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

  SideTitles get rightTitles => SideTitles(
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

  SideTitles get bottomTitles => SideTitles(
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
