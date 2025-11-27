import '../../../common/models/sleep_schedule_entry.dart';

/// Mock data used to render the schedule views in the demo.
///
/// The data intentionally lives in a single place to avoid duplicating the
/// sample configuration across multiple widgets.
final List<SleepScheduleEntry> mockTodaySleepSchedule = List.unmodifiable([
  SleepScheduleEntry(
    title: 'Bedtime',
    startTime: DateTime(2023, 6, 1, 21, 0),
    timeUntilStart: const Duration(hours: 6, minutes: 22),
    imageReference: 'assets/img/bed.png',
  ),
  SleepScheduleEntry(
    title: 'Alarm',
    startTime: DateTime(2023, 6, 2, 5, 10),
    timeUntilStart: const Duration(hours: 14, minutes: 30),
    imageReference: 'assets/img/alaarm.png',
  ),
]);
