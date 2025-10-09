// lib/view/meal_planner/meal_schedule_view.dart

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common_widget/meal_food_schedule_row.dart';
import '../../common_widget/nutritions_row.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  static const List<Map<String, String>> _breakfastMeals = [
    {
      'name': 'Honey Pancake',
      'time': '07:00am',
      'image': 'assets/img/honey_pan.png',
    },
    {'name': 'Coffee', 'time': '07:30am', 'image': 'assets/img/coffee.png'},
  ];

  static const List<Map<String, String>> _lunchMeals = [
    {
      'name': 'Chicken Steak',
      'time': '01:00pm',
      'image': 'assets/img/chicken.png',
    },
    {
      'name': 'Milk',
      'time': '01:20pm',
      'image': 'assets/img/glass-of-milk 1.png',
    },
  ];

  static const List<Map<String, String>> _snackMeals = [
    {'name': 'Orange', 'time': '04:30pm', 'image': 'assets/img/orange.png'},
    {
      'name': 'Apple Pie',
      'time': '04:40pm',
      'image': 'assets/img/apple_pie.png',
    },
  ];

  static const List<Map<String, String>> _dinnerMeals = [
    {'name': 'Salad', 'time': '07:10pm', 'image': 'assets/img/salad.png'},
    {'name': 'Oatmeal', 'time': '08:10pm', 'image': 'assets/img/oatmeal.png'},
  ];

  static const List<Map<String, String>> _nutritionItems = [
    {
      'title': 'Calories',
      'image': 'assets/img/burn.png',
      'unit_name': 'kCal',
      'value': '350',
      'max_value': '500',
    },
    {
      'title': 'Proteins',
      'image': 'assets/img/proteins.png',
      'unit_name': 'g',
      'value': '300',
      'max_value': '1000',
    },
    {
      'title': 'Fats',
      'image': 'assets/img/egg.png',
      'unit_name': 'g',
      'value': '140',
      'max_value': '1000',
    },
    {
      'title': 'Carbo',
      'image': 'assets/img/carbo.png',
      'unit_name': 'g',
      'value': '140',
      'max_value': '1000',
    },
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
    final dateLabel = DateFormat('EEE, d MMM yyyy').format(_selectedDate);

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(dateLabel),
          _buildCalendar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealSection(
                    title: 'Breakfast',
                    subtitle: '${_breakfastMeals.length} Items | 230 calories',
                    data: _breakfastMeals,
                  ),
                  _buildMealSection(
                    title: 'Lunch',
                    subtitle: '${_lunchMeals.length} Items | 500 calories',
                    data: _lunchMeals,
                  ),
                  _buildMealSection(
                    title: 'Snacks',
                    subtitle: '${_snackMeals.length} Items | 140 calories',
                    data: _snackMeals,
                  ),
                  _buildMealSection(
                    title: 'Dinner',
                    subtitle: '${_dinnerMeals.length} Items | 120 calories',
                    data: _dinnerMeals,
                  ),
                  SizedBox(height: media.width * 0.05),
                  _buildNutritionHeader(),
                  _buildNutritionList(),
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
        'Meal  Schedule',
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: _MoreActionButton(),
        ),
      ],
    );
  }

  Widget _buildDateSelector(String dateLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: _goPrevDay,
            icon: Image.asset('assets/img/ArrowLeft.png', width: 18, height: 18),
            tooltip: 'Previous day',
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
            icon:
                Image.asset('assets/img/ArrowRight.png', width: 18, height: 18),
            tooltip: 'Next day',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return CalendarAgenda(
      controller: _calendarCtrl,
      appbar: false,
      leading: IconButton(
        onPressed: _goPrevDay,
        icon: const Icon(Icons.chevron_left),
        tooltip: 'Previous day',
      ),
      weekDay: WeekDay.short,
      backgroundColor: Colors.transparent,
      calendarBackground: Colors.white,
      selectedDateColor: Colors.white,
      dateColor: Colors.black,
      locale: 'en',
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
    required String title,
    required String subtitle,
    required List<Map<String, String>> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
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
          itemCount: data.length,
          itemBuilder: (context, index) =>
              MealFoodScheduleRow(mObj: data[index], index: index),
        ),
      ],
    );
  }

  Widget _buildNutritionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        'Today Meal Nutritions',
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildNutritionList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _nutritionItems.length,
      itemBuilder: (context, index) => NutritionRow(nObj: _nutritionItems[index]),
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
