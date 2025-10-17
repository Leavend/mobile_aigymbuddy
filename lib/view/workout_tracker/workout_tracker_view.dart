import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../common/app_router.dart';
import '../../common/color_extension.dart';
import '../../common/localization/app_language.dart';
import '../../common/localization/app_language_scope.dart';
import '../../common/models/navigation_args.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/upcoming_workout_row.dart';
import '../../common_widget/what_train_row.dart';
import '../shared/models/workout.dart';
import '../shared/repositories/workout_repository.dart';
import 'workout_localizations.dart';
import 'workout_visuals.dart';

class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  State<WorkoutTrackerView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  static const _dailyScheduleTitle = LocalizedText(
    english: 'Daily Workout Schedule',
    indonesian: 'Jadwal Latihan Harian',
  );

  static const _checkLabel = LocalizedText(english: 'Check', indonesian: 'Cek');

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

  static const _noUpcoming = LocalizedText(
    english:
        'No workouts scheduled yet. Plan your next session to stay on track.',
    indonesian:
        'Belum ada latihan terjadwal. Jadwalkan sesi berikutnya untuk tetap konsisten.',
  );

  static const _noRecommendations = LocalizedText(
    english: 'Create a workout plan to get personalised recommendations.',
    indonesian: 'Buat rencana latihan untuk mendapatkan rekomendasi personal.',
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

  bool _initialised = false;
  late final WorkoutRepository _repository;
  late final Stream<List<WorkoutOverview>> _upcomingStream;
  late final Stream<List<WorkoutOverview>> _recommendationsStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    final deps = AppDependencies.of(context);
    _repository = deps.workoutRepository;
    _upcomingStream = _repository.watchUpcomingWorkouts(limit: 5);
    _recommendationsStream = _repository.watchRecommendations(limit: 6);
    _initialised = true;
  }

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
                  _WorkoutStreamSection(
                    stream: _upcomingStream,
                    header: _buildUpcomingHeader(context, language),
                    emptyMessage: _noUpcoming.resolve(language),
                    builder: (workouts) => _buildUpcomingList(
                      context,
                      language,
                      workouts,
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  _WorkoutStreamSection(
                    stream: _recommendationsStream,
                    header: _buildTrainingHeader(language),
                    emptyMessage: _noRecommendations.resolve(language),
                    builder: (workouts) => _buildTrainingList(
                      context,
                      language,
                      workouts,
                    ),
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

  Widget _buildUpcomingHeader(BuildContext context, AppLanguage language) {
    return Row(
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
    );
  }

  Widget _buildUpcomingList(
    BuildContext context,
    AppLanguage language,
    List<WorkoutOverview> workouts,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final overview = workouts[index];
        final item = UpcomingWorkoutItem(
          title: overview.title,
          timeLabel: WorkoutLocalizations.upcomingTimeLabel(
            language,
            overview.scheduledFor,
          ),
          imageAsset: WorkoutVisuals.coverImageFor(overview.goal),
        );
        return InkWell(
          onTap: () => _openWorkoutDetail(context, overview),
          child: UpcomingWorkoutRow(workout: item),
        );
      },
    );
  }

  Widget _buildTrainingHeader(AppLanguage language) {
    return Row(
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
    );
  }

  Widget _buildTrainingList(
    BuildContext context,
    AppLanguage language,
    List<WorkoutOverview> workouts,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final overview = workouts[index];
        final option = TrainingOptionItem(
          title: overview.title,
          exercises: WorkoutLocalizations.exerciseCount(
            language,
            overview.exerciseCount,
          ),
          duration: WorkoutLocalizations.durationLabel(
            language,
            overview.estimatedDuration,
          ),
          imageAsset: WorkoutVisuals.trainingImageFor(overview.goal),
        );
        return InkWell(
          onTap: () => _openWorkoutDetail(context, overview),
          child: WhatTrainRow(
            option: option,
            onViewMore: () => _openWorkoutDetail(context, overview),
          ),
        );
      },
    );
  }

  LineChartData _buildChartData(AppLanguage language) {
    final tooltipSuffix =
        language == AppLanguage.english ? 'mins ago' : 'menit lalu';

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
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 35),
          FlSpot(6, 60),
          FlSpot(7, 40),
        ],
      ),
    ];
  }

  SideTitles _buildBottomTitles(AppLanguage language) {
    return SideTitles(
      showTitles: true,
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

  SideTitles _buildRightTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 25,
      getTitlesWidget: (value, _) {
        if (value == 0) {
          return Text(
            '0%',
            style: TextStyle(color: TColor.white, fontSize: 12),
          );
        }
        return Text(
          '${value.toInt()}%',
          style: TextStyle(color: TColor.white, fontSize: 12),
        );
      },
    );
  }

  void _openSchedule(BuildContext context) {
    context.pushNamed(AppRoute.workoutScheduleName);
  }

  void _openWorkoutDetail(BuildContext context, WorkoutOverview overview) {
    context.pushNamed(
      AppRoute.workoutDetailName,
      extra: WorkoutDetailArgs(
        workoutId: overview.id,
        fallbackOverview: overview,
      ),
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

class _WorkoutStreamSection extends StatelessWidget {
  const _WorkoutStreamSection({
    required this.stream,
    required this.header,
    required this.builder,
    required this.emptyMessage,
  });

  final Stream<List<WorkoutOverview>> stream;
  final Widget header;
  final Widget Function(List<WorkoutOverview>) builder;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WorkoutOverview>>(
      stream: stream,
      builder: (context, snapshot) {
        final columnChildren = <Widget>[header];

        if (snapshot.hasError) {
          columnChildren.add(_ErrorPlaceholder(error: snapshot.error!));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          );
        }

        final workouts = snapshot.data;
        if (workouts == null) {
          columnChildren.add(
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          );
        }

        if (workouts.isEmpty) {
          columnChildren.add(_EmptyPlaceholder(message: emptyMessage));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          );
        }

        columnChildren.add(builder(workouts));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        );
      },
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.lightGray.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(color: TColor.gray, fontSize: 12),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
      ),
    );
  }
}
