import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/date_time_utils.dart';
import '../../common_widget/round_button.dart';

class WorkoutScheduleView extends StatefulWidget {
  const WorkoutScheduleView({super.key});

  @override
  State<WorkoutScheduleView> createState() => _WorkoutScheduleViewState();
}

class _WorkoutScheduleViewState extends State<WorkoutScheduleView> {
  static const _rawEvents = <Map<String, String>>[
    {
      'name_en': 'Ab Workout',
      'name_id': 'Latihan Perut',
      'start_time': '25/05/2023 07:30 AM',
    },
    {
      'name_en': 'Upperbody Workout',
      'name_id': 'Latihan Tubuh Atas',
      'start_time': '25/05/2023 09:00 AM',
    },
    {
      'name_en': 'Lowerbody Workout',
      'name_id': 'Latihan Tubuh Bawah',
      'start_time': '25/05/2023 03:00 PM',
    },
    {
      'name_en': 'Ab Workout',
      'name_id': 'Latihan Perut',
      'start_time': '26/05/2023 07:30 AM',
    },
    {
      'name_en': 'Upperbody Workout',
      'name_id': 'Latihan Tubuh Atas',
      'start_time': '26/05/2023 09:00 AM',
    },
    {
      'name_en': 'Lowerbody Workout',
      'name_id': 'Latihan Tubuh Bawah',
      'start_time': '26/05/2023 03:00 PM',
    },
    {
      'name_en': 'Ab Workout',
      'name_id': 'Latihan Perut',
      'start_time': '27/05/2023 07:30 AM',
    },
    {
      'name_en': 'Upperbody Workout',
      'name_id': 'Latihan Tubuh Atas',
      'start_time': '27/05/2023 09:00 AM',
    },
    {
      'name_en': 'Lowerbody Workout',
      'name_id': 'Latihan Tubuh Bawah',
      'start_time': '27/05/2023 03:00 PM',
    },
  ];

  static const _appBarTitle = LocalizedText(
    english: 'Workout Schedule',
    indonesian: 'Jadwal Latihan',
  );

  static const _scheduleActionsTooltip = LocalizedText(
    english: 'Add schedule',
    indonesian: 'Tambah jadwal',
  );

  static const _dialogTitle = LocalizedText(
    english: 'Workout Schedule',
    indonesian: 'Jadwal Latihan',
  );

  static const _markDoneLabel = LocalizedText(
    english: 'Mark Done',
    indonesian: 'Tandai Selesai',
  );

  static const _markDoneSnack = LocalizedText(
    english: 'Marked {name} as done',
    indonesian: 'Latihan {name} selesai',
  );

  final CalendarAgendaController _calendarController =
      CalendarAgendaController();

  late DateTime _selectedDate;
  late final DateTime _firstAvailableDate;
  late final DateTime _lastAvailableDate;
  late final List<WorkoutEvent> _allEvents;

  List<WorkoutEvent> _eventsForSelectedDay = const [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _firstAvailableDate = now.subtract(const Duration(days: 140));
    _lastAvailableDate = now.add(const Duration(days: 60));
    _allEvents = _rawEvents
        .map(WorkoutEvent.fromJson)
        .whereType<WorkoutEvent>()
        .toList(growable: false);
    _updateEventsForSelectedDay();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

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
              'assets/img/black_btn.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          _appBarTitle.resolve(language),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Semantics(
            label: _scheduleActionsTooltip.resolve(language),
            button: true,
            child: InkWell(
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
                  'assets/img/more_btn.png',
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarAgenda(
            controller: _calendarController,
            appbar: false,
            selectedDayPosition: SelectedDayPosition.center,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _changeSelectedDay(-1),
                  icon: Image.asset(
                    'assets/img/ArrowLeft.png',
                    width: 15,
                    height: 15,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeSelectedDay(1),
                  icon: Transform.flip(
                    flipX: true,
                    child: Image.asset(
                      'assets/img/ArrowLeft.png',
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ],
            ),
            weekDay: WeekDay.short,
            backgroundColor: Colors.transparent,
            fullCalendarScroll: FullCalendarScroll.horizontal,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.white,
            dateColor: Colors.black,
            locale: language.code,
            initialDate: _selectedDate,
            calendarEventColor: TColor.primaryColor2,
            firstDate: _firstAvailableDate,
            lastDate: _lastAvailableDate,
            onDateSelected: (date) {
              _selectedDate = date;
              _updateEventsForSelectedDay();
            },
          ),
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
                    final slotEvents = _eventsForSelectedDay
                        .where((event) => event.startTime.hour == index)
                        .toList();

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              DateTimeUtils.formatMinutesToTime(
                                index * 60,
                                pattern: language == AppLanguage.english
                                    ? 'hh:mm a'
                                    : 'HH.mm',
                              ),
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (slotEvents.isNotEmpty)
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: slotEvents.map((event) {
                                  final minutes = event.startTime.minute;
                                  final pos = (minutes / 60) * 2 - 1;

                                  return Align(
                                    alignment: Alignment(pos, 0),
                                    child: InkWell(
                                      onTap: () => _showWorkoutDialog(event),
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
                                          '${event.name.resolve(language)}, ${_formatTime(event.startTime, language)}',
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
      floatingActionButton: Semantics(
        label: _scheduleActionsTooltip.resolve(language),
        button: true,
        child: InkWell(
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
      ),
    );
  }

  void _changeSelectedDay(int offsetDays) {
    final target = _selectedDate.add(Duration(days: offsetDays));
    final clamped = target.isBefore(_firstAvailableDate)
        ? _firstAvailableDate
        : target.isAfter(_lastAvailableDate)
            ? _lastAvailableDate
            : target;
    _selectedDate = clamped;
    _calendarController.goToDay(clamped);
    _updateEventsForSelectedDay();
  }

  void _navigateToAddSchedule() {
    context.pushNamed(
      AppRoute.addWorkoutScheduleName,
      extra: AddScheduleArgs(date: _selectedDate),
    );
  }

  Future<void> _showWorkoutDialog(WorkoutEvent event) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final language = dialogContext.appLanguage;
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
                          'assets/img/closed_btn.png',
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      _dialogTitle.resolve(language),
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
                          'assets/img/more_btn.png',
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
                  event.name.resolve(language),
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
                      'assets/img/time_workout.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_describeRelativeDay(event.startTime, language)} | ${_formatTime(event.startTime, language)}',
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                RoundButton(
                  title: _markDoneLabel.resolve(language),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true && mounted) {
      final language = context.appLanguage;
      final message = _markDoneSnack
          .resolve(language)
          .replaceFirst('{name}', event.name.resolve(language));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _updateEventsForSelectedDay() {
    final targetDate = _selectedDate.startOfDay;
    _eventsForSelectedDay = _allEvents
        .where((event) => event.startTime.startOfDay == targetDate)
        .toList(growable: false);

    if (mounted) {
      setState(() {});
    }
  }

  String _formatTime(DateTime time, AppLanguage language) {
    final format = DateFormat(
      language == AppLanguage.english ? 'h:mm a' : 'HH.mm',
      language.code,
    );
    return format.format(time);
  }

  String _describeRelativeDay(DateTime date, AppLanguage language) {
    final today = DateTimeUtils.startOfDay(DateTime.now());
    final target = DateTimeUtils.startOfDay(date);
    final difference = target.difference(today).inDays;

    if (difference == 0) {
      return language == AppLanguage.english ? 'Today' : 'Hari ini';
    }
    if (difference == 1) {
      return language == AppLanguage.english ? 'Tomorrow' : 'Besok';
    }
    if (difference == -1) {
      return language == AppLanguage.english ? 'Yesterday' : 'Kemarin';
    }

    final formatter = DateFormat('E', language.code);
    return formatter.format(date);
  }
}

class WorkoutEvent {
  const WorkoutEvent({required this.name, required this.startTime});

  final LocalizedText name;
  final DateTime startTime;

  static WorkoutEvent? fromJson(Map<String, String> json) {
    final nameEn = json['name_en'];
    final nameId = json['name_id'];
    final rawStartTime = json['start_time'];
    if (nameEn == null || nameId == null || rawStartTime == null) {
      debugPrint('Invalid workout event payload: $json');
      return null;
    }

    try {
      final startTime = DateTimeUtils.parseDate(
        rawStartTime,
        pattern: 'dd/MM/yyyy hh:mm aa',
      );
      return WorkoutEvent(
        name: LocalizedText(english: nameEn, indonesian: nameId),
        startTime: startTime,
      );
    } on FormatException catch (error) {
      debugPrint('Failed to parse date for "$nameEn": $error');
      return null;
    }
  }
}
