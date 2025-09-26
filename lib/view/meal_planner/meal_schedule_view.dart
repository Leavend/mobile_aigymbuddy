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
  // Controller + state tanggal terpilih
  final CalendarAgendaController _calendarCtrl = CalendarAgendaController();
  late DateTime _selectedDate;

  // Dummy data
  final List<Map<String, String>> breakfastArr = [
    {"name": "Honey Pancake", "time": "07:00am", "image": "assets/img/honey_pan.png"},
    {"name": "Coffee", "time": "07:30am", "image": "assets/img/coffee.png"},
  ];

  final List<Map<String, String>> lunchArr = [
    {"name": "Chicken Steak", "time": "01:00pm", "image": "assets/img/chicken.png"},
    {"name": "Milk", "time": "01:20pm", "image": "assets/img/glass-of-milk 1.png"},
  ];

  final List<Map<String, String>> snacksArr = [
    {"name": "Orange", "time": "04:30pm", "image": "assets/img/orange.png"},
    {"name": "Apple Pie", "time": "04:40pm", "image": "assets/img/apple_pie.png"},
  ];

  final List<Map<String, String>> dinnerArr = [
    {"name": "Salad", "time": "07:10pm", "image": "assets/img/salad.png"},
    {"name": "Oatmeal", "time": "08:10pm", "image": "assets/img/oatmeal.png"},
  ];

  final List<Map<String, String>> nutritionArr = [
    {"title": "Calories", "image": "assets/img/burn.png", "unit_name": "kCal", "value": "350", "max_value": "500"},
    {"title": "Proteins", "image": "assets/img/proteins.png", "unit_name": "g", "value": "300", "max_value": "1000"},
    {"title": "Fats", "image": "assets/img/egg.png", "unit_name": "g", "value": "140", "max_value": "1000"},
    {"title": "Carbo", "image": "assets/img/carbo.png", "unit_name": "g", "value": "140", "max_value": "1000"},
  ];

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
      appBar: AppBar(
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
            child: Image.asset("assets/img/black_btn.png", width: 15, height: 15, fit: BoxFit.contain),
          ),
        ),
        title: Text("Meal  Schedule",
            style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset("assets/img/more_btn.png", width: 15, height: 15, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kontrol tanggal sendiri (prev / label / next)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: _goPrevDay,
                  icon: Image.asset("assets/img/ArrowLeft.png", width: 18, height: 18),
                  tooltip: 'Previous day',
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    dateLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: _goNextDay,
                  icon: Image.asset("assets/img/ArrowRight.png", width: 18, height: 18),
                  tooltip: 'Next day',
                ),
              ],
            ),
          ),

          // CalendarAgenda (tanpa properti yang tidak ada)
          CalendarAgenda(
            controller: _calendarCtrl,
            appbar: false,
            // NOTE: widget ini tidak punya 'trailing', hanya 'leading'
            leading: IconButton(
              onPressed: _goPrevDay,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous day',
            ),
            // Opsi tampilan
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

            // Rentang & inisialisasi tanggal
            initialDate: _selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 140)),
            lastDate: DateTime.now().add(const Duration(days: 60)),

            // Event pilih tanggal
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },

            // Jika ingin logo pada hari terpilih, HARUS ImageProvider, contoh:
            // selectedDayLogo: const AssetImage('assets/img/your_small_logo.png'),
          ),

          // ====== KONTEN HARI INI ======
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader("Breakfast", "${breakfastArr.length} Items | 230 calories"),
                  _mealList(breakfastArr),

                  _sectionHeader("Lunch", "${lunchArr.length} Items | 500 calories"),
                  _mealList(lunchArr),

                  _sectionHeader("Snacks", "${snacksArr.length} Items | 140 calories"),
                  _mealList(snacksArr),

                  _sectionHeader("Dinner", "${dinnerArr.length} Items | 120 calories"),
                  _mealList(dinnerArr),

                  SizedBox(height: media.width * 0.05),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today Meal Nutritions",
                            style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),

                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nutritionArr.length,
                    itemBuilder: (context, index) => NutritionRow(nObj: nutritionArr[index]),
                  ),

                  SizedBox(height: media.width * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Helpers =====

  Widget _sectionHeader(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
          TextButton(
            onPressed: () {},
            child: Text(trailing, style: TextStyle(color: TColor.gray, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _mealList(List<Map<String, String>> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) => MealFoodScheduleRow(mObj: data[index], index: index),
    );
  }
}
