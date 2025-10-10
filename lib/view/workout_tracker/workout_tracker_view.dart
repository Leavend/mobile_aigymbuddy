import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/upcoming_workout_row.dart';
import '../../common_widget/what_train_row.dart';

class WorkoutTrackerView extends StatelessWidget {
  const WorkoutTrackerView({super.key});

  static const _upcomingWorkouts = <_UpcomingWorkout>[
    _UpcomingWorkout(
      imageAsset: 'assets/img/Workout1.png',
      title: LocalizedText(
        english: 'Fullbody Workout',
        indonesian: 'Latihan Seluruh Tubuh',
      ),
      time: LocalizedText(
        english: 'Today, 03:00pm',
        indonesian: 'Hari ini, 15.00',
      ),
    ),
    _UpcomingWorkout(
      imageAsset: 'assets/img/Workout2.png',
      title: LocalizedText(
        english: 'Upperbody Workout',
        indonesian: 'Latihan Tubuh Atas',
      ),
      time: LocalizedText(
        english: 'June 05, 02:00pm',
        indonesian: '5 Juni, 14.00',
      ),
    ),
  ];

  static const _trainingOptions = <_TrainingOption>[
    _TrainingOption(
      imageAsset: 'assets/img/what_1.png',
      title: LocalizedText(
        english: 'Fullbody Workout',
        indonesian: 'Latihan Seluruh Tubuh',
      ),
      exercises: LocalizedText(
        english: '11 Exercises',
        indonesian: '11 Latihan',
      ),
      duration: LocalizedText(
        english: '32 mins',
        indonesian: '32 menit',
      ),
    ),
    _TrainingOption(
      imageAsset: 'assets/img/what_2.png',
      title: LocalizedText(
        english: 'Lowerbody Workout',
        indonesian: 'Latihan Tubuh Bawah',
      ),
      exercises: LocalizedText(
        english: '12 Exercises',
        indonesian: '12 Latihan',
      ),
      duration: LocalizedText(
        english: '40 mins',
        indonesian: '40 menit',
      ),
    ),
    _TrainingOption(
      imageAsset: 'assets/img/what_3.png',
      title: LocalizedText(
        english: 'AB Workout',
        indonesian: 'Latihan Perut',
      ),
      exercises: LocalizedText(
        english: '14 Exercises',
        indonesian: '14 Latihan',
      ),
      duration: LocalizedText(
        english: '20 mins',
        indonesian: '20 menit',
      ),
    ),
  ];

  static const _dailyScheduleTitle = LocalizedText(
    english: 'Daily Workout Schedule',
    indonesian: 'Jadwal Latihan Harian',
  );

  static const _checkLabel = LocalizedText(
    english: 'Check',
    indonesian: 'Cek',
  );

  static const _upcomingTitle = LocalizedText(
    english: 'Upcoming Workout',
    indonesian: 'Latihan Mendatang',
  );

  static const _seeMoreLabel = LocalizedText(
    english: 'See More',
    indonesian: 'Lihat Semua',
  );

  static const _trainingTitle = LocalizedText(
    english: 'What Do You Want to Train',
    indonesian: 'Ingin Melatih Apa',
  );

  static const _workoutTrackerTitle = LocalizedText(
    english: 'Workout Tracker',
    indonesian: 'Pelacak Latihan',
  );

  static const _viewScheduleLabel = LocalizedText(
    english: 'View schedule',
    indonesian: 'Lihat jadwal',
  );

  static const _setNewGoalLabel = LocalizedText(
    english: 'Set a new goal',
    indonesian: 'Tetapkan tujuan baru',
  );

  static const _goalComingSoon = LocalizedText(
    english: 'Goal settings coming soon.',
    indonesian: 'Pengaturan tujuan segera hadir.',
  );

  static const _scheduleTooltip = LocalizedText(
    english: 'Schedule options',
    indonesian: 'Opsi jadwal',
  );

  static const _weekdayLabels = <int, LocalizedText>{
    1: LocalizedText(english: 'Sun', indonesian: 'Min'),
    2: LocalizedText(english: 'Mon', indonesian: 'Sen'),
    3: LocalizedText(english: 'Tue', indonesian: 'Sel'),
    4: LocalizedText(english: 'Wed', indonesian: 'Rab'),
    5: LocalizedText(english: 'Thu', indonesian: 'Kam'),
    6: LocalizedText(english: 'Fri', indonesian: 'Jum'),
    7: LocalizedText(english: 'Sat', indonesian: 'Sab'),
  };

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildHeaderAppBar(context, language),
          _buildChartAppBar(media.width, language),
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
                  _buildDailyScheduleCard(context, language),
                  SizedBox(height: media.width * 0.05),
                  _buildUpcomingSection(context, language),
                  SizedBox(height: media.width * 0.05),
                  _buildTrainingSection(context, language),
                  SizedBox(height: media.width * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildHeaderAppBar(BuildContext context, AppLanguage language) {
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
        _workoutTrackerTitle.resolve(language),
        style: TextStyle(
          color: TColor.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Semantics(
          label: _scheduleTooltip.resolve(language),
          button: true,
          child: InkWell(
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
        ),
      ],
    );
  }

  SliverAppBar _buildChartAppBar(double width, AppLanguage language) {
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
        child: LineChart(_buildChartData(language)),
      ),
    );
  }

  Widget _buildDailyScheduleCard(BuildContext context, AppLanguage language) {
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
            _dailyScheduleTitle.resolve(language),
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
              title: _checkLabel.resolve(language),
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

  Widget _buildUpcomingSection(BuildContext context, AppLanguage language) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _upcomingTitle.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => _openSchedule(context),
              child: Text(
                _seeMoreLabel.resolve(language),
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
            final workout = _upcomingWorkouts[index];
            final data = workout.toLocalizedMap(language);
            return InkWell(
              onTap: () => _openWorkoutDetail(context, data),
              child: UpcomingWorkoutRow.fromMap(data),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrainingSection(BuildContext context, AppLanguage language) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _trainingTitle.resolve(language),
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
            final option = _trainingOptions[index];
            final data = option.toLocalizedMap(language);
            return InkWell(
              onTap: () => _openWorkoutDetail(context, data),
              child: WhatTrainRow.fromMap(
                data,
                onViewMore: () => _openWorkoutDetail(context, data),
              ),
            );
          },
        ),
      ],
    );
  }

  LineChartData _buildChartData(AppLanguage language) {
    final tooltipSuffix = language == AppLanguage.english
        ? 'mins ago'
        : 'menit lalu';

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots
              .map(
                (spot) => LineTooltipItem(
                  '${spot.x.toInt()} $tooltipSuffix',
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
        bottomTitles: AxisTitles(sideTitles: _buildBottomTitles(language)),
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

  SideTitles _buildBottomTitles(AppLanguage language) {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: (value, _) {
        final label = _weekdayLabels[value.toInt()];
        if (label == null) return const SizedBox.shrink();
        return Text(
          label.resolve(language),
          style: TextStyle(color: TColor.white, fontSize: 12),
        );
      },
    );
  }

  void _openSchedule(BuildContext context) {
    context.pushNamed(AppRoute.workoutScheduleName);
  }

  void _openWorkoutDetail(
    BuildContext context,
    Map<String, String> workout,
  ) {
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
        final language = sheetContext.appLanguage;
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
                  title: Text(_viewScheduleLabel.resolve(language)),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _openSchedule(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(_setNewGoalLabel.resolve(language)),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_goalComingSoon.resolve(language)),
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

class _UpcomingWorkout {
  const _UpcomingWorkout({
    required this.imageAsset,
    required this.title,
    required this.time,
  });

  final String imageAsset;
  final LocalizedText title;
  final LocalizedText time;

  Map<String, String> toLocalizedMap(AppLanguage language) {
    return <String, String>{
      'image': imageAsset,
      'title': title.resolve(language),
      'time': time.resolve(language),
    };
  }
}

class _TrainingOption {
  const _TrainingOption({
    required this.imageAsset,
    required this.title,
    required this.exercises,
    required this.duration,
  });

  final String imageAsset;
  final LocalizedText title;
  final LocalizedText exercises;
  final LocalizedText duration;

  Map<String, String> toLocalizedMap(AppLanguage language) {
    return <String, String>{
      'image': imageAsset,
      'title': title.resolve(language),
      'exercises': exercises.resolve(language),
      'time': duration.resolve(language),
    };
  }
}
