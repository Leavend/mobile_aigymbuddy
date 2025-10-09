// dev_lib/calendar_agenda/lib/src/fullcalendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'typedata.dart';

/// Full screen calendar displayed from [CalendarAgenda].
class FullCalendar extends StatefulWidget {
  /// Creates a [FullCalendar] widget.
  const FullCalendar({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.padding,
    required this.onDateChange,
    this.calendarBackground,
    this.events = const <String>[],
    this.dateColor = Colors.white,
    this.dateSelectedColor = Colors.black,
    this.dateSelectedBg = Colors.blue,
    this.locale = 'en',
    this.selectedDate,
    this.fullCalendarDay = WeekDay.short,
    this.calendarScroll = FullCalendarScroll.vertical,
  }) : super(key: key);

  /// Start of the selectable date range.
  final DateTime startDate;

  /// End of the selectable date range.
  final DateTime endDate;

  /// Date currently selected.
  final DateTime? selectedDate;

  /// Default date text color.
  final Color dateColor;

  /// Text color when a date is selected.
  final Color dateSelectedColor;

  /// Background color for the selected date indicator.
  final Color dateSelectedBg;

  /// Horizontal padding inherited from the header.
  final double padding;

  /// Locale applied to all formatted strings.
  final String locale;

  /// Determines the weekday label length.
  final WeekDay fullCalendarDay;

  /// Scroll behaviour for the calendar.
  final FullCalendarScroll calendarScroll;

  /// Optional background widget displayed behind the calendar grid.
  final Widget? calendarBackground;

  /// Collection of event dates formatted as `yyyy-MM-dd`.
  final List<String> events;

  /// Callback triggered when the user selects a date.
  final ValueChanged<DateTime> onDateChange;

  @override
  FullCalendarState createState() => FullCalendarState();
}

class FullCalendarState extends State<FullCalendar> {
  late DateTime _startDate;
  late DateTime _endDate;
  late final Set<String> _eventDates;
  PageController? _horizontalController;

  @override
  void initState() {
    super.initState();
    _startDate = _normalizeDate(widget.startDate);
    _endDate = _normalizeDate(widget.endDate);
    _eventDates = widget.events.toSet();
  }

  @override
  void didUpdateWidget(covariant FullCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.startDate.isAtSameMomentAs(widget.startDate) ||
        !oldWidget.endDate.isAtSameMomentAs(widget.endDate)) {
      _startDate = _normalizeDate(widget.startDate);
      _endDate = _normalizeDate(widget.endDate);
    }

    if (oldWidget.events != widget.events) {
      _eventDates
        ..clear()
        ..addAll(widget.events);
    }

    if (oldWidget.calendarScroll != widget.calendarScroll) {
      _horizontalController?.dispose();
      _horizontalController = null;
    }
  }

  @override
  void dispose() {
    _horizontalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> allDates = _generateCalendarDates();
    final List<List<DateTime>> months = _groupDatesByMonth(allDates);
    final double width =
        MediaQuery.of(context).size.width - (2 * widget.padding);

    if (months.length == 1) {
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.padding, 40.0, widget.padding, 0.0),
        child: _buildMonth(months.first, width),
      );
    }

    final int initialIndex = _resolveInitialMonthIndex(months);

    if (widget.calendarScroll == FullCalendarScroll.horizontal) {
      _ensureHorizontalController(initialIndex);
      return Padding(
        padding: const EdgeInsets.fromLTRB(25, 10.0, 25, 20.0),
        child: Stack(
          children: [
            if (widget.calendarBackground != null)
              Opacity(
                opacity: 0.2,
                child: Center(child: widget.calendarBackground),
              ),
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _horizontalController,
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: months.length,
              itemBuilder: (BuildContext context, int index) {
                final bool isLast = index == 0;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0.0 : 10.0),
                  child: _buildMonth(months[index], width),
                );
              },
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.88,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _horizontalController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: () {
                      _horizontalController?.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10.0, 25, 20.0),
      child: Stack(
        children: [
          if (widget.calendarBackground != null)
            Opacity(
              opacity: 0.2,
              child: Center(child: widget.calendarBackground),
            ),
          ScrollablePositionedList.builder(
            initialScrollIndex: initialIndex,
            itemCount: months.length,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final bool isLast = index == 0;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0.0 : 25.0),
                child: _buildMonth(months[index], width),
              );
            },
          ),
        ],
      ),
    );
  }

  void _ensureHorizontalController(int initialIndex) {
    if (_horizontalController == null) {
      _horizontalController = PageController(initialPage: initialIndex);
      return;
    }

    if (_horizontalController!.hasClients) {
      final double? currentPage = _horizontalController!.page;
      if (currentPage != null && currentPage.round() != initialIndex) {
        _horizontalController!.jumpToPage(initialIndex);
      }
    }
  }

  int _resolveInitialMonthIndex(List<List<DateTime>> months) {
    final DateTime selected = widget.selectedDate != null
        ? _normalizeDate(widget.selectedDate!)
        : _startDate;

    final int index = months.indexWhere((List<DateTime> dates) =>
        dates.first.month == selected.month &&
        dates.first.year == selected.year);

    return index < 0 ? 0 : index;
  }

  List<DateTime> _generateCalendarDates() {
    final DateTime firstMonthDay = DateTime(_startDate.year, _startDate.month);
    final DateTime lastMonthDay =
        DateTime(_endDate.year, _endDate.month + 1).subtract(const Duration(days: 1));
    final int totalDays = lastMonthDay.difference(firstMonthDay).inDays + 1;

    return List<DateTime>.generate(
      totalDays,
      (int index) => _normalizeDate(firstMonthDay.add(Duration(days: index))),
    );
  }

  List<List<DateTime>> _groupDatesByMonth(List<DateTime> dates) {
    final Map<int, List<DateTime>> grouped = <int, List<DateTime>>{};
    for (final DateTime date in dates) {
      final int key = date.year * 100 + date.month;
      grouped.putIfAbsent(key, () => <DateTime>[]).add(date);
    }

    final List<List<DateTime>> months = grouped.values.toList()
      ..sort((List<DateTime> a, List<DateTime> b) =>
          b.first.compareTo(a.first));
    return months;
  }

  Widget _buildMonth(List<DateTime> monthDates, double width) {
    final DateTime monthStart = monthDates.first;
    final List<DateTime> displayDates = _padMonthDates(monthDates);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMM(Locale(widget.locale).toString()).format(monthStart),
          style: TextStyle(
            fontSize: 18.0,
            color: widget.dateColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 30.0),
        _buildDaysOfWeek(width),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: displayDates.length > 28
                ? (displayDates.length > 35 ? 6.2 * width / 7 : 5.2 * width / 7)
                : 4 * width / 7,
            width: MediaQuery.of(context).size.width - 2 * widget.padding,
            child: GridView.builder(
              itemCount: displayDates.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (BuildContext context, int index) {
                final DateTime date = displayDates[index];
                final bool isSameMonth = date.month == monthStart.month &&
                    date.year == monthStart.year;

                if (!isSameMonth) {
                  return const SizedBox.shrink();
                }

                final bool outOfRange =
                    date.isBefore(_startDate) || date.isAfter(_endDate);
                final bool hasEvent =
                    !outOfRange && _eventDates.contains(_formatDate(date));

                return _buildCalendarDate(
                  date,
                  outOfRange,
                  width,
                  hasEvent,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek(double width) {
    final List<String> dayNames = List<String>.generate(7, (int index) {
      final DateTime reference = DateTime(1970, 1, 12 + index);
      return widget.fullCalendarDay == WeekDay.long
          ? DateFormat.EEEE(widget.locale).format(reference)
          : DateFormat.E(widget.locale).format(reference);
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final String day in dayNames)
          SizedBox(
            width: width / 7,
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarDate(
    DateTime date,
    bool outOfRange,
    double width,
    bool hasEvent,
  ) {
    final bool isSelected = widget.selectedDate != null &&
        _isSameDay(widget.selectedDate!, date);

    final Color textColor = outOfRange
        ? (isSelected
            ? widget.dateSelectedColor.withOpacity(0.9)
            : widget.dateColor.withOpacity(0.4))
        : (isSelected ? widget.dateSelectedColor : widget.dateColor);

    return GestureDetector(
      onTap: outOfRange ? null : () => widget.onDateChange(date),
      child: Container(
        width: width / 7,
        height: width / 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? widget.dateSelectedBg : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                DateFormat('dd').format(date),
                style: TextStyle(color: textColor),
              ),
            ),
            if (hasEvent)
              Icon(
                Icons.bookmark,
                size: 8,
                color: isSelected
                    ? widget.dateSelectedColor
                    : widget.dateSelectedBg,
              )
            else
              const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  List<DateTime> _padMonthDates(List<DateTime> monthDates) {
    final List<DateTime> result = List<DateTime>.from(monthDates);
    final DateTime first = monthDates.first;
    final int leadingDays = (first.weekday - DateTime.monday) % 7;

    for (int i = leadingDays; i > 0; i--) {
      result.insert(0, _normalizeDate(first.subtract(Duration(days: i))));
    }

    while (result.length % 7 != 0) {
      result.add(_normalizeDate(result.last.add(const Duration(days: 1))));
    }

    return result;
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day, 12);

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
