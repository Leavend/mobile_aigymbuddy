// lib/view/workout_tracker/workout_tracker_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/upcoming_workout_row.dart';
import '../../common_widget/what_train_row.dart';

class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  State<WorkoutTrackerView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  // Strongly typed for safer usage downstream
  final List<Map<String, String>> latestArr = [
    {
      "image": "assets/img/Workout1.png",
      "title": "Fullbody Workout",
      "time": "Today, 03:00pm",
    },
    {
      "image": "assets/img/Workout2.png",
      "title": "Upperbody Workout",
      "time": "June 05, 02:00pm",
    },
  ];

  final List<Map<String, String>> whatArr = [
    {
      "image": "assets/img/what_1.png",
      "title": "Fullbody Workout",
      "exercises": "11 Exercises",
      "time": "32mins",
    },
    {
      "image": "assets/img/what_2.png",
      "title": "Lowebody Workout",
      "exercises": "12 Exercises",
      "time": "40mins",
    },
    {
      "image": "assets/img/what_3.png",
      "title": "AB Workout",
      "exercises": "14 Exercises",
      "time": "20mins",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header AppBar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () => context.pop(),
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
                "Workout Tracker",
                style: TextStyle(
                  color: TColor.white,
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
                ),
              ],
            ),

            // Chart area
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: const SizedBox(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: media.width * 0.5,
                width: double.maxFinite,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {
                            // no-op; biar aman lintas versi
                          },
                      mouseCursorResolver:
                          (FlTouchEvent event, LineTouchResponse? response) {
                            if (response == null ||
                                response.lineBarSpots == null) {
                              return SystemMouseCursors.basic;
                            }
                            return SystemMouseCursors.click;
                          },
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                            return spotIndexes.map((index) {
                              return TouchedSpotIndicatorData(
                                FlLine(color: Colors.transparent),
                                FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, bar, i) =>
                                      FlDotCirclePainter(
                                        radius: 3,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: TColor.secondaryColor1,
                                      ),
                                ),
                              );
                            }).toList();
                          },
                      // Gunakan hanya getTooltipItems agar kompatibel lintas versi
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                          return lineBarsSpot.map((e) {
                            return LineTooltipItem(
                              "${e.x.toInt()} mins ago",
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: lineBarsData1,
                    minY: -0.5,
                    maxY: 110,
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
                      horizontalInterval: 25,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: TColor.white.withValues(alpha: 0.15),
                        strokeWidth: 2,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },

        // Body
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: TColor.gray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),

                  // Daily schedule CTA
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Workout Schedule",
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
                              // Navigate ke halaman schedule kalau sudah ada
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: media.width * 0.05),

                  // Upcoming workout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming Workout",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See More",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: latestArr.length,
                    itemBuilder: (context, index) {
                      final wObj = latestArr[index];
                      // UpcomingWorkoutRow biasanya ambil Map<String, dynamic>
                      return UpcomingWorkoutRow(
                        wObj: Map<String, dynamic>.from(wObj),
                      );
                    },
                  ),

                  SizedBox(height: media.width * 0.05),

                  // What to train
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "What Do You Want to Train",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: whatArr.length,
                    itemBuilder: (context, index) {
                      final wObj = whatArr[index];
                      return InkWell(
                        onTap: () {
                          // Pastikan parameter bertipe Map<String, dynamic>
                          context.push(
                            AppRoute.workoutDetail,
                            extra: Map<String, dynamic>.from(wObj),
                          );
                        },
                        child: WhatTrainRow(
                          wObj: Map<String, dynamic>.from(wObj),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: media.width * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------ Chart config ------------------------

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: TColor.white,
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
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

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: TColor.white.withValues(alpha: 0.5),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
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

  // Right axis titles — refactor pakai map untuk hilangkan 'break' yang tak perlu
  SideTitles get rightTitles => SideTitles(
    showTitles: true,
    interval: 20,
    reservedSize: 40,
    getTitlesWidget: (double value, TitleMeta meta) {
      final labels = <int, String>{
        0: '0%',
        20: '20%',
        40: '40%',
        60: '60%',
        80: '80%',
        100: '100%',
      };
      final text = labels[value.toInt()];
      if (text == null) return const SizedBox.shrink();
      return Text(
        text,
        style: TextStyle(color: TColor.white, fontSize: 12),
        textAlign: TextAlign.center,
      );
    },
  );

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: (double value, TitleMeta meta) {
      final style = TextStyle(color: TColor.white, fontSize: 12);
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
      return Text(text, style: style);
    },
  );
}
