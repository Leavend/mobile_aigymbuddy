// lib/view/sleep_tracker/sleep_add_alarm_view.dart

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/models/sleep_alarm_configuration.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/round_button.dart';

class SleepAddAlarmView extends StatefulWidget {
  const SleepAddAlarmView({super.key, required this.date});

  final DateTime date;

  @override
  State<SleepAddAlarmView> createState() => _SleepAddAlarmViewState();
}

class _SleepAddAlarmViewState extends State<SleepAddAlarmView> {
  static const _weekdayOrder = <int>[
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  static const _weekdayLabels = <int, String>{
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  bool _vibrateEnabled = false;
  late TimeOfDay _bedTime;
  Duration _sleepDuration = const Duration(hours: 8, minutes: 30);
  Set<int> _repeatWeekdays = {
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  };

  @override
  void initState() {
    super.initState();
    _bedTime = const TimeOfDay(hour: 21, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
          icon: Container(
            margin: const EdgeInsets.all(4),
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
        title: Text(
          "Add Alarm",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: Container(
              margin: const EdgeInsets.all(4),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formattedSelectedDate,
              style: TextStyle(
                color: TColor.gray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            IconTitleNextRow(
              icon: "assets/img/Bed_Add.png",
              title: "Bedtime",
              time: _formattedBedtime,
              color: TColor.lightGray,
              onPressed: _handleBedtimeTap,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/HoursTime.png",
              title: "Hours of sleep",
              time: _formattedSleepDuration,
              color: TColor.lightGray,
              onPressed: _handleSleepDurationTap,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/Repeat.png",
              title: "Repeat",
              time: _formattedRepeatSummary,
              color: TColor.lightGray,
              onPressed: _handleRepeatSelection,
            ),
            const SizedBox(height: 10),
            _buildVibrateTile(),
            const Spacer(),
            RoundButton(title: "Add", onPressed: _handleSubmit),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String get _formattedSelectedDate {
    return DateFormat('EEEE, d MMMM yyyy').format(widget.date);
  }

  String get _formattedBedtime {
    final dateTime = _bedtimeAsDateTime;
    return DateFormat('hh:mm a').format(dateTime);
  }

  String get _formattedSleepDuration {
    final hours = _sleepDuration.inHours;
    final minutes = _sleepDuration.inMinutes.remainder(60);

    final segments = <String>[];
    if (hours > 0) {
      segments.add('${hours}h');
    }
    if (minutes > 0 || segments.isEmpty) {
      segments.add('${minutes}m');
    }
    return segments.join(' ');
  }

  String get _formattedRepeatSummary {
    if (_repeatWeekdays.length == DateTime.daysPerWeek) {
      return 'Everyday';
    }

    const workWeek = {
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
    };

    if (_repeatWeekdays.containsAll(workWeek) &&
        _repeatWeekdays.length == workWeek.length) {
      return 'Mon – Fri';
    }

    if (_repeatWeekdays.isEmpty) {
      return 'Never';
    }

    final sorted = _repeatWeekdays.toList()..sort();
    return sorted.map((day) => _weekdayLabels[day]!).join(', ');
  }

  DateTime get _bedtimeAsDateTime {
    final date = widget.date;
    return DateTime(date.year, date.month, date.day, _bedTime.hour, _bedTime.minute);
  }

  Future<void> _handleBedtimeTap() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _bedTime,
      helpText: 'Select bedtime',
    );

    if (picked != null) {
      setState(() => _bedTime = picked);
    }
  }

  Future<void> _handleSleepDurationTap() async {
    final duration = await _showDurationPicker();
    if (duration != null && duration.inMinutes > 0) {
      setState(() => _sleepDuration = duration);
    }
  }

  Future<void> _handleRepeatSelection() async {
    final selection = await _showRepeatPicker();
    if (selection != null) {
      setState(() => _repeatWeekdays = selection);
    }
  }

  Future<Duration?> _showDurationPicker() {
    return showModalBottomSheet<Duration>(
      context: context,
      builder: (context) {
        Duration pendingDuration = _sleepDuration;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hours of sleep',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    minuteInterval: 5,
                    initialTimerDuration: _sleepDuration,
                    onTimerDurationChanged: (value) => pendingDuration = value,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(pendingDuration),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Set<int>?> _showRepeatPicker() {
    return showModalBottomSheet<Set<int>>(
      context: context,
      builder: (context) {
        final pendingSelection = _repeatWeekdays.toSet();
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Repeat',
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 320,
                      child: ListView(
                        children: [
                          for (final day in _weekdayOrder)
                            CheckboxListTile(
                              value: pendingSelection.contains(day),
                              title: Text(_weekdayLabels[day]!),
                              onChanged: (value) {
                                if (value == null) return;
                                setModalState(() {
                                  if (value) {
                                    pendingSelection.add(day);
                                  } else {
                                    pendingSelection.remove(day);
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pop(pendingSelection.toSet()),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleSubmit() {
    final config = SleepAlarmConfiguration(
      bedtime: _bedtimeAsDateTime,
      duration: _sleepDuration,
      repeatWeekdays: _repeatWeekdays,
      vibrate: _vibrateEnabled,
    );
    context.pop(config);
  }

  Widget _buildVibrateTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: Image.asset(
                "assets/img/Vibrate.png",
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Vibrate When Alarm Sound",
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 30,
            child: Transform.scale(
              scale: 0.7,
              child: CustomAnimatedToggleSwitch<bool>(
                current: _vibrateEnabled,
                values: const [false, true],
                spacing: 0.0,
                indicatorSize: const Size.square(30.0),
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.linear,
                onChanged: (val) => setState(() => _vibrateEnabled = val),
                iconBuilder: (context, local, global) => const SizedBox(),
                onTap: (val) =>
                    setState(() => _vibrateEnabled = !_vibrateEnabled),
                iconsTappable: false,
                wrapperBuilder: (context, global, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 10.0,
                        right: 10.0,
                        height: 30.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.secondaryG),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                      child,
                    ],
                  );
                },
                foregroundIndicatorBuilder: (context, global) {
                  return SizedBox.fromSize(
                    size: const Size(10, 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 0.05,
                            blurRadius: 1.1,
                            offset: Offset(0.0, 0.8),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
