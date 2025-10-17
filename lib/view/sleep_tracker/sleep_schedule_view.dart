import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../common/color_extension.dart';
import '../../common/models/sleep_schedule_entry.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_sleep_schedule_row.dart';
import 'data/mock_sleep_schedule.dart';

class SleepScheduleView extends StatefulWidget {
  const SleepScheduleView({super.key});

  @override
  State<SleepScheduleView> createState() => _SleepScheduleViewState();
}

class _SleepScheduleViewState extends State<SleepScheduleView> {
  final CalendarAgendaController _calendarController =
      CalendarAgendaController();

  static const double _tonightSleepRatio = 0.96;

  late DateTime _selectedDate;

  late final List<SleepScheduleEntry> _todaySchedule;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _todaySchedule = List.unmodifiable(mockTodaySleepSchedule);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;
    final localize = context.localize;

    return Scaffold(
      appBar: _buildAppBar(context, localize),
      backgroundColor: TColor.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: media.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: _buildIdealSleepCard(context, media, localize),
              ),
              SizedBox(height: media.width * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text(
                  localize(_SleepScheduleStrings.yourSchedule),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Calendar(
                controller: _calendarController,
                onDateSelected: (date) => setState(() => _selectedDate = date),
                language: language,
              ),
              SizedBox(height: media.width * 0.03),
              _ScheduleList(schedules: _todaySchedule),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: _SleepSummaryCard(
                  localize: localize,
                  media: media,
                  ratio: _tonightSleepRatio,
                  localeName: language.code,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(
            AppRoute.sleepAddAlarmName,
            extra: SleepAddAlarmArgs(date: _selectedDate),
          );
        },
        backgroundColor: TColor.secondaryColor2,
        foregroundColor: TColor.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    String Function(LocalizedText) localize,
  ) {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        padding: EdgeInsets.zero,
        icon: Container(
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
        localize(_SleepScheduleStrings.sleepScheduleTitle),
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
    );
  }

  Widget _buildIdealSleepCard(
    BuildContext context,
    Size media,
    String Function(LocalizedText) localize,
  ) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(20),
      height: media.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withValues(alpha: 0.4),
            TColor.primaryColor1.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                localize(_SleepScheduleStrings.idealHours),
                style: TextStyle(color: TColor.black, fontSize: 14),
              ),
              Text(
                localize(_SleepScheduleStrings.idealHoursValue),
                style: TextStyle(
                  color: TColor.primaryColor2,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 110,
                height: 35,
                child: RoundButton(
                  title: localize(_SleepScheduleStrings.learnMore),
                  fontSize: 12,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/img/sleep_schedule.png',
            width: media.width * 0.35,
          ),
        ],
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar({
    required this.controller,
    required this.onDateSelected,
    required this.language,
  });

  final CalendarAgendaController controller;
  final ValueChanged<DateTime> onDateSelected;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return CalendarAgenda(
      controller: controller,
      appbar: false,
      selectedDayPosition: SelectedDayPosition.center,
      weekDay: WeekDay.short,
      backgroundColor: Colors.transparent,
      fullCalendarScroll: FullCalendarScroll.horizontal,
      fullCalendarDay: WeekDay.short,
      selectedDateColor: Colors.white,
      dateColor: Colors.black,
      locale: language.code,
      initialDate: DateTime.now(),
      calendarEventColor: TColor.primaryColor2,
      firstDate: DateTime.now().subtract(const Duration(days: 140)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      onDateSelected: onDateSelected,
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.schedules});

  final List<SleepScheduleEntry> schedules;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: schedules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) =>
          TodaySleepScheduleRow(schedule: schedules[index]),
    );
  }
}

class _SleepSummaryCard extends StatelessWidget {
  const _SleepSummaryCard({
    required this.localize,
    required this.media,
    required this.ratio,
    required this.localeName,
  });

  final String Function(LocalizedText) localize;
  final Size media;
  final double ratio;
  final String localeName;

  @override
  Widget build(BuildContext context) {
    final percentFormat = NumberFormat.percentPattern(localeName);
    final safeRatio = ratio.clamp(0, 1);
    final percentageLabel = percentFormat.format(safeRatio);
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.secondaryColor2.withValues(alpha: 0.4),
            TColor.secondaryColor1.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localize(_SleepScheduleStrings.tonightSleepDuration),
            style: TextStyle(color: TColor.black, fontSize: 12),
          ),
          const SizedBox(height: 15),
          Stack(
            alignment: Alignment.center,
            children: [
              SimpleAnimationProgressBar(
                height: 15,
                width: media.width - 80,
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.purple,
                ratio: safeRatio.toDouble(),
                direction: Axis.horizontal,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 3),
                borderRadius: BorderRadius.circular(7.5),
                gradientColor: LinearGradient(
                  colors: TColor.secondaryG,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              Text(
                percentageLabel,
                style: TextStyle(color: TColor.black, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SleepScheduleStrings {
  static const sleepScheduleTitle = LocalizedText(
    english: 'Sleep Schedule',
    indonesian: 'Jadwal Tidur',
  );

  static const idealHours = LocalizedText(
    english: 'Ideal Hours for Sleep',
    indonesian: 'Durasi Tidur Ideal',
  );

  static const idealHoursValue = LocalizedText(
    english: '8 hours 30 minutes',
    indonesian: '8 jam 30 menit',
  );

  static const learnMore = LocalizedText(
    english: 'Learn More',
    indonesian: 'Pelajari Lebih Lanjut',
  );

  static const yourSchedule = LocalizedText(
    english: 'Your Schedule',
    indonesian: 'Jadwalmu',
  );

  static const tonightSleepDuration = LocalizedText(
    english: 'You will get 8 hours 10 minutes\nfor tonight',
    indonesian: 'Kamu akan mendapatkan 8 jam 10 menit\nmalam ini',
  );
}
