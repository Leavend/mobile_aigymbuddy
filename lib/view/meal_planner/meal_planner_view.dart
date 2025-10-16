import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common_widget/find_eat_cell.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/today_meal_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  static const List<_TodayMealData> _todayMeals = [
    _TodayMealData(
      name: LocalizedText(
        english: 'Salmon Nigiri',
        indonesian: 'Salmon Nigiri',
      ),
      image: 'assets/img/m_1.png',
      timeLabel: '28/05/2023 07:00 AM',
    ),
    _TodayMealData(
      name: LocalizedText(
        english: 'Lowfat Milk',
        indonesian: 'Susu Rendah Lemak',
      ),
      image: 'assets/img/m_2.png',
      timeLabel: '28/05/2023 08:00 AM',
    ),
  ];

  static const List<_FoodCategoryData> _foodCategories = [
    _FoodCategoryData(
      title: _MealPlannerStrings.breakfastLabel,
      subtitle: _MealPlannerStrings.foodsCount120,
      image: 'assets/img/m_3.png',
    ),
    _FoodCategoryData(
      title: _MealPlannerStrings.lunchLabel,
      subtitle: _MealPlannerStrings.foodsCount130,
      image: 'assets/img/m_4.png',
    ),
  ];

  static const List<_DropdownOption> _nutritionPeriods = [
    _DropdownOption('weekly', _MealPlannerStrings.weeklyOption),
    _DropdownOption('monthly', _MealPlannerStrings.monthlyOption),
  ];

  static const List<_DropdownOption> _mealFilters = [
    _DropdownOption('breakfast', _MealPlannerStrings.breakfastLabel),
    _DropdownOption('lunch', _MealPlannerStrings.lunchLabel),
    _DropdownOption('dinner', _MealPlannerStrings.dinnerLabel),
    _DropdownOption('snack', _MealPlannerStrings.snackLabel),
    _DropdownOption('dessert', _MealPlannerStrings.dessertLabel),
  ];

  _DropdownOption _selectedNutritionPeriod = _nutritionPeriods.first;
  _DropdownOption _selectedMealFilter = _mealFilters.first;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

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
                  _buildNutritionHeader(context, language),
                  SizedBox(height: media.width * 0.05),
                  _buildLineChart(media, language),
                  SizedBox(height: media.width * 0.05),
                  _buildDailyScheduleCard(context),
                  SizedBox(height: media.width * 0.05),
                  _buildTodayMealsHeader(context, language),
                  SizedBox(height: media.width * 0.05),
                  _buildTodayMealsList(language),
                ],
              ),
            ),
            _buildFindSomethingToEatHeader(context),
            _buildFindSomethingToEatList(context, media, language),
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
        context.localize(_MealPlannerStrings.mealPlannerTitle),
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

  Widget _buildNutritionHeader(BuildContext context, AppLanguage language) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.localize(_MealPlannerStrings.mealNutritionsTitle),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        _GradientDropdown(
          value: _selectedNutritionPeriod,
          options: _nutritionPeriods,
          language: language,
          onChanged: (value) {
            if (value == null || value == _selectedNutritionPeriod) return;
            setState(() => _selectedNutritionPeriod = value);
          },
        ),
      ],
    );
  }

  Widget _buildLineChart(Size media, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      height: media.width * 0.5,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: false,
            touchCallback: (_, __) {},
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
                        _MealPlannerStrings.minutesAgo(
                          language,
                          spot.x.toInt(),
                        ),
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
            bottomTitles: AxisTitles(sideTitles: _buildBottomTitles(language)),
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
            context.localize(_MealPlannerStrings.dailyScheduleTitle),
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
              title: context.localize(_MealPlannerStrings.checkButton),
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

  Widget _buildTodayMealsHeader(BuildContext context, AppLanguage language) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.localize(_MealPlannerStrings.todayMealsTitle),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        _GradientDropdown(
          value: _selectedMealFilter,
          options: _mealFilters,
          language: language,
          onChanged: (value) {
            if (value == null || value == _selectedMealFilter) return;
            setState(() => _selectedMealFilter = value);
          },
        ),
      ],
    );
  }

  Widget _buildTodayMealsList(AppLanguage language) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _todayMeals.length,
      itemBuilder: (context, index) {
        final meal = _todayMeals[index].toLocalizedMap(language);
        return TodayMealRow.fromMap(meal);
      },
    );
  }

  Widget _buildFindSomethingToEatHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        context.localize(_MealPlannerStrings.findSomethingTitle),
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFindSomethingToEatList(
    BuildContext context,
    Size media,
    AppLanguage language,
  ) {
    final buttonLabel = context.localize(_MealPlannerStrings.selectButton);

    return SizedBox(
      height: media.width * 0.55,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _foodCategories.length,
        itemBuilder: (context, index) {
          final category = _foodCategories[index];
          final localized = category.localized(language);
          void navigateToDetails() {
            context.push(
              AppRoute.mealFoodDetails,
              extra: MealFoodDetailsArgs(food: category.toArgsMap()),
            );
          }

          return InkWell(
            onTap: navigateToDetails,
            child: FindEatCell(
              index: index,
              title: localized.title,
              subtitle: localized.subtitle,
              imageAsset: category.image,
              buttonLabel: buttonLabel,
              onSelect: navigateToDetails,
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
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
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

  SideTitles _buildBottomTitles(AppLanguage language) {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: (value, meta) {
        final index = value.toInt() - 1;
        final label = (index >= 0 &&
                index < _MealPlannerStrings.weekdayAbbreviations.length)
            ? _MealPlannerStrings.weekdayAbbreviations[index].resolve(language)
            : '';
        return SideTitleWidget(
          meta: meta,
          space: 10,
          child: Text(
            label,
            style: TextStyle(color: TColor.gray, fontSize: 12),
          ),
        );
      },
    );
  }
}

class _GradientDropdown extends StatelessWidget {
  const _GradientDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.language,
  });

  final _DropdownOption value;
  final List<_DropdownOption> options;
  final ValueChanged<_DropdownOption?> onChanged;
  final AppLanguage language;

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
        child: DropdownButton<_DropdownOption>(
          value: value,
          onChanged: onChanged,
          icon: Icon(Icons.expand_more, color: TColor.white),
          items: options
              .map(
                (option) => DropdownMenuItem<_DropdownOption>(
                  value: option,
                  child: Text(
                    option.label.resolve(language),
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

class _DropdownOption {
  const _DropdownOption(this.id, this.label);

  final String id;
  final LocalizedText label;
}

class _TodayMealData {
  const _TodayMealData({
    required this.name,
    required this.image,
    required this.timeLabel,
  });

  final LocalizedText name;
  final String image;
  final String timeLabel;

  Map<String, String> toLocalizedMap(AppLanguage language) {
    return {'name': name.resolve(language), 'image': image, 'time': timeLabel};
  }
}

class _FoodCategoryData {
  const _FoodCategoryData({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final LocalizedText title;
  final LocalizedText subtitle;
  final String image;

  _LocalizedCategory localized(AppLanguage language) {
    return _LocalizedCategory(
      title: title.resolve(language),
      subtitle: subtitle.resolve(language),
    );
  }

  Map<String, dynamic> toArgsMap() {
    return {'name': title, 'number': subtitle, 'image': image};
  }
}

class _LocalizedCategory {
  const _LocalizedCategory({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class _MealPlannerStrings {
  static const mealPlannerTitle = LocalizedText(
    english: 'Meal Planner',
    indonesian: 'Perencana Makan',
  );

  static const mealNutritionsTitle = LocalizedText(
    english: 'Meal Nutritions',
    indonesian: 'Nutrisi Makan',
  );

  static const dailyScheduleTitle = LocalizedText(
    english: 'Daily Meal Schedule',
    indonesian: 'Jadwal Makan Harian',
  );

  static const checkButton = LocalizedText(
    english: 'Check',
    indonesian: 'Lihat',
  );

  static const todayMealsTitle = LocalizedText(
    english: 'Today Meals',
    indonesian: 'Menu Hari Ini',
  );

  static const findSomethingTitle = LocalizedText(
    english: 'Find Something to Eat',
    indonesian: 'Cari Makanan',
  );

  static const selectButton = LocalizedText(
    english: 'Select',
    indonesian: 'Pilih',
  );

  static const weeklyOption = LocalizedText(
    english: 'Weekly',
    indonesian: 'Mingguan',
  );

  static const monthlyOption = LocalizedText(
    english: 'Monthly',
    indonesian: 'Bulanan',
  );

  static const breakfastLabel = LocalizedText(
    english: 'Breakfast',
    indonesian: 'Sarapan',
  );

  static const lunchLabel = LocalizedText(
    english: 'Lunch',
    indonesian: 'Makan Siang',
  );

  static const dinnerLabel = LocalizedText(
    english: 'Dinner',
    indonesian: 'Makan Malam',
  );

  static const snackLabel = LocalizedText(
    english: 'Snack',
    indonesian: 'Camilan',
  );

  static const dessertLabel = LocalizedText(
    english: 'Dessert',
    indonesian: 'Pencuci Mulut',
  );

  static const foodsCount120 = LocalizedText(
    english: '120+ Foods',
    indonesian: '120+ Menu',
  );

  static const foodsCount130 = LocalizedText(
    english: '130+ Foods',
    indonesian: '130+ Menu',
  );

  static const weekdayAbbreviations = <LocalizedText>[
    LocalizedText(english: 'Sun', indonesian: 'Min'),
    LocalizedText(english: 'Mon', indonesian: 'Sen'),
    LocalizedText(english: 'Tue', indonesian: 'Sel'),
    LocalizedText(english: 'Wed', indonesian: 'Rab'),
    LocalizedText(english: 'Thu', indonesian: 'Kam'),
    LocalizedText(english: 'Fri', indonesian: 'Jum'),
    LocalizedText(english: 'Sat', indonesian: 'Sab'),
  ];

  static String minutesAgo(AppLanguage language, int minutes) {
    if (language == AppLanguage.indonesian) {
      return '$minutes menit lalu';
    }
    return '$minutes mins ago';
  }
}
