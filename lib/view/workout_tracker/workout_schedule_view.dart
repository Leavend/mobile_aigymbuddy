// lib/view/workout_tracker/workout_schedule_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common/date_time_utils.dart';
import '../../common_widget/round_button.dart';

class WorkoutScheduleView extends StatefulWidget {
  const WorkoutScheduleView({super.key});

  @override
  State<WorkoutScheduleView> createState() => _WorkoutScheduleViewState();
}

class _WorkoutScheduleViewState extends State<WorkoutScheduleView> {
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  late DateTime _selectedDateAppBBar;
  late final DateTime _firstAvailableDate;
  late final DateTime _lastAvailableDate;

  final List<Map<String, String>> eventArr = [
    {"name": "Ab Workout", "start_time": "25/05/2023 07:30 AM"},
    {"name": "Upperbody Workout", "start_time": "25/05/2023 09:00 AM"},
    {"name": "Lowerbody Workout", "start_time": "25/05/2023 03:00 PM"},
    {"name": "Ab Workout", "start_time": "26/05/2023 07:30 AM"},
    {"name": "Upperbody Workout", "start_time": "26/05/2023 09:00 AM"},
    {"name": "Lowerbody Workout", "start_time": "26/05/2023 03:00 PM"},
    {"name": "Ab Workout", "start_time": "27/05/2023 07:30 AM"},
    {"name": "Upperbody Workout", "start_time": "27/05/2023 09:00 AM"},
    {"name": "Lowerbody Workout", "start_time": "27/05/2023 03:00 PM"},
  ];

  List<Map<String, dynamic>> selectDayEventArr = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDateAppBBar = now;
    _firstAvailableDate = now.subtract(const Duration(days: 140));
    _lastAvailableDate = now.add(const Duration(days: 60));
    setDayEventWorkoutList();
  }

  void setDayEventWorkoutList() {
    final date = DateTimeUtils.startOfDay(_selectedDateAppBBar);
    selectDayEventArr = eventArr
        .map((wObj) {
          try {
            // Try to parse the date
            return {
              "name": wObj["name"],
              "start_time": wObj["start_time"],
              "date": DateTimeUtils.parseDate(
                wObj["start_time"]!,
                pattern: "dd/MM/yyyy hh:mm aa",
              ),
            };
          } catch (e) {
            // If parsing fails, print an error and return null
            debugPrint(
              'Failed to parse date for event: ${wObj["name"]}, value: ${wObj["start_time"]}. Error: $e',
            );
            return null;
          }
        })
        // Filter out any items that failed to parse
        .where((item) => item != null)
        .where(
          (wObj) => DateTimeUtils.startOfDay(wObj!["date"] as DateTime) == date,
        )
        .cast<Map<String, dynamic>>() // Ensure the list type is correct
        .toList();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
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
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Workout Schedule",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: _navigateToAddSchedule,
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
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar (bersih dari parameter yang tak dikenal)
          CalendarAgenda(
            controller: _calendarAgendaControllerAppBar,
            appbar: false,
            selectedDayPosition: SelectedDayPosition.center,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _changeSelectedDay(-1),
                  icon: Image.asset(
                    "assets/img/ArrowLeft.png",
                    width: 15,
                    height: 15,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeSelectedDay(1),
                  icon: Transform.flip(
                    flipX: true,
                    child: Image.asset(
                      "assets/img/ArrowLeft.png",
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ],
            ),
            // NOTE: 'training' parameter tidak ada di paket → dihapus
            weekDay: WeekDay.short,
            backgroundColor: Colors.transparent,
            fullCalendarScroll: FullCalendarScroll.horizontal,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.white,
            dateColor: Colors.black,
            locale: 'en',
            initialDate: _selectedDateAppBBar,
            calendarEventColor: TColor.primaryColor2,
            firstDate: _firstAvailableDate,
            lastDate: _lastAvailableDate,
            onDateSelected: (date) {
              _selectedDateAppBBar = date;
              setDayEventWorkoutList();
            },
          ),

          // Timeline
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: media.width * 1.5,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 24,
                  separatorBuilder: (context, index) => Divider(
                    color: TColor.gray.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final availWidth = (media.width * 1.2) - (80 + 40);
                    final slotArr = selectDayEventArr.where((wObj) {
                      return (wObj["date"] as DateTime).hour == index;
                    }).toList();

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              DateTimeUtils.formatMinutesToTime(index * 60),
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (slotArr.isNotEmpty)
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: slotArr.map((raw) {
                                  final schedule = Map<String, dynamic>.from(
                                    raw,
                                  );
                                  final date = schedule["date"] as DateTime;
                                  final min = date.minute;
                                  final pos = (min / 60) * 2 - 1;

                                  return Align(
                                    alignment: Alignment(pos, 0),
                                    child: InkWell(
                                      onTap: () => _showWorkoutDialog(schedule),
                                      child: Container(
                                        height: 35,
                                        width: availWidth * 0.5,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: TColor.secondaryG,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            17.5,
                                          ),
                                        ),
                                        child: Text(
                                          "${schedule["name"]}, ${DateTimeUtils.reformatDateString(schedule["start_time"].toString(), outputPattern: "h:mm aa")}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: _navigateToAddSchedule,
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.secondaryG),
            borderRadius: BorderRadius.circular(27.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(Icons.add, size: 20, color: TColor.white),
        ),
      ),
    );
  }

  void _changeSelectedDay(int offsetDays) {
    final target = _selectedDateAppBBar.add(Duration(days: offsetDays));
    final clamped = target.isBefore(_firstAvailableDate)
        ? _firstAvailableDate
        : target.isAfter(_lastAvailableDate)
        ? _lastAvailableDate
        : target;
    _selectedDateAppBBar = clamped;
    _calendarAgendaControllerAppBar.goToDay(clamped);
    setDayEventWorkoutList();
  }

  void _navigateToAddSchedule() {
    context.push(
      AppRoute.addWorkoutSchedule,
      extra: AddScheduleArgs(date: _selectedDateAppBBar),
    );
  }

  Future<void> _showWorkoutDialog(Map<String, dynamic> schedule) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(dialogContext).pop(false),
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
                          "assets/img/closed_btn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      "Workout Schedule",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(dialogContext).pop(false);
                        _navigateToAddSchedule();
                      },
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
                          "assets/img/more_btn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  schedule["name"].toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(
                      "assets/img/time_workout.png",
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${DateTimeUtils.describeDayFromString(schedule["start_time"].toString())} | ${DateTimeUtils.reformatDateString(schedule["start_time"].toString(), outputPattern: "h:mm aa")}",
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                RoundButton(
                  title: "Mark Done",
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marked ${schedule["name"]} as done')),
      );
    }
  }
}
