// dev_lib/calendar_agenda/lib/src/calendar.dart

import 'dart:convert';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:calendar_agenda/src/fullcalendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Calendar header widget that exposes a compact horizontal date selector and
/// an optional full-screen calendar modal.
class CalendarAgenda extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a [CalendarAgenda] widget.
  // FIX: Removed 'const' to allow runtime checks in asserts.
  CalendarAgenda({
    required this.initialDate, required this.firstDate, required this.lastDate, required this.onDateSelected, Key? key,
    this.controller,
    this.backgroundColor,
    this.selectedDayLogo,
    this.selectedDateColor = Colors.black,
    this.dateColor = Colors.white,
    this.headerDateColor = Colors.white,
    this.calendarBackground = Colors.white,
    this.calendarEventSelectedColor = Colors.white,
    this.calendarEventColor = Colors.blue,
    this.calendarLogo,
    this.locale = 'en',
    this.padding,
    this.leading,
    this.appbar = false,
    this.events = const <DateTime>[],
    this.fullCalendar = true,
    this.leftMargin = 0,
    this.fullCalendarScroll = FullCalendarScroll.vertical,
    this.fullCalendarDay = WeekDay.short,
    this.weekDay = WeekDay.short,
    this.selectedDayPosition = SelectedDayPosition.left,
  })  : assert(
          !initialDate.isBefore(firstDate),
          'initialDate must be on or after firstDate',
        ),
        assert(
          !initialDate.isAfter(lastDate),
          'initialDate must be on or before lastDate',
        ),
        assert(
          !firstDate.isAfter(lastDate),
          'lastDate must be on or after firstDate',
        ),
        super(key: key);

  /// Controller used to interact with the calendar programmatically.
  final CalendarAgendaController? controller;

  /// Currently selected date when the widget is first displayed.
  final DateTime initialDate;

  /// Minimum selectable date.
  final DateTime firstDate;

  /// Maximum selectable date.
  final DateTime lastDate;

  /// Callback fired whenever the selected date changes.
  final ValueChanged<DateTime> onDateSelected;

  /// Optional background color behind the calendar header.
  final Color? backgroundColor;

  /// Determines where the selected day should be aligned when scrolling.
  final SelectedDayPosition selectedDayPosition;

  /// Text color for the selected date.
  final Color selectedDateColor;

  /// Default text color for dates.
  final Color dateColor;

  /// Color of the header texts.
  final Color headerDateColor;

  /// Background color for the full calendar modal.
  final Color? calendarBackground;

  /// Text color used when a date is selected inside the modal view.
  final Color calendarEventSelectedColor;

  /// Background color for selected dates inside the modal.
  final Color calendarEventColor;

  /// Scroll behaviour for the full calendar modal.
  final FullCalendarScroll fullCalendarScroll;

  /// Optional logo displayed inside the full calendar background.
  final Widget? calendarLogo;

  /// Optional logo displayed behind the selected day in the horizontal list.
  final ImageProvider<Object>? selectedDayLogo;

  /// Locale used for date formatting.
  final String? locale;

  /// Determines whether the full calendar modal is available.
  final bool? fullCalendar;

  /// Weekday label style for the full calendar modal.
  final WeekDay fullCalendarDay;

  /// Horizontal padding for the calendar header.
  final double? padding;

  /// Optional leading widget displayed on the left side of the header.
  final Widget? leading;

  /// Weekday label style for the horizontal list.
  final WeekDay weekDay;

  /// Whether the widget is rendered inside an AppBar-like container.
  final bool appbar;

  /// Margin used to align the selected day inside the list.
  final double leftMargin;

  /// Collection of event dates displayed with a marker.
  final List<DateTime> events;

  @override
  CalendarAgendaState createState() => CalendarAgendaState();

  @override
  Size get preferredSize => const Size.fromHeight(250);
}

class CalendarAgendaState extends State<CalendarAgenda>
    with TickerProviderStateMixin {
  static const String _transparentImageBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAACnej3aAAAAAXRSTlMAQObYZgAAAApJREFUCNdjYAAAAAIAAeIhvDMAAAAASUVORK5CYII=';

  final ItemScrollController _scrollController = ItemScrollController();

  late final Set<String> _eventDates;
  late final double _scrollAlignment;
  late final double _padding;
  late final Widget _leading;
  late final ImageProvider<Object> _defaultSelectedDayLogo;

  List<DateTime> _dates = <DateTime>[];
  DateTime? _selectedDate;
  int? _daySelectedIndex;

  String get _locale =>
      widget.locale ?? Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(_locale);
    _padding = widget.padding ?? 25.0;
    _leading = widget.leading ?? const SizedBox.shrink();
    _scrollAlignment = (widget.leftMargin / 440).clamp(0.0, 1.0);
    _defaultSelectedDayLogo =
        MemoryImage(base64.decode(_transparentImageBase64));

    _eventDates = <String>{
      for (final event in widget.events) _formatDate(event),
    };

    _initCalendar();
  }

  @override
  void didUpdateWidget(covariant CalendarAgenda oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.events != widget.events) {
      setState(() {
        _eventDates
          ..clear()
          ..addAll(widget.events.map(_formatDate));
      });
    }

    if (!oldWidget.initialDate.isAtSameMomentAs(widget.initialDate)) {
      _updateSelectedDate(widget.initialDate, animate: false);
    }

    if (!oldWidget.firstDate.isAtSameMomentAs(widget.firstDate) ||
        !oldWidget.lastDate.isAtSameMomentAs(widget.lastDate) ||
        oldWidget.selectedDayPosition != widget.selectedDayPosition) {
      _generateDates();
      if (_selectedDate != null) {
        _updateSelectedDate(
          _selectedDate!,
          animate: false,
          notify: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final Color backgroundColor =
        widget.backgroundColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: width,
      height: widget.appbar ? 210 : 150.0,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: width,
              height: 190,
              color: backgroundColor,
            ),
          ),
          Positioned(
            top: widget.appbar ? 50.0 : 20.0,
            child: Padding(
              padding: EdgeInsets.only(right: _padding, left: 10),
              child: SizedBox(
                width: width - _padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _leading,
                    if (widget.fullCalendar ?? true)
                      GestureDetector(
                        onTap: _showFullCalendar,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            if (_selectedDate != null)
                              Text(
                                DateFormat.yMMMM(Locale(_locale).toString())
                                    .format(_selectedDate!),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.end,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: _buildDayList(width),
          ),
        ],
      ),
    );
  }

  Widget _buildDayList(double width) {
    final double itemWidth = (width / 5) - 10;

    return Container(
      width: width,
      height: widget.appbar ? 125 : 100,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.bottomCenter,
      child: ScrollablePositionedList.builder(
        padding: _dates.length < 5
            ? EdgeInsets.symmetric(
                horizontal: width * (5 - _dates.length.clamp(0, 5)) / 10,
              )
            : const EdgeInsets.symmetric(horizontal: 10),
        initialScrollIndex: _daySelectedIndex ?? 0,
        initialAlignment:
            widget.selectedDayPosition == SelectedDayPosition.center
                ? 78 / 200
                : _scrollAlignment,
        scrollDirection: Axis.horizontal,
        reverse: widget.selectedDayPosition != SelectedDayPosition.left,
        itemScrollController: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final DateTime date = _dates[index];
          final bool isSelected = _daySelectedIndex == index;
          final DecorationImage backgroundImage =
              _resolveSelectedDayImage(isSelected);

          return Align(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: GestureDetector(
                onTap: () => _updateSelectedDate(date),
                child: Container(
                  height: 100,
                  width: itemWidth.clamp(0.0, double.infinity),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? Colors.white : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(
                          (255 * (isSelected ? 0.2 : 0.0)).round(),
                        ),
                        spreadRadius: isSelected ? 1 : 5,
                        blurRadius: isSelected ? 10 : 20,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: backgroundImage,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_eventDates.contains(_formatDate(date)))
                        Icon(
                          Icons.bookmark,
                          size: isSelected ? 16 : 8,
                          color: isSelected
                              ? widget.selectedDateColor
                              : widget.dateColor.withValues(alpha: 0.5),
                        )
                      else
                        const SizedBox(height: 5),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          fontSize: 22,
                          color: isSelected
                              ? widget.selectedDateColor
                              : widget.headerDateColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.weekDay == WeekDay.long
                            ? DateFormat.EEEE(Locale(_locale).toString())
                                .format(date)
                            : DateFormat.E(Locale(_locale).toString())
                                .format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? widget.selectedDateColor
                              : widget.headerDateColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DecorationImage _resolveSelectedDayImage(bool isSelected) {
    final ImageProvider<Object> imageProvider =
        widget.selectedDayLogo ?? _defaultSelectedDayLogo;

    return DecorationImage(
      image: imageProvider,
      colorFilter: ColorFilter.mode(
        Colors.black.withAlpha((255 * (isSelected ? 0.8 : 0.9)).round()),
        isSelected ? BlendMode.dstOut : BlendMode.clear,
      ),
    );
  }

  void _generateDates() {
    final DateTime first = _normalizeDate(widget.firstDate);
    final DateTime last = _normalizeDate(widget.lastDate);
    final int dayCount = last.difference(first).inDays + 1;

    final List<DateTime> listDates = List<DateTime>.generate(
      dayCount,
      (int index) => first.add(Duration(days: index)),
    );

    if (widget.selectedDayPosition == SelectedDayPosition.left) {
      _dates = listDates;
    } else {
      _dates = listDates.reversed.toList();
    }
  }

  void _showFullCalendar() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        final DateTime endDate = widget.lastDate;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;

        final double height = widget.firstDate.year == endDate.year &&
                widget.firstDate.month == endDate.month
            ? ((screenWidth - 2 * _padding) / 7) * 5 + 150.0
            : screenHeight - 100.0;

        return SizedBox(
          height: widget.fullCalendarScroll == FullCalendarScroll.vertical
              ? height
              : (screenHeight / 7) * 4.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FullCalendar(
                  startDate: widget.firstDate,
                  endDate: endDate,
                  padding: _padding,
                  dateColor: widget.dateColor,
                  dateSelectedBg: widget.calendarEventColor,
                  dateSelectedColor: widget.calendarEventSelectedColor,
                  events: _eventDates.toList(),
                  selectedDate: _selectedDate,
                  fullCalendarDay: widget.fullCalendarDay,
                  calendarScroll: widget.fullCalendarScroll,
                  calendarBackground: widget.calendarLogo,
                  locale: _locale,
                  onDateChange: (DateTime value) {
                    _updateSelectedDate(value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateSelectedDate(
    DateTime value, {
    bool animate = true,
    bool notify = true,
  }) {
    final DateTime normalized = _normalizeDate(value);
    final int index =
        _dates.indexWhere((DateTime date) => _isSameDay(date, normalized));
    if (index == -1) {
      return;
    }

    setState(() {
      _selectedDate = _dates[index];
      _daySelectedIndex = index;
    });

    if (notify) {
      widget.onDateSelected(_selectedDate!);
    }

    if (animate) {
      _moveToDayIndex(index);
    }
  }

  void _moveToDayIndex(int index) {
    if (!_scrollController.isAttached) {
      return;
    }

    _scrollController.scrollTo(
      index: index,
      alignment: widget.selectedDayPosition == SelectedDayPosition.center
          ? 78 / 200
          : _scrollAlignment,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _initCalendar() {
    widget.controller?.bindState(this);
    _selectedDate = _normalizeDate(widget.initialDate);
    _generateDates();
    _updateSelectedDate(_selectedDate!, animate: false, notify: false);
  }

  /// Method exposed to the controller to allow external date changes.
  void selectDate(
    DateTime date, {
    bool animate = true,
    bool notifyListeners = true,
  }) {
    _updateSelectedDate(date, animate: animate, notify: notifyListeners);
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day, 12);

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
