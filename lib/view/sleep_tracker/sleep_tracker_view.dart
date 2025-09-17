// lib/view/sleep_tracker/sleep_tracker_view.dart

import 'package:aigymbuddy/view/sleep_tracker/sleep_schedule_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_sleep_schedule_row.dart';

class SleepTrackerView extends StatefulWidget {
  const SleepTrackerView({super.key});

  @override
  State<SleepTrackerView> createState() => _SleepTrackerViewState();
}

class _SleepTrackerViewState extends State<SleepTrackerView> {
  final List todaySleepArr = const [
    {
      "name": "Bedtime",
      "image": "assets/img/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes"
    },
    {
      "name": "Alarm",
      "image": "assets/img/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes"
    },
  ];

  final List<int> showingTooltipOnSpots = [4];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final tooltipsOnBar = lineBarsData1[0];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Sleep Tracker",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: media.width * 0.5,
                width: double.maxFinite,
                child: LineChart(
                  LineChartData(
                    showingTooltipIndicators: showingTooltipOnSpots.map((index) {
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
                      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                        if (response == null || response.lineBarSpots == null) {
                          return;
                        }
                        if (event is FlTapUpEvent) {
                          final spotIndex = response.lineBarSpots!.first.spotIndex;
                          setState(() {
                            showingTooltipOnSpots
                              ..clear()
                              ..add(spotIndex);
                          });
                        }
                      },
                      mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
                        if (response == null || response.lineBarSpots == null) {
                          return SystemMouseCursors.basic;
                        }
                        return SystemMouseCursors.click;
                      },
                      getTouchedSpotIndicator: (barData, spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            const FlLine(color: Colors.transparent),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, i) => FlDotCirclePainter(
                                radius: 3,
                                color: Colors.white,
                                strokeWidth: 1,
                                strokeColor: TColor.primaryColor2,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      // Versi fl_chart 1.1.x: tidak ada tooltipBgColor/tooltipRoundedRadius
                      touchTooltipData: LineTouchTooltipData(
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
                        color: TColor.yellow.withValues(alpha: 0.15),
                        strokeWidth: 2,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border.fromBorderSide(
                        BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Last Night Sleep card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.maxFinite,
                height: media.width * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.primaryG),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Last Night Sleep",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "8h 20m",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/img/SleepGraph.png",
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Daily Sleep Schedule CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: TColor.primaryColor2.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daily Sleep Schedule",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 25,
                      child: RoundButton(
                        title: "Check",
                        type: RoundButtonType.bgGradient,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SleepScheduleView(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Today Schedule
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Today Schedule",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: media.width * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: todaySleepArr.length,
                itemBuilder: (context, index) {
                  final sObj = todaySleepArr[index] as Map? ?? {};
                  return TodaySleepScheduleRow(sObj: sObj);
                },
              ),
            ),

            SizedBox(height: media.width * 0.05),
          ],
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
            colors: [TColor.primaryColor2, TColor.white],
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
        reservedSize: 40,
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
            space: 10,
            child: Text(
              text,
              style: TextStyle(color: TColor.yellow, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        },
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
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
            space: 10,
            child: Text(
              text,
              style: TextStyle(color: TColor.yellow, fontSize: 12),
            ),
          );
        },
      );
}
