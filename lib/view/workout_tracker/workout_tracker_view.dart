// lib/view/workout_tracker/workout_tracker_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/upcoming_workout_row.dart';
import '../../common_widget/what_train_row.dart';

class WorkoutTrackerView extends StatelessWidget {
  const WorkoutTrackerView({super.key});

  static const List<Map<String, String>> _upcomingWorkouts = [
    {
      'image': 'assets/img/Workout1.png',
      'title': 'Fullbody Workout',
      'time': 'Today, 03:00pm',
    },
    {
      'image': 'assets/img/Workout2.png',
      'title': 'Upperbody Workout',
      'time': 'June 05, 02:00pm',
    },
  ];

  static const List<Map<String, String>> _trainingOptions = [
    {
      'image': 'assets/img/what_1.png',
      'title': 'Fullbody Workout',
      'exercises': '11 Exercises',
      'time': '32mins',
    },
    {
      'image': 'assets/img/what_2.png',
      'title': 'Lowebody Workout',
      'exercises': '12 Exercises',
      'time': '40mins',
    },
    {
      'image': 'assets/img/what_3.png',
      'title': 'AB Workout',
      'exercises': '14 Exercises',
      'time': '20mins',
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
        headerSliverBuilder: (context, _) => [
          _buildHeaderAppBar(context),
          _buildChartAppBar(media.width),
        ],
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
                  _buildDailyScheduleCard(context),
                  SizedBox(height: media.width * 0.05),
                  _buildUpcomingSection(context),
                  SizedBox(height: media.width * 0.05),
                  _buildTrainingSection(context),
                  SizedBox(height: media.width * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildHeaderAppBar(BuildContext context) {
    return SliverAppBar(
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
            'assets/img/black_btn.png',
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        'Workout Tracker',
        style: TextStyle(
          color: TColor.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        InkWell(
          onTap: () => _showMoreActions(context),
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
              'assets/img/more_btn.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildChartAppBar(double width) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      expandedHeight: width * 0.5,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: width * 0.5,
        width: double.maxFinite,
        child: LineChart(_buildChartData()),
      ),
    );
  }

  Widget _buildDailyScheduleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Daily Workout Schedule',
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 95,
            height: 36,
            child: RoundButton(
              title: 'Check',
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              onPressed: () => _openSchedule(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Workout',
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => _openSchedule(context),
              child: Text(
                'See More',
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
          itemCount: _upcomingWorkouts.length,
          itemBuilder: (context, index) {
            final workout = Map<String, String>.from(_upcomingWorkouts[index]);
            return InkWell(
              onTap: () => _openWorkoutDetail(context, workout),
              child: UpcomingWorkoutRow(
                wObj: Map<String, dynamic>.from(workout),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrainingSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What Do You Want to Train',
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
          itemCount: _trainingOptions.length,
          itemBuilder: (context, index) {
            final option = Map<String, String>.from(_trainingOptions[index]);
            return InkWell(
              onTap: () => _openWorkoutDetail(context, option),
              child: WhatTrainRow(wObj: Map<String, dynamic>.from(option)),
            );
          },
        ),
      ],
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots
              .map(
                (spot) => LineTooltipItem(
                  '${spot.x.toInt()} mins ago',
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
      lineBarsData: _buildLineBars(),
      minY: -0.5,
      maxY: 110,
      titlesData: FlTitlesData(
        show: true,
        leftTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(sideTitles: _buildBottomTitles()),
        rightTitles: AxisTitles(sideTitles: _buildRightTitles()),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: 25,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: TColor.white.withValues(alpha: 0.15), strokeWidth: 2),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
    );
  }

  List<LineChartBarData> _buildLineBars() {
    return [
      LineChartBarData(
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
      ),
      LineChartBarData(
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
      ),
    ];
  }

  SideTitles _buildRightTitles() {
    const labels = <int, String>{
      0: '0%',
      20: '20%',
      40: '40%',
      60: '60%',
      80: '80%',
      100: '100%',
    };

    return SideTitles(
      showTitles: true,
      interval: 20,
      reservedSize: 40,
      getTitlesWidget: (value, _) {
        final text = labels[value.toInt()];
        if (text == null) return const SizedBox.shrink();
        return Text(
          text,
          style: TextStyle(color: TColor.white, fontSize: 12),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  SideTitles _buildBottomTitles() {
    const labels = <int, String>{
      1: 'Sun',
      2: 'Mon',
      3: 'Tue',
      4: 'Wed',
      5: 'Thu',
      6: 'Fri',
      7: 'Sat',
    };

    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: (value, _) {
        final text = labels[value.toInt()];
        if (text == null) return const SizedBox.shrink();
        return Text(text, style: TextStyle(color: TColor.white, fontSize: 12));
      },
    );
  }

  void _openSchedule(BuildContext context) {
    context.pushNamed(AppRoute.workoutScheduleName);
  }

  void _openWorkoutDetail(BuildContext context, Map<String, String> workout) {
    final detailData = <String, dynamic>{
      'title': workout['title'] ?? 'Workout',
      'time': workout['time'] ?? 'Today, 03:00pm',
      'exercises': workout['exercises'] ?? '11 Exercises',
      'image': workout['image'],
    };

    context.pushNamed(
      AppRoute.workoutDetailName,
      extra: WorkoutDetailArgs(workout: detailData),
    );
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TColor.gray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.schedule_outlined),
                  title: const Text('View schedule'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _openSchedule(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Set a new goal'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Goal settings coming soon.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
