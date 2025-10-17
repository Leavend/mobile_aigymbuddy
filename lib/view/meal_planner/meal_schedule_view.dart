import 'dart:async';

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/nutrition_info.dart';
import 'package:aigymbuddy/common_widget/meal_food_schedule_row.dart';
import 'package:aigymbuddy/common_widget/nutritions_row.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/dependencies.dart';
import '../shared/models/meal/meal_schedule_entry.dart';
import '../shared/models/meal/meal_period.dart';
import 'controllers/meal_schedule_controller.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  final CalendarAgendaController _calendarCtrl = CalendarAgendaController();
  late final MealScheduleController _controller;
  bool _dependenciesResolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesResolved) return;
    final repository = AppDependencies.of(context).mealPlannerRepository;
    _controller = MealScheduleController(repository);
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

  void _goPrevDay() {
    final prev = _controller.selectedDate.subtract(const Duration(days: 1));
    _calendarCtrl.goToDay(prev);
    unawaited(_controller.changeDate(prev));
  }

  void _goNextDay() {
    final next = _controller.selectedDate.add(const Duration(days: 1));
    _calendarCtrl.goToDay(next);
    unawaited(_controller.changeDate(next));
  }

  @override
  Widget build(BuildContext context) {
    if (!_dependenciesResolved) {
      return const SizedBox.shrink();
    }

    final media = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final language = context.appLanguage;
        final selectedDate = _controller.selectedDate;
        final dateLabel = DateFormat('EEE, d MMM yyyy', language.code)
            .format(selectedDate);
        final meals = _controller.schedule;
        final nutrition = _controller.nutrition;
        final isScheduleLoading =
            _controller.isLoadingSchedule && meals.isEmpty;
        final isNutritionLoading =
            _controller.isLoadingNutrition && nutrition.isEmpty;

        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: TColor.white,
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(context, language, dateLabel),
                  _buildCalendar(context, language, selectedDate),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMealSections(
                            context,
                            language,
                            meals,
                            isScheduleLoading,
                          ),
                          SizedBox(height: media.width * 0.05),
                          _buildNutritionHeader(context),
                          _buildNutritionList(
                            context,
                            nutrition,
                            isNutritionLoading,
                          ),
                          SizedBox(height: media.width * 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_controller.isLoadingSchedule || _controller.isLoadingNutrition)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: InkWell(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
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
        context.localize(_MealScheduleStrings.mealScheduleTitle),
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    AppLanguage language,
    String dateLabel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            tooltip: context.localize(_MealScheduleStrings.previousDayTooltip),
            onPressed: _goPrevDay,
            icon: Image.asset('assets/img/black_btn.png', width: 20, height: 20),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  context.localize(_MealScheduleStrings.todayLabel),
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                Text(
                  dateLabel,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.localize(_MealScheduleStrings.nextDayTooltip),
            onPressed: _goNextDay,
            icon: Image.asset('assets/img/next_go.png', width: 20, height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    AppLanguage language,
    DateTime selectedDate,
  ) {
    return CalendarAgenda(
      controller: _calendarCtrl,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateSelected: (date) => unawaited(_controller.changeDate(date)),
      selectedDayPosition: SelectedDayPosition.center,
      backgroundColor: Colors.transparent,
      locale: language.code,
    );
  }

  Widget _buildMealSections(
    BuildContext context,
    AppLanguage language,
    List<MealScheduleEntry> entries,
    bool isLoading,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          context.localize(_MealScheduleStrings.noMealsPlanned),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    final groups = <MealPeriod, List<MealScheduleEntry>>{};
    for (final entry in entries) {
      groups.putIfAbsent(entry.meal.period, () => []).add(entry);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: MealPeriod.values.map((period) {
        final periodEntries = groups[period] ?? const [];
        if (periodEntries.isEmpty) {
          return const SizedBox.shrink();
        }
        final calories = periodEntries
            .map((e) => e.meal.calories ?? 0)
            .fold<int>(0, (sum, value) => sum + value);
        return _MealSection(
          title: period.label.resolve(language),
          calories: calories,
          entries: periodEntries,
          language: language,
        );
      }).toList(),
    );
  }

  Widget _buildNutritionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        context.localize(_MealScheduleStrings.todayNutritionTitle),
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildNutritionList(
    BuildContext context,
    List<NutritionInfo> infos,
    bool isLoading,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (infos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          context.localize(_MealScheduleStrings.noNutritionData),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: infos.length,
      itemBuilder: (context, index) {
        final info = infos[index];
        final progress = _toNutritionProgress(info);
        return NutritionRow(progress: progress);
      },
    );
  }

  NutritionProgress _toNutritionProgress(NutritionInfo info) {
    final numeric =
        double.tryParse(info.value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final targets = {
      'Calories': 2000.0,
      'Proteins': 150.0,
      'Fats': 70.0,
      'Carbo': 250.0,
    };
    final target = targets[info.title] ?? (numeric == 0 ? 1 : numeric);
    final unit = _unitForTitle(info.title);
    return NutritionProgress(
      title: info.title,
      unitName: unit,
      imageAsset: info.image,
      value: numeric,
      maxValue: target,
    );
  }

  String _unitForTitle(String title) {
    switch (title) {
      case 'Proteins':
      case 'Fats':
      case 'Carbo':
        return 'g';
      default:
        return 'kCal';
    }
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({
    required this.title,
    required this.calories,
    required this.entries,
    required this.language,
  });

  final String title;
  final int calories;
  final List<MealScheduleEntry> entries;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        _MealScheduleStrings.mealSummary(language, entries.length, calories);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: TColor.gray, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: entries.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final scheduleItem = MealScheduleItem(
                name: entry.meal.localizedName(language),
                timeLabel: DateFormat('h:mma').format(entry.scheduledAt),
                imageAsset: entry.meal.imageAsset,
              );
              return MealFoodScheduleRow(
                index: index,
                schedule: scheduleItem,
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MealScheduleStrings {
  static const mealScheduleTitle = LocalizedText(
    english: 'Meal Schedule',
    indonesian: 'Jadwal Makan',
  );

  static const todayLabel = LocalizedText(
    english: 'Selected Date',
    indonesian: 'Tanggal Dipilih',
  );

  static const previousDayTooltip = LocalizedText(
    english: 'Previous day',
    indonesian: 'Hari sebelumnya',
  );

  static const nextDayTooltip = LocalizedText(
    english: 'Next day',
    indonesian: 'Hari berikutnya',
  );

  static const todayNutritionTitle = LocalizedText(
    english: 'Today Meal Nutritions',
    indonesian: 'Nutrisi Makan Hari Ini',
  );

  static const noMealsPlanned = LocalizedText(
    english: 'No meals planned for this day.',
    indonesian: 'Tidak ada rencana makan pada hari ini.',
  );

  static const noNutritionData = LocalizedText(
    english: 'Nutrition summary not available.',
    indonesian: 'Ringkasan nutrisi belum tersedia.',
  );

  static String mealSummary(AppLanguage language, int count, int calories) {
    final caloriesLabel = language == AppLanguage.indonesian ? 'kalori' : 'kCal';
    final mealLabel = language == AppLanguage.indonesian ? 'menu' : 'meals';
    return '$count $mealLabel • $calories $caloriesLabel';
  }
}
