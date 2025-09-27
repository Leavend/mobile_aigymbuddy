// lib/view/workout_tracker/workout_schedule_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common/common.dart';
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
    _selectedDateAppBBar = DateTime.now();
    setDayEventWorkoutList();
  }

  void setDayEventWorkoutList() {
    final date = dateToStartDate(_selectedDateAppBBar);
    selectDayEventArr = eventArr
        .map((wObj) {
          return {
            "name": wObj["name"],
            "start_time": wObj["start_time"],
            "date": stringToDate(
              wObj["start_time"]!,
              formatStr: "dd/MM/yyyy hh:mm aa",
            ),
          };
        })
        .where((wObj) => dateToStartDate(wObj["date"] as DateTime) == date)
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
            onTap: () {},
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
            leading: IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/img/ArrowLeft.png",
                width: 15,
                height: 15,
              ),
            ),
            // NOTE: 'training' parameter tidak ada di paket → dihapus
            weekDay: WeekDay.short,
            backgroundColor: Colors.transparent,
            fullCalendarScroll: FullCalendarScroll.horizontal,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.white,
            dateColor: Colors.black,
            locale: 'en',
            initialDate: DateTime.now(),
            calendarEventColor: TColor.primaryColor2,
            firstDate: DateTime.now().subtract(const Duration(days: 140)),
            lastDate: DateTime.now().add(const Duration(days: 60)),
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
                              getTime(index * 60),
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
                                children: slotArr.map((sObj) {
                                  final min = (sObj["date"] as DateTime).minute;
                                  // range (-1 .. 1)
                                  final pos = (min / 60) * 2 - 1;

                                  return Align(
                                    alignment: Alignment(pos, 0),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              contentPadding: EdgeInsets.zero,
                                              content: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 20,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: TColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () =>
                                                              context.pop(),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets.all(
                                                                  8,
                                                                ),
                                                            height: 40,
                                                            width: 40,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: TColor
                                                                      .lightGray,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Image.asset(
                                                              "assets/img/closed_btn.png",
                                                              width: 15,
                                                              height: 15,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Workout Schedule",
                                                          style: TextStyle(
                                                            color: TColor.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets.all(
                                                                  8,
                                                                ),
                                                            height: 40,
                                                            width: 40,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: TColor
                                                                      .lightGray,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Image.asset(
                                                              "assets/img/more_btn.png",
                                                              width: 15,
                                                              height: 15,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      sObj["name"].toString(),
                                                      style: TextStyle(
                                                        color: TColor.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          "${getDayTitle(sObj["start_time"].toString())} | ${getStringDateToOtherFormate(sObj["start_time"].toString(), outFormatStr: "h:mm aa")}",
                                                          style: TextStyle(
                                                            color: TColor.gray,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 15),
                                                    RoundButton(
                                                      title: "Mark Done",
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
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
                                          "${sObj["name"]}, ${getStringDateToOtherFormate(sObj["start_time"].toString(), outFormatStr: "h:mm aa")}",
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
        onTap: () {
          context.push(
            AppRoute.addWorkoutSchedule,
            extra: _selectedDateAppBBar,
          );
        },
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
}
