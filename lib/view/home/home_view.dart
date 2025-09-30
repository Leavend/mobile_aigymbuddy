// lib/view/home/home_view.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/workout_row.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // ----- dummy data
  final lastWorkoutArr = const [
    {
      "name": "Full Body Workout",
      "image": "assets/img/Workout1.png",
      "kcal": "180",
      "time": "20",
      "progress": 0.3,
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/img/Workout2.png",
      "kcal": "200",
      "time": "30",
      "progress": 0.4,
    },
    {
      "name": "Ab Workout",
      "image": "assets/img/Workout3.png",
      "kcal": "300",
      "time": "40",
      "progress": 0.7,
    },
  ];

  final waterArr = const [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"},
  ];

  // mini heart rate
  final List<int> heartRateTooltipSpots = [21];
  List<FlSpot> get allSpots => const [
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

  // workout progress
  final List<int> workoutTooltipSpots = [];
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
    final media = MediaQuery.of(context).size;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: heartRateTooltipSpots,
        spots: allSpots,
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
      ),
    ];
    final tooltipsOnBar = lineBarsData[0];

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
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(color: TColor.gray, fontSize: 12),
                          ),
                          Text(
                            "GYM Buddy",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(AppRoute.notification);
                        },
                        icon: Image.asset(
                          "assets/img/notification_active.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // BMI CARD (responsive)
                  _BmiCard(showingSections: _bmiSections(), media: media),

                  const SizedBox(height: 16),

                  // TODAY TARGET
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Today Target",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 86,
                          height: 30,
                          child: RoundButton(
                            title: "Check",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              context.push(AppRoute.activityTracker);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ACTIVITY STATUS
                  Text(
                    "Activity Status",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // HEART RATE CARD (fixed safe height)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Heart Rate",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (r) => LinearGradient(
                            colors: TColor.primaryG,
                          ).createShader(r),
                          child: Text(
                            "78 BPM",
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 160, // aman
                          width: double.infinity,
                          child: LineChart(
                            LineChartData(
                              showingTooltipIndicators: heartRateTooltipSpots
                                  .map((i) {
                                    return ShowingTooltipIndicators([
                                      LineBarSpot(
                                        tooltipsOnBar,
                                        0,
                                        tooltipsOnBar.spots[i],
                                      ),
                                    ]);
                                  })
                                  .toList(),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                handleBuiltInTouches: false,
                                touchCallback: (e, resp) {
                                  if (resp == null ||
                                      resp.lineBarSpots == null) {
                                    return;
                                  }
                                  if (e is FlTapUpEvent) {
                                    heartRateTooltipSpots
                                      ..clear()
                                      ..add(resp.lineBarSpots!.first.spotIndex);
                                    setState(() {});
                                  }
                                },
                                getTouchedSpotIndicator: (bar, idxs) {
                                  return idxs
                                      .map(
                                        (_) => TouchedSpotIndicatorData(
                                          const FlLine(
                                            color: Colors.transparent,
                                          ),
                                          FlDotData(
                                            show: true,
                                            getDotPainter: (
                                              _spot,
                                              _percent,
                                              _barData,
                                              _spotIndex,
                                            ) =>
                                                FlDotCirclePainter(
                                                  radius: 3,
                                                  color: Colors.white,
                                                  strokeWidth: 3,
                                                  strokeColor:
                                                      TColor.secondaryColor1,
                                                ),
                                          ),
                                        ),
                                      )
                                      .toList();
                                },
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (_) =>
                                      TColor.secondaryColor1,
                                  getTooltipItems: (spots) => [
                                    const LineTooltipItem(
                                      "now",
                                      TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              lineBarsData: lineBarsData,
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
                  ),

                  const SizedBox(height: 16),

                  // WATER + SLEEP & CALORIES (tanpa fixed height)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // WATER
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          decoration: _cardDeco(),
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
                                gradientColor: LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Water Intake",
                                      style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (r) => LinearGradient(
                                        colors: TColor.primaryG,
                                      ).createShader(r),
                                      child: Text(
                                        "4 Liters",
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Real time updates",
                                      style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...waterArr.map(
                                      (w) => _WaterRow(
                                        title: w["title"]!,
                                        sub: w["subtitle"]!,
                                        isLast: w == waterArr.last,
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

                      // SLEEP & CALORIES
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              decoration: _cardDeco(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sleep",
                                    style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (r) => LinearGradient(
                                      colors: TColor.primaryG,
                                    ).createShader(r),
                                    child: Text(
                                      "8h 20m",
                                      style: TextStyle(
                                        color: TColor.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Image.asset(
                                    "assets/img/sleep_grap.png",
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
                              decoration: _cardDeco(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Calories",
                                    style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (r) => LinearGradient(
                                      colors: TColor.primaryG,
                                    ).createShader(r),
                                    child: Text(
                                      "760 kCal",
                                      style: TextStyle(
                                        color: TColor.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
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
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                            ),
                                            child: const Text(
                                              "230kCal\nleft",
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
                                            valueNotifier: ValueNotifier(50),
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
                  ),

                  const SizedBox(height: 24),

                  // WORKOUT PROGRESS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Workout Progress",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.primaryG),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Icon(Icons.expand_more, color: TColor.white),
                            items: const ["Weekly", "Monthly"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(color: TColor.gray),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (_) {},
                            hint: const Text(
                              "Weekly",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
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
                        showingTooltipIndicators: workoutTooltipSpots
                            .map(
                              (i) => ShowingTooltipIndicators([
                                LineBarSpot(
                                  _workoutLine1,
                                  0,
                                  _workoutLine1.spots[i],
                                ),
                              ]),
                            )
                            .toList(),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          touchCallback: (e, resp) {
                            if (resp == null || resp.lineBarSpots == null) {
                              return;
                            }
                            if (e is FlTapUpEvent) {
                              workoutTooltipSpots
                                ..clear()
                                ..add(resp.lineBarSpots!.first.spotIndex);
                              setState(() {});
                            }
                          },
                          getTouchedSpotIndicator: (bar, idx) => idx
                              .map(
                                (_) => TouchedSpotIndicatorData(
                                  const FlLine(color: Colors.transparent),
                                  FlDotData(
                                    show: true,
                                    getDotPainter: (
                                      _spot,
                                      _percent,
                                      _barData,
                                      _spotIndex,
                                    ) =>
                                        FlDotCirclePainter(
                                          radius: 3,
                                          color: Colors.white,
                                          strokeWidth: 3,
                                          strokeColor: TColor.secondaryColor1,
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => TColor.secondaryColor1,
                            getTooltipItems: (spots) => [
                              const LineTooltipItem(
                                "now",
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        lineBarsData: [_workoutLine1, _workoutLine2],
                        minY: -0.5,
                        maxY: 110,
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                          rightTitles: AxisTitles(sideTitles: _rightTitles()),
                          bottomTitles: AxisTitles(
                            sideTitles: _bottomTitles(TColor.gray),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (v) => FlLine(
                            color: TColor.gray.withValues(alpha: .15),
                            strokeWidth: 2,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // LATEST WORKOUT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Latest Workout",
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lastWorkoutArr.length,
                    separatorBuilder: (_, _index) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => InkWell(
                      onTap: () {
                        context.push(AppRoute.finishedWorkout);
                      },
                      child: WorkoutRow(wObj: lastWorkoutArr[i]),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- helpers

  BoxDecoration _cardDeco() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
  );

  List<PieChartSectionData> _bmiSections() => [
    PieChartSectionData(
      color: TColor.secondaryColor1,
      value: 33,
      title: '',
      radius: 55,
      badgeWidget: const Text(
        "20,1",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    PieChartSectionData(color: Colors.white, value: 75, title: '', radius: 45),
  ];

  static SideTitles _rightTitles() => SideTitles(
    showTitles: true,
    interval: 20,
    reservedSize: 40,
    getTitlesWidget: (v, meta) {
      const labels = ['0%', '20%', '40%', '60%', '80%', '100%'];
      final i = (v ~/ 20);
      if (i < 0 || i >= labels.length) return const SizedBox.shrink();
      return Text(
        labels[i],
        style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
      );
    },
  );

  static SideTitles _bottomTitles(Color color) => SideTitles(
    showTitles: true,
    reservedSize: 24,
    interval: 1,
    getTitlesWidget: (v, meta) {
      const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      final idx = v.toInt() - 1;
      final text = (idx >= 0 && idx < labels.length) ? labels[idx] : '';
      return SideTitleWidget(
        meta: meta,
        space: 8,
        child: Text(text, style: TextStyle(color: color, fontSize: 12)),
      );
    },
  );
}

class _BmiCard extends StatelessWidget {
  final List<PieChartSectionData> showingSections;
  final Size media;
  const _BmiCard({required this.showingSections, required this.media});

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
              "assets/img/bg_dots.png",
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
                        "BMI (Body Mass Index)",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "You have a normal weight",
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
                          title: "View More",
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
  final String title;
  final String sub;
  final bool isLast;
  const _WaterRow({
    required this.title,
    required this.sub,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final tColor = TColor.secondaryColor1.withValues(alpha: .5);
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
                  color: tColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              if (!isLast)
                DottedDashedLine(
                  height: 28,
                  width: 0,
                  dashColor: tColor,
                  axis: Axis.vertical,
                ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: TColor.gray, fontSize: 10)),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (r) =>
                    LinearGradient(colors: TColor.secondaryG).createShader(r),
                child: Text(
                  sub,
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
