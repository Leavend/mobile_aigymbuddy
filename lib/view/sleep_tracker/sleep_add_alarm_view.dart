// lib/view/sleep_tracker/sleep_add_alarm_view.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/sleep_alarm_configuration.dart';
import 'package:aigymbuddy/common_widget/icon_title_next_row.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SleepAddAlarmView extends StatefulWidget {
  const SleepAddAlarmView({required this.date, super.key});

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

  static const Map<int, LocalizedText> _weekdayLabels = {
    DateTime.monday: LocalizedText(english: 'Mon', indonesian: 'Sen'),
    DateTime.tuesday: LocalizedText(english: 'Tue', indonesian: 'Sel'),
    DateTime.wednesday: LocalizedText(english: 'Wed', indonesian: 'Rab'),
    DateTime.thursday: LocalizedText(english: 'Thu', indonesian: 'Kam'),
    DateTime.friday: LocalizedText(english: 'Fri', indonesian: 'Jum'),
    DateTime.saturday: LocalizedText(english: 'Sat', indonesian: 'Sab'),
    DateTime.sunday: LocalizedText(english: 'Sun', indonesian: 'Min'),
  };

  static const Set<int> _workWeek = {
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  };

  bool _vibrateEnabled = false;
  late TimeOfDay _bedTime;
  Duration _sleepDuration = const Duration(hours: 8, minutes: 30);
  Set<int> _repeatWeekdays = {..._workWeek};

  @override
  void initState() {
    super.initState();
    _bedTime = const TimeOfDay(hour: 21, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final language = context.appLanguage;
    final localize = context.localize;

    final selectedDateLabel = _formatSelectedDate(language);
    final bedtimeLabel = _formatBedtime(language);
    final sleepDurationLabel = _formatSleepDuration(language);
    final repeatSummary = _formatRepeatSummary(language);

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
              'assets/img/closed_btn.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          localize(_SleepAddAlarmStrings.addAlarmTitle),
          style: const TextStyle(
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
                'assets/img/more_btn.png',
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
              selectedDateLabel,
              style: const TextStyle(
                color: TColor.gray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            IconTitleNextRow(
              icon: 'assets/img/Bed_Add.png',
              title: localize(_SleepAddAlarmStrings.bedtime),
              time: bedtimeLabel,
              color: TColor.lightGray,
              onPressed: _handleBedtimeTap,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: 'assets/img/HoursTime.png',
              title: localize(_SleepAddAlarmStrings.hoursOfSleep),
              time: sleepDurationLabel,
              color: TColor.lightGray,
              onPressed: _handleSleepDurationTap,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: 'assets/img/Repeat.png',
              title: localize(_SleepAddAlarmStrings.repeat),
              time: repeatSummary,
              color: TColor.lightGray,
              onPressed: _handleRepeatSelection,
            ),
            const SizedBox(height: 10),
            _buildVibrateTile(localize(_SleepAddAlarmStrings.vibrateLabel)),
            const Spacer(),
            RoundButton(
              title: localize(_SleepAddAlarmStrings.addAction),
              onPressed: _handleSubmit,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatSelectedDate(AppLanguage language) {
    return DateFormat('EEEE, d MMMM yyyy', language.code).format(widget.date);
  }

  String _formatBedtime(AppLanguage language) {
    final dateTime = _bedtimeAsDateTime;
    return DateFormat('hh:mm a', language.code).format(dateTime);
  }

  String _formatSleepDuration(AppLanguage language) {
    final hours = _sleepDuration.inHours;
    final minutes = _sleepDuration.inMinutes.remainder(60);

    final segments = <String>[];
    if (hours > 0) {
      final singular = language == AppLanguage.english ? 'hour' : 'jam';
      final plural = language == AppLanguage.english ? 'hours' : 'jam';
      final label = hours == 1 ? singular : plural;
      segments.add('$hours $label');
    }
    if (minutes > 0 || segments.isEmpty) {
      final singular = language == AppLanguage.english ? 'minute' : 'menit';
      final plural = language == AppLanguage.english ? 'minutes' : 'menit';
      final label = minutes == 1 ? singular : plural;
      segments.add('$minutes $label');
    }

    return segments.join(' ');
  }

  String _formatRepeatSummary(AppLanguage language) {
    if (_repeatWeekdays.length == DateTime.daysPerWeek) {
      return _SleepAddAlarmStrings.everyday.resolve(language);
    }

    if (_repeatWeekdays.containsAll(_workWeek) &&
        _repeatWeekdays.length == _workWeek.length) {
      return _SleepAddAlarmStrings.workWeek.resolve(language);
    }

    if (_repeatWeekdays.isEmpty) {
      return _SleepAddAlarmStrings.never.resolve(language);
    }

    final sorted = _repeatWeekdays.toList()..sort();
    return sorted
        .map((day) => _weekdayLabels[day]!.resolve(language))
        .join(', ');
  }

  DateTime get _bedtimeAsDateTime {
    final date = widget.date;
    return DateTime(
      date.year,
      date.month,
      date.day,
      _bedTime.hour,
      _bedTime.minute,
    );
  }

  Future<void> _handleBedtimeTap() async {
    final language = context.appLanguage;
    final helpText = context.localize(_SleepAddAlarmStrings.selectBedtime);
    final picked = await showTimePicker(
      context: context,
      initialTime: _bedTime,
      helpText: helpText,
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: language.locale,
          child: child,
        );
      },
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
    final language = context.appLanguage;
    final localize = context.localize;
    return showModalBottomSheet<Duration>(
      context: context,
      builder: (sheetContext) {
        Duration pendingDuration = _sleepDuration;
        return Localizations.override(
          context: sheetContext,
          locale: language.locale,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localize(_SleepAddAlarmStrings.hoursOfSleep),
                    style: const TextStyle(
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
                      onTimerDurationChanged: (value) =>
                          pendingDuration = value,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: Text(localize(_SleepAddAlarmStrings.cancel)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(sheetContext).pop(pendingDuration),
                        child: Text(localize(_SleepAddAlarmStrings.save)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Set<int>?> _showRepeatPicker() {
    final language = context.appLanguage;
    final localize = context.localize;
    return showModalBottomSheet<Set<int>>(
      context: context,
      builder: (sheetContext) {
        final pendingSelection = _repeatWeekdays.toSet();
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Localizations.override(
              context: sheetContext,
              locale: language.locale,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localize(_SleepAddAlarmStrings.repeat),
                        style: const TextStyle(
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
                                title: Text(
                                  _weekdayLabels[day]!.resolve(language),
                                ),
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
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            child: Text(localize(_SleepAddAlarmStrings.cancel)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => Navigator.of(
                              sheetContext,
                            ).pop(pendingSelection.toSet()),
                            child: Text(localize(_SleepAddAlarmStrings.save)),
                          ),
                        ],
                      ),
                    ],
                  ),
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

  Widget _buildVibrateTile(String label) {
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
                'assets/img/Vibrate.png',
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 30,
            child: Transform.scale(
              scale: 0.7,
              child: CustomAnimatedToggleSwitch<bool>(
                current: _vibrateEnabled,
                values: const [false, true],
                indicatorSize: const Size.square(30),
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
                      const Positioned(
                        left: 10,
                        right: 10,
                        height: 30,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.secondaryG),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
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
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 0.05,
                            blurRadius: 1.1,
                            offset: Offset(0, 0.8),
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

class _SleepAddAlarmStrings {
  static const addAlarmTitle = LocalizedText(
    english: 'Add Alarm',
    indonesian: 'Tambah Alarm',
  );

  static const bedtime = LocalizedText(
    english: 'Bedtime',
    indonesian: 'Waktu Tidur',
  );

  static const hoursOfSleep = LocalizedText(
    english: 'Hours of sleep',
    indonesian: 'Durasi tidur',
  );

  static const repeat = LocalizedText(english: 'Repeat', indonesian: 'Ulangi');

  static const selectBedtime = LocalizedText(
    english: 'Select bedtime',
    indonesian: 'Pilih waktu tidur',
  );

  static const everyday = LocalizedText(
    english: 'Everyday',
    indonesian: 'Setiap hari',
  );

  static const workWeek = LocalizedText(
    english: 'Mon – Fri',
    indonesian: 'Sen – Jum',
  );

  static const never = LocalizedText(
    english: 'Never',
    indonesian: 'Tidak pernah',
  );

  static const cancel = LocalizedText(english: 'Cancel', indonesian: 'Batal');

  static const save = LocalizedText(english: 'Save', indonesian: 'Simpan');

  static const vibrateLabel = LocalizedText(
    english: 'Vibrate When Alarm Sound',
    indonesian: 'Getar Saat Alarm Berbunyi',
  );

  static const addAction = LocalizedText(english: 'Add', indonesian: 'Tambah');
}
