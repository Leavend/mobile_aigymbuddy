// lib/view/meal_planner/meal_planner_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/find_eat_cell.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_meal_row.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  static const List<Map<String, String>> _todayMeals = [
    {
      'name': 'Salmon Nigiri',
      'image': 'assets/img/m_1.png',
      'time': '28/05/2023 07:00 AM',
    },
    {
      'name': 'Lowfat Milk',
      'image': 'assets/img/m_2.png',
      'time': '28/05/2023 08:00 AM',
    },
  ];

  static const List<Map<String, String>> _findSomethingToEat = [
    {
      'name': 'Breakfast',
      'image': 'assets/img/m_3.png',
      'number': '120+ Foods',
    },
    {'name': 'Lunch', 'image': 'assets/img/m_4.png', 'number': '130+ Foods'},
  ];

  static const List<String> _nutritionPeriods = ['Weekly', 'Monthly'];
  static const List<String> _mealFilters = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
  ];

  String _selectedNutritionPeriod = _nutritionPeriods.first;
  String _selectedMealFilter = _mealFilters.first;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNutritionHeader(),
                  SizedBox(height: media.width * 0.05),
                  _buildLineChart(media),
                  SizedBox(height: media.width * 0.05),
                  _buildDailyScheduleCard(),
                  SizedBox(height: media.width * 0.05),
                  _buildTodayMealsHeader(),
                  SizedBox(height: media.width * 0.05),
                  _buildTodayMealsList(),
                ],
              ),
            ),
            _buildFindSomethingToEatHeader(),
            _buildFindSomethingToEatList(media),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: _SquareIconButton(
        assetPath: 'assets/img/black_btn.png',
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Meal Planner',
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: _SquareIconButton(assetPath: 'assets/img/more_btn.png'),
        ),
      ],
    );
  }

  Widget _buildNutritionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Meal Nutritions',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        _GradientDropdown(
          value: _selectedNutritionPeriod,
          options: _nutritionPeriods,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedNutritionPeriod = value);
          },
        ),
      ],
    );
  }

  Widget _buildLineChart(Size media) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      height: media.width * 0.5,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: false,
            touchCallback: (_, _) {},
            mouseCursorResolver: (event, response) {
              final spots = response?.lineBarSpots;
              if (spots == null || spots.isEmpty) {
                return SystemMouseCursors.basic;
              }
              return SystemMouseCursors.click;
            },
            getTouchedSpotIndicator: (_, indexes) {
              return indexes
                  .map(
                    (_) => TouchedSpotIndicatorData(
                      const FlLine(color: Colors.transparent),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 3,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: TColor.secondaryColor1,
                            ),
                      ),
                    ),
                  )
                  .toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => TColor.secondaryColor1,
              getTooltipItems: (spots) {
                return spots
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
                    .toList();
              },
            ),
          ),
          lineBarsData: _lineBars,
          minY: -0.5,
          maxY: 110,
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
            horizontalInterval: 25,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: TColor.gray.withValues(alpha: 0.15),
              strokeWidth: 2,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyScheduleCard() {
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
            'Daily Meal Schedule',
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
              title: 'Check',
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              onPressed: () => context.push(AppRoute.mealSchedule),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMealsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Today Meals',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        _GradientDropdown(
          value: _selectedMealFilter,
          options: _mealFilters,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedMealFilter = value);
          },
        ),
      ],
    );
  }

  Widget _buildTodayMealsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _todayMeals.length,
      itemBuilder: (context, index) => TodayMealRow.fromMap(_todayMeals[index]),
    );
  }

  Widget _buildFindSomethingToEatHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Find Something to Eat',
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFindSomethingToEatList(Size media) {
    return SizedBox(
      height: media.width * 0.55,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _findSomethingToEat.length,
        itemBuilder: (context, index) {
          final food = _findSomethingToEat[index];
          return InkWell(
            onTap: () => context.push(
              AppRoute.mealFoodDetails,
              extra: MealFoodDetailsArgs(food: Map<String, dynamic>.from(food)),
            ),
            child: FindEatCell.fromMap(
              food,
              index: index,
              onSelect: () => context.push(
                AppRoute.mealFoodDetails,
                extra: MealFoodDetailsArgs(
                  food: Map<String, dynamic>.from(food),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<LineChartBarData> get _lineBars => [
    LineChartBarData(
      isCurved: true,
      gradient: LinearGradient(
        colors: [TColor.primaryColor2, TColor.primaryColor1],
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: Colors.white,
          strokeWidth: 1,
          strokeColor: TColor.primaryColor2,
        ),
      ),
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
  ];

  SideTitles get _rightTitles => SideTitles(
    showTitles: true,
    interval: 20,
    reservedSize: 40,
    getTitlesWidget: (value, meta) {
      const labels = ['0%', '20%', '40%', '60%', '80%', '100%'];
      final index = value ~/ 20;
      if (index < 0 || index >= labels.length) {
        return const SizedBox.shrink();
      }
      return Text(
        labels[index],
        style: TextStyle(color: TColor.gray, fontSize: 12),
        textAlign: TextAlign.center,
      );
    },
  );

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: (value, meta) {
      const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      final index = value.toInt() - 1;
      final text = (index >= 0 && index < labels.length) ? labels[index] : '';
      return SideTitleWidget(
        meta: meta,
        space: 10,
        child: Text(text, style: TextStyle(color: TColor.gray, fontSize: 12)),
      );
    },
  );
}

class _GradientDropdown extends StatelessWidget {
  const _GradientDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          icon: Icon(Icons.expand_more, color: TColor.white),
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(color: TColor.gray, fontSize: 14),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.assetPath, this.onPressed});

  final String assetPath;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
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
          assetPath,
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
