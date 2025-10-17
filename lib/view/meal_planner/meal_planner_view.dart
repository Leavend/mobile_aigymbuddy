import 'dart:async';

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

import '../../app/dependencies.dart';
import '../shared/models/meal/meal_category.dart';
import '../shared/models/meal/meal_nutrition_progress.dart';
import '../shared/models/meal/meal_period.dart';
import '../shared/models/meal/meal_period_summary.dart';
import '../shared/models/meal/meal_schedule_entry.dart';
import 'controllers/meal_planner_controller.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  late final MealPlannerController _controller;
  bool _dependenciesResolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesResolved) return;
    final repository = AppDependencies.of(context).mealPlannerRepository;
    _controller = MealPlannerController(repository);
    _dependenciesResolved = true;
    unawaited(_controller.initialise());
  }

  @override
  void dispose() {
    if (_dependenciesResolved) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_dependenciesResolved) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final media = MediaQuery.of(context).size;
        final language = context.appLanguage;
        final data = _controller.data;
        final isLoading = _controller.isLoading && data == null;
        final hasError = _controller.hasError && data == null;

        Widget body;
        if (isLoading) {
          body = const Center(child: CircularProgressIndicator());
        } else if (hasError || data == null) {
          body = _ErrorMessage(
            message: context.localize(_MealPlannerStrings.failedToLoad),
            onRetry: () => unawaited(_controller.refresh()),
          );
        } else {
          final weeklyProgress = data.weeklyProgress;
          final periodSummaries = data.periodSummaries;
          final categories = data.categories;
          final filteredSchedule = _controller.filteredSchedule;

          body = Stack(
            children: [
              SingleChildScrollView(
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
                          _NutritionChart(points: weeklyProgress),
                          SizedBox(height: media.width * 0.05),
                          _buildDailyScheduleCard(context),
                          SizedBox(height: media.width * 0.05),
                          _buildTodayMealsHeader(context, language),
                          SizedBox(height: media.width * 0.05),
                          _buildTodayMealsList(
                            context,
                            language,
                            filteredSchedule,
                          ),
                        ],
                      ),
                    ),
                    _buildFindSomethingToEatHeader(context),
                    _buildFindSomethingToEatList(
                      context,
                      media,
                      language,
                      categories,
                    ),
                    const SizedBox(height: 16),
                    _PeriodSummaryList(periods: periodSummaries),
                  ],
                ),
              ),
              if (_controller.isLoading)
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: TColor.white,
          body: body,
        );
      },
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
        _NutritionRangeDropdown(
          value: _controller.selectedRange,
          language: language,
          onChanged: (range) {
            if (range == null) return;
            _controller.selectRange(range);
          },
        ),
      ],
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
        _MealPeriodDropdown(
          selected: _controller.selectedMealPeriod,
          onChanged: (value) {
            if (value == null) return;
            _controller.selectMealPeriod(value);
          },
        ),
      ],
    );
  }

  Widget _buildTodayMealsList(
    BuildContext context,
    AppLanguage language,
    List<MealScheduleEntry> entries,
  ) {
    if (entries.isEmpty) {
      return Text(
        context.localize(_MealPlannerStrings.noMealsPlanned),
        style: TextStyle(color: TColor.gray, fontSize: 12),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final meal = entries[index];
        return TodayMealRow(
          name: meal.meal.localizedName(language),
          imageAsset: meal.meal.imageAsset,
          scheduledAt: meal.scheduledAt,
        );
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
    List<MealCategorySummary> categories,
  ) {
    if (categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          context.localize(_MealPlannerStrings.noCategoriesAvailable),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    final buttonLabel = context.localize(_MealPlannerStrings.selectButton);

    return SizedBox(
      height: media.width * 0.55,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final title = category.localizedTitle(language);
          final subtitle = _MealPlannerStrings.categorySubtitle(
            language,
            category.totalMeals,
          );

          void navigateToDetails() {
            context.push(
              AppRoute.mealFoodDetails,
              extra: MealFoodDetailsArgs(categoryId: category.id),
            );
          }

          return InkWell(
            onTap: navigateToDetails,
            child: FindEatCell(
              index: index,
              title: title,
              subtitle: subtitle,
              imageAsset: category.imageAsset,
              buttonLabel: buttonLabel,
              onSelect: navigateToDetails,
            ),
          );
        },
      ),
    );
  }
}

class _NutritionChart extends StatelessWidget {
  const _NutritionChart({required this.points});

  final List<MealNutritionProgressPoint> points;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

    if (points.isEmpty) {
      return Container(
        height: media.width * 0.5,
        alignment: Alignment.center,
        child: Text(
          context.localize(_MealPlannerStrings.noProgressData),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    final spots = points
        .asMap()
        .entries
        .map((entry) => FlSpot((entry.key + 1).toDouble(), entry.value.completion))
        .toList();

    return SizedBox(
      height: media.width * 0.5,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => TColor.secondaryColor1,
              getTooltipItems: (spots) => spots
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
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: spots,
              gradient: LinearGradient(
                colors: [TColor.primaryColor2, TColor.primaryColor1],
              ),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          minY: 0,
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: _buildBottomTitles(points, language),
            ),
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
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  static SideTitles get _rightTitles => SideTitles(
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

  static SideTitles _buildBottomTitles(
    List<MealNutritionProgressPoint> points,
    AppLanguage language,
  ) {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: (value, meta) {
        final index = value.toInt() - 1;
        if (index < 0 || index >= points.length) {
          return const SizedBox.shrink();
        }
        final weekday = points[index].day.weekday;
        final label = _MealPlannerStrings.weekdayLabel(language, weekday);
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

class _PeriodSummaryList extends StatelessWidget {
  const _PeriodSummaryList({required this.periods});

  final List<MealPeriodSummary> periods;

  @override
  Widget build(BuildContext context) {
    if (periods.isEmpty) return const SizedBox.shrink();
    final language = context.appLanguage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: periods
            .map(
              (summary) => _PeriodSummaryChip(
                title: summary.localizedTitle(language),
                subtitle: summary.localizedSubtitle(language),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PeriodSummaryChip extends StatelessWidget {
  const _PeriodSummaryChip({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: TColor.gray, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _NutritionRangeDropdown extends StatelessWidget {
  const _NutritionRangeDropdown({
    required this.value,
    required this.onChanged,
    required this.language,
  });

  final MealNutritionRange value;
  final ValueChanged<MealNutritionRange?> onChanged;
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
        child: DropdownButton<MealNutritionRange>(
          value: value,
          onChanged: onChanged,
          icon: Icon(Icons.expand_more, color: TColor.white),
          items: MealNutritionRange.values
              .map(
                (range) => DropdownMenuItem<MealNutritionRange>(
                  value: range,
                  child: Text(
                    _MealPlannerStrings.rangeLabel(language, range),
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

class _MealPeriodDropdown extends StatelessWidget {
  const _MealPeriodDropdown({required this.selected, required this.onChanged});

  final MealPeriod selected;
  final ValueChanged<MealPeriod?> onChanged;

  @override
  Widget build(BuildContext context) {
    final language = context.appLanguage;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MealPeriod>(
          value: selected,
          onChanged: onChanged,
          icon: Icon(Icons.expand_more, color: TColor.white),
          items: MealPeriod.values
              .map(
                (period) => DropdownMenuItem<MealPeriod>(
                  value: period,
                  child: Text(
                    period.label.resolve(language),
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

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: TextStyle(color: TColor.gray, fontSize: 12)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
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

  static const noMealsPlanned = LocalizedText(
    english: 'No meals planned for this period.',
    indonesian: 'Tidak ada rencana makan untuk periode ini.',
  );

  static const noCategoriesAvailable = LocalizedText(
    english: 'No categories available yet.',
    indonesian: 'Belum ada kategori tersedia.',
  );

  static const noProgressData = LocalizedText(
    english: 'No progress data available.',
    indonesian: 'Belum ada data progres.',
  );

  static const failedToLoad = LocalizedText(
    english: 'Unable to load meal planner data.',
    indonesian: 'Tidak dapat memuat data perencana makan.',
  );

  static String categorySubtitle(AppLanguage language, int count) {
    final suffix = language == AppLanguage.indonesian ? 'Menu' : 'Foods';
    return '$count $suffix';
  }

  static String minutesAgo(AppLanguage language, int minutes) {
    if (language == AppLanguage.indonesian) {
      return '$minutes menit lalu';
    }
    return '$minutes mins ago';
  }

  static String weekdayLabel(AppLanguage language, int weekday) {
    const english = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const indonesian = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final index = (weekday - 1).clamp(0, 6);
    return language == AppLanguage.indonesian
        ? indonesian[index]
        : english[index];
  }

  static String rangeLabel(AppLanguage language, MealNutritionRange range) {
    final text = switch (range) {
      MealNutritionRange.weekly => weeklyOption,
      MealNutritionRange.monthly => monthlyOption,
    };
    return text.resolve(language);
  }
}
