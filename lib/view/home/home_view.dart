import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/workout_row.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _periodOptions = ['Weekly', 'Monthly'];

  static const List<Map<String, Object>> _lastWorkoutList = [
    {
      'name': 'Full Body Workout',
      'image': 'assets/img/Workout1.png',
      'kcal': '180',
      'time': '20',
      'progress': 0.3,
    },
    {
      'name': 'Lower Body Workout',
      'image': 'assets/img/Workout2.png',
      'kcal': '200',
      'time': '30',
      'progress': 0.4,
    },
    {
      'name': 'Ab Workout',
      'image': 'assets/img/Workout3.png',
      'kcal': '300',
      'time': '40',
      'progress': 0.7,
    },
  ];

  static const List<_WaterIntakeEntry> _waterSchedule = [
    _WaterIntakeEntry('6am - 8am', '600ml'),
    _WaterIntakeEntry('9am - 11am', '500ml'),
    _WaterIntakeEntry('11am - 2pm', '1000ml'),
    _WaterIntakeEntry('2pm - 4pm', '700ml'),
    _WaterIntakeEntry('4pm - now', '900ml'),
  ];

  static const List<FlSpot> _heartRateSpots = [
    FlSpot(0, 20),
    FlSpot(1, 25),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 30),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40),
  ];

  final List<int> _heartRateTooltipSpots = [21];
  final List<int> _workoutTooltipSpots = [];

  late final ValueNotifier<double> _calorieProgressNotifier;
  String _workoutPeriod = _periodOptions.first;

  @override
  void initState() {
    super.initState();
    _calorieProgressNotifier = ValueNotifier<double>(50);
  }

  @override
  void dispose() {
    _calorieProgressNotifier.dispose();
    super.dispose();
  }

  LineChartBarData get _heartRateLine => LineChartBarData(
    showingIndicators: _heartRateTooltipSpots,
    spots: _heartRateSpots,
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

  TextStyle get _sectionTitleStyle =>
      TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _BmiCard(showingSections: _buildBmiSections()),
                  const SizedBox(height: 16),
                  _buildTodayTarget(context),
                  const SizedBox(height: 16),
                  Text('Activity Status', style: _sectionTitleStyle),
                  const SizedBox(height: 8),
                  _buildHeartRateCard(),
                  const SizedBox(height: 16),
                  _buildHydrationAndRest(),
                  const SizedBox(height: 24),
                  _buildWorkoutProgress(),
                  const SizedBox(height: 16),
                  _buildLatestWorkout(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back,',
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
            Text(
              'GYM Buddy',
              style: TextStyle(
                color: TColor.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => context.push(AppRoute.notification),
          icon: Image.asset(
            'assets/img/notification_active.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayTarget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Today Target',
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
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
              onPressed: () => context.push(AppRoute.activityTracker),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateCard() {
    final heartRateLine = _heartRateLine;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heart Rate',
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          _buildGradientText('78 BPM', fontSize: 18),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                showingTooltipIndicators: _heartRateTooltipSpots
                    .map(
                      (i) => ShowingTooltipIndicators([
                        LineBarSpot(heartRateLine, 0, heartRateLine.spots[i]),
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
                        _heartRateTooltipSpots
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
                                    _buildIndicatorPainter(
                                      spot: spot,
                                      percent: percent,
                                      barData: barData,
                                      spotIndex: spotIndex,
                                      baseOpacity: 0.6,
                                      opacityScale: 0.3,
                                      maxSpotValue: 100,
                                      oddStrokeWidth: 2,
                                    ),
                          ),
                        ),
                      )
                      .toList(),
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => TColor.secondaryColor1,
                    getTooltipItems: (_) => const [
                      LineTooltipItem(
                        'now',
                        TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                lineBarsData: [heartRateLine],
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

  Widget _buildHydrationAndRest() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Water Intake',
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real time updates',
                        style: TextStyle(color: TColor.gray, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      ..._waterSchedule.map(
                        (entry) => _WaterRow(
                          entry: entry,
                          isLast: entry == _waterSchedule.last,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: _cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep',
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildGradientText('8h 20m'),
                    const SizedBox(height: 12),
                    Image.asset(
                      'assets/img/sleep_grap.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: _cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories',
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildGradientText('760 kCal'),
                    const SizedBox(height: 12),
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
                                gradient: LinearGradient(
                                  colors: TColor.primaryG,
                                ),
                                borderRadius: BorderRadius.circular(45),
                              ),
                              child: const Text(
                                '230kCal\nleft',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SimpleCircularProgressBar(
                              progressStrokeWidth: 10,
                              backStrokeWidth: 10,
                              progressColors: TColor.primaryG,
                              backColor: Colors.grey.shade100,
                              valueNotifier: _calorieProgressNotifier,
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

  Widget _buildWorkoutProgress() {
    final line1 = _workoutLine1;
    final line2 = _workoutLine2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Workout Progress', style: _sectionTitleStyle),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _workoutPeriod,
                  icon: Icon(Icons.expand_more, color: TColor.white),
                  items: _periodOptions
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: TColor.gray),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null || value == _workoutPeriod) {
                      return;
                    }
                    setState(() => _workoutPeriod = value);
                  },
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  style: TextStyle(color: TColor.gray),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              showingTooltipIndicators: _workoutTooltipSpots
                  .map(
                    (i) => ShowingTooltipIndicators([
                      LineBarSpot(line1, 0, line1.spots[i]),
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
                      _workoutTooltipSpots
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
                              _buildIndicatorPainter(
                                spot: spot,
                                percent: percent,
                                barData: barData,
                                spotIndex: spotIndex,
                                baseOpacity: 0.5,
                                opacityScale: 0.4,
                                maxSpotValue: 120,
                                oddStrokeWidth: 2.5,
                              ),
                        ),
                      ),
                    )
                    .toList(),
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => TColor.secondaryColor1,
                  getTooltipItems: (_) => const [
                    LineTooltipItem(
                      'now',
                      TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              lineBarsData: [line1, line2],
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
                      const labels = [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                      ];
                      final index = value.toInt() - 1;
                      final text = (index >= 0 && index < labels.length)
                          ? labels[index]
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

  Widget _buildLatestWorkout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Latest Workout', style: _sectionTitleStyle),
            TextButton(
              onPressed: () {},
              child: Text(
                'See More',
                style: TextStyle(
                  color: TColor.gray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _lastWorkoutList.length,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final workout =
                Map<String, dynamic>.from(_lastWorkoutList[index]);
            return WorkoutRow.fromMap(
              workout,
              onTap: () => context.push(AppRoute.finishedWorkout),
            );
          },
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildBmiSections() => [
    PieChartSectionData(
      color: TColor.secondaryColor1,
      value: 33,
      title: '',
      radius: 55,
      badgeWidget: const Text(
        '20,1',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    PieChartSectionData(color: Colors.white, value: 75, title: '', radius: 45),
  ];

  Widget _buildGradientText(
    String text, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w700,
    List<Color>? colors,
  }) {
    final gradientColors = colors ?? TColor.primaryG;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) =>
          LinearGradient(colors: gradientColors).createShader(rect),
      child: Text(
        text,
        style: TextStyle(
          color: TColor.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  FlDotCirclePainter _buildIndicatorPainter({
    required FlSpot spot,
    required double percent,
    required LineChartBarData barData,
    required int spotIndex,
    required double baseOpacity,
    required double opacityScale,
    required double maxSpotValue,
    double oddStrokeWidth = 2,
  }) {
    final normalizedPercent = percent.clamp(0.0, 1.0);
    final accentColor =
        barData.gradient?.colors.first ?? TColor.secondaryColor1;
    final fillOpacity =
        (baseOpacity + (spot.y / maxSpotValue).clamp(0.0, 1.0) * opacityScale)
            .clamp(0.0, 1.0);

    final strokeWidth = spotIndex.isEven ? 3.0 : oddStrokeWidth;

    return FlDotCirclePainter(
      radius: 3 + normalizedPercent * 2,
      color: accentColor.withValues(alpha: fillOpacity),
      strokeWidth: strokeWidth,
      strokeColor: accentColor,
    );
  }
}

class _BmiCard extends StatelessWidget {
  final List<PieChartSectionData> showingSections;
  const _BmiCard({required this.showingSections});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg_dots.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BMI (Body Mass Index)',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You have a normal weight',
                        style: TextStyle(
                          color: TColor.white.withValues(alpha: .8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 120,
                        height: 36,
                        child: RoundButton(
                          title: 'View More',
                          type: RoundButtonType.bgSGradient,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 250,
                      borderData: FlBorderData(show: false),
                      sections: showingSections,
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterRow extends StatelessWidget {
  final _WaterIntakeEntry entry;
  final bool isLast;
  const _WaterRow({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final indicatorColor = TColor.secondaryColor1.withValues(alpha: .5);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              if (!isLast)
                DottedDashedLine(
                  height: 28,
                  width: 0,
                  dashColor: indicatorColor,
                  axis: Axis.vertical,
                ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.timeRange,
                style: TextStyle(color: TColor.gray, fontSize: 10),
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  colors: TColor.secondaryG,
                ).createShader(rect),
                child: Text(
                  entry.amount,
                  style: TextStyle(
                    color: TColor.white.withValues(alpha: .8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterIntakeEntry {
  final String timeRange;
  final String amount;
  const _WaterIntakeEntry(this.timeRange, this.amount);
}
