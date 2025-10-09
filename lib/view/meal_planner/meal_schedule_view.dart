import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/meal_food_schedule_row.dart';
import 'package:aigymbuddy/common_widget/nutritions_row.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  static const List<_ScheduledMeal> _breakfastMeals = [
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Honey Pancake',
        indonesian: 'Pancake Madu',
      ),
      timeLabel: '07:00am',
      image: 'assets/img/honey_pan.png',
    ),
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Coffee',
        indonesian: 'Kopi',
      ),
      timeLabel: '07:30am',
      image: 'assets/img/coffee.png',
    ),
  ];

  static const List<_ScheduledMeal> _lunchMeals = [
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Chicken Steak',
        indonesian: 'Steak Ayam',
      ),
      timeLabel: '01:00pm',
      image: 'assets/img/chicken.png',
    ),
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Milk',
        indonesian: 'Susu',
      ),
      timeLabel: '01:20pm',
      image: 'assets/img/glass-of-milk 1.png',
    ),
  ];

  static const List<_ScheduledMeal> _snackMeals = [
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Orange',
        indonesian: 'Jeruk',
      ),
      timeLabel: '04:30pm',
      image: 'assets/img/orange.png',
    ),
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Apple Pie',
        indonesian: 'Pai Apel',
      ),
      timeLabel: '04:40pm',
      image: 'assets/img/apple_pie.png',
    ),
  ];

  static const List<_ScheduledMeal> _dinnerMeals = [
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Salad',
        indonesian: 'Salad',
      ),
      timeLabel: '07:10pm',
      image: 'assets/img/salad.png',
    ),
    _ScheduledMeal(
      name: LocalizedText(
        english: 'Oatmeal',
        indonesian: 'Oatmeal',
      ),
      timeLabel: '08:10pm',
      image: 'assets/img/oatmeal.png',
    ),
  ];

  static const List<_NutritionItemData> _nutritionItems = [
    _NutritionItemData(
      title: LocalizedText(english: 'Calories', indonesian: 'Kalori'),
      image: 'assets/img/burn.png',
      unitName: 'kCal',
      value: 350,
      maxValue: 500,
    ),
    _NutritionItemData(
      title: LocalizedText(english: 'Proteins', indonesian: 'Protein'),
      image: 'assets/img/proteins.png',
      unitName: 'g',
      value: 300,
      maxValue: 1000,
    ),
    _NutritionItemData(
      title: LocalizedText(english: 'Fats', indonesian: 'Lemak'),
      image: 'assets/img/egg.png',
      unitName: 'g',
      value: 140,
      maxValue: 1000,
    ),
    _NutritionItemData(
      title: LocalizedText(english: 'Carbo', indonesian: 'Karbo'),
      image: 'assets/img/carbo.png',
      unitName: 'g',
      value: 140,
      maxValue: 1000,
    ),
  ];

  final CalendarAgendaController _calendarCtrl = CalendarAgendaController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _goPrevDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      _calendarCtrl.goToDay(_selectedDate);
    });
  }

  void _goNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
      _calendarCtrl.goToDay(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;
    final dateLabel =
        DateFormat('EEE, d MMM yyyy', language.code).format(_selectedDate);

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(context, language, dateLabel),
          _buildCalendar(context, language),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealSection(
                    context: context,
                    language: language,
                    title: _MealScheduleStrings.breakfastTitle,
                    meals: _breakfastMeals,
                    calories: 230,
                  ),
                  _buildMealSection(
                    context: context,
                    language: language,
                    title: _MealScheduleStrings.lunchTitle,
                    meals: _lunchMeals,
                    calories: 500,
                  ),
                  _buildMealSection(
                    context: context,
                    language: language,
                    title: _MealScheduleStrings.snackTitle,
                    meals: _snackMeals,
                    calories: 140,
                  ),
                  _buildMealSection(
                    context: context,
                    language: language,
                    title: _MealScheduleStrings.dinnerTitle,
                    meals: _dinnerMeals,
                    calories: 120,
                  ),
                  SizedBox(height: media.width * 0.05),
                  _buildNutritionHeader(context),
                  _buildNutritionList(language),
                  SizedBox(height: media.width * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
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
      actions: const [
        Padding(padding: EdgeInsets.only(right: 8), child: _MoreActionButton()),
      ],
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    AppLanguage language,
    String dateLabel,
  ) {
    final previousTooltip =
        context.localize(_MealScheduleStrings.previousDayTooltip);
    final nextTooltip = context.localize(_MealScheduleStrings.nextDayTooltip);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: _goPrevDay,
            icon: Image.asset(
              'assets/img/ArrowLeft.png',
              width: 18,
              height: 18,
            ),
            tooltip: previousTooltip,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              dateLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: _goNextDay,
            icon: Image.asset(
              'assets/img/ArrowRight.png',
              width: 18,
              height: 18,
            ),
            tooltip: nextTooltip,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, AppLanguage language) {
    return CalendarAgenda(
      controller: _calendarCtrl,
      appbar: false,
      leading: IconButton(
        onPressed: _goPrevDay,
        icon: const Icon(Icons.chevron_left),
        tooltip: context.localize(_MealScheduleStrings.previousDayTooltip),
      ),
      weekDay: WeekDay.short,
      backgroundColor: Colors.transparent,
      calendarBackground: Colors.white,
      selectedDateColor: Colors.white,
      dateColor: Colors.black,
      locale: language.code,
      fullCalendar: true,
      fullCalendarScroll: FullCalendarScroll.horizontal,
      fullCalendarDay: WeekDay.short,
      selectedDayPosition: SelectedDayPosition.center,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 140)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      onDateSelected: (date) => setState(() => _selectedDate = date),
    );
  }

  Widget _buildMealSection({
    required BuildContext context,
    required AppLanguage language,
    required LocalizedText title,
    required List<_ScheduledMeal> meals,
    required int calories,
  }) {
    final subtitle =
        _MealScheduleStrings.mealSummary(language, meals.length, calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localize(title),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  subtitle,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: meals.length,
          itemBuilder: (context, index) => MealFoodScheduleRow.fromMap(
            meals[index].toMap(language),
            index: index,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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

  Widget _buildNutritionList(AppLanguage language) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _nutritionItems.length,
      itemBuilder: (context, index) => NutritionRow.fromMap(
        _nutritionItems[index].toMap(language),
      ),
    );
  }
}

class _MoreActionButton extends StatelessWidget {
  const _MoreActionButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(8),
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
    );
  }
}

class _ScheduledMeal {
  const _ScheduledMeal({
    required this.name,
    required this.timeLabel,
    required this.image,
  });

  final LocalizedText name;
  final String timeLabel;
  final String image;

  Map<String, dynamic> toMap(AppLanguage language) {
    return {
      'name': name.resolve(language),
      'time': timeLabel,
      'image': image,
    };
  }
}

class _NutritionItemData {
  const _NutritionItemData({
    required this.title,
    required this.image,
    required this.unitName,
    required this.value,
    required this.maxValue,
  });

  final LocalizedText title;
  final String image;
  final String unitName;
  final double value;
  final double maxValue;

  Map<String, dynamic> toMap(AppLanguage language) {
    return {
      'title': title.resolve(language),
      'image': image,
      'unit_name': unitName,
      'value': value.toString(),
      'max_value': maxValue.toString(),
    };
  }
}

class _MealScheduleStrings {
  static const mealScheduleTitle = LocalizedText(
    english: 'Meal Schedule',
    indonesian: 'Jadwal Makan',
  );

  static const previousDayTooltip = LocalizedText(
    english: 'Previous day',
    indonesian: 'Hari sebelumnya',
  );

  static const nextDayTooltip = LocalizedText(
    english: 'Next day',
    indonesian: 'Hari berikutnya',
  );

  static const breakfastTitle = LocalizedText(
    english: 'Breakfast',
    indonesian: 'Sarapan',
  );

  static const lunchTitle = LocalizedText(
    english: 'Lunch',
    indonesian: 'Makan Siang',
  );

  static const snackTitle = LocalizedText(
    english: 'Snacks',
    indonesian: 'Camilan',
  );

  static const dinnerTitle = LocalizedText(
    english: 'Dinner',
    indonesian: 'Makan Malam',
  );

  static const todayNutritionTitle = LocalizedText(
    english: 'Today Meal Nutritions',
    indonesian: 'Nutrisi Makan Hari Ini',
  );

  static String mealSummary(AppLanguage language, int itemCount, int calories) {
    final itemLabel = language == AppLanguage.indonesian
        ? 'Menu'
        : itemCount == 1
            ? 'Item'
            : 'Items';
    final calorieLabel =
        language == AppLanguage.indonesian ? 'kalori' : 'calories';
    return '$itemCount $itemLabel | $calories $calorieLabel';
  }
}
