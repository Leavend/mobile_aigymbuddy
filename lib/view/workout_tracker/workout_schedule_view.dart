import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../common/date_time_utils.dart';
import '../../common_widget/round_button.dart';
import '../shared/models/workout.dart';
import '../shared/repositories/workout_repository.dart';
import 'workout_localizations.dart';

class WorkoutScheduleView extends StatefulWidget {
  const WorkoutScheduleView({super.key});

  @override
  State<WorkoutScheduleView> createState() => _WorkoutScheduleViewState();
}

class _WorkoutScheduleViewState extends State<WorkoutScheduleView> {
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

  static const _emptyScheduleMessage = LocalizedText(
    english: 'No workouts scheduled for this day yet.',
    indonesian: 'Belum ada latihan pada hari ini.',
  );

  final CalendarAgendaController _calendarController =
      CalendarAgendaController();

  late DateTime _selectedDate;
  late final DateTime _firstAvailableDate;
  late final DateTime _lastAvailableDate;
  late WorkoutRepository _repository;
  late Stream<List<WorkoutOverview>> _selectedDayStream;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _firstAvailableDate = now.subtract(const Duration(days: 140));
    _lastAvailableDate = now.add(const Duration(days: 60));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _repository = AppDependencies.of(context).workoutRepository;
    _selectedDayStream = _repository.watchWorkoutsForDay(_selectedDate);
    _initialised = true;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialised) {
      return const SizedBox.shrink();
    }

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
            onDateSelected: _onDateSelected,
          ),
          Expanded(
            child: StreamBuilder<List<WorkoutOverview>>(
              stream: _selectedDayStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }

                final events = snapshot.data;
                if (events == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (events.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Text(
                      _emptyScheduleMessage.resolve(language),
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  );
                }

                return _ScheduleGrid(
                  events: events,
                  language: language,
                  onTapWorkout: _showWorkoutDialog,
                );
              },
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
    _calendarController.goToDay(clamped);
    _onDateSelected(clamped);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedDayStream = _repository.watchWorkoutsForDay(_selectedDate);
    });
  }

  void _navigateToAddSchedule() {
    context.pushNamed(
      AppRoute.addWorkoutScheduleName,
      extra: AddScheduleArgs(date: _selectedDate),
    );
  }

  Future<void> _showWorkoutDialog(WorkoutOverview event) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final language = dialogContext.appLanguage;
        final scheduled = event.scheduledFor;
        final scheduleDescription = scheduled == null
            ? (language == AppLanguage.english
                ? 'Flexible schedule'
                : 'Jadwal fleksibel')
            : '${WorkoutLocalizations.relativeDay(language, scheduled)} | '
                '${WorkoutLocalizations.scheduleTime(language, scheduled)}';
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
                  event.title,
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
                      scheduleDescription,
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
      try {
        await _repository.completeWorkout(event.id);
        final message = _markDoneSnack
            .resolve(language)
            .replaceFirst('{name}', event.title);
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } catch (error, stackTrace) {
        debugPrint('Failed to complete workout: $error\n$stackTrace');
        if (!mounted) return;
        final message = language == AppLanguage.english
            ? 'Unable to mark workout as done.'
            : 'Tidak dapat menandai latihan selesai.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }
}

class _ScheduleGrid extends StatelessWidget {
  const _ScheduleGrid({
    required this.events,
    required this.language,
    required this.onTapWorkout,
  });

  final List<WorkoutOverview> events;
  final AppLanguage language;
  final ValueChanged<WorkoutOverview> onTapWorkout;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final slots = List<int>.generate(24, (index) => index);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: media.width * 1.5,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          separatorBuilder: (_, __) => Divider(
            color: TColor.gray.withValues(alpha: 0.2),
            height: 1,
          ),
          itemBuilder: (context, index) {
            final hour = slots[index];
            final slotEvents = events
                .where(
                  (event) =>
                      event.scheduledFor != null &&
                      event.scheduledFor!.hour == hour,
                )
                .toList(growable: false);
            return _ScheduleRow(
              hour: hour,
              slotEvents: slotEvents,
              language: language,
              onTapWorkout: onTapWorkout,
              availableWidth: (media.width * 1.2) - 120,
            );
          },
        ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.hour,
    required this.slotEvents,
    required this.language,
    required this.onTapWorkout,
    required this.availableWidth,
  });

  final int hour;
  final List<WorkoutOverview> slotEvents;
  final AppLanguage language;
  final ValueChanged<WorkoutOverview> onTapWorkout;
  final double availableWidth;

  @override
  Widget build(BuildContext context) {
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
                hour * 60,
                pattern: language == AppLanguage.english ? 'hh:mm a' : 'HH.mm',
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
                  final scheduled = event.scheduledFor!;
                  final alignment = Alignment(
                    (scheduled.minute / 60) * 2 - 1,
                    0,
                  );
                  final description =
                      WorkoutLocalizations.scheduleTime(language, scheduled);
                  return Align(
                    alignment: alignment,
                    child: InkWell(
                      onTap: () => onTapWorkout(event),
                      child: Container(
                        height: 35,
                        width: availableWidth * 0.5,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.secondaryG),
                          borderRadius: BorderRadius.circular(17.5),
                        ),
                        child: Text(
                          '${event.title}, $description',
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
  }
}
