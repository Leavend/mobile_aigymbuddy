// dev_lib/calendar_agenda/lib/src/calendar.dart

import 'dart:convert';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'fullcalendar.dart';

class CalendarAgenda extends StatefulWidget implements PreferredSizeWidget {
  final CalendarAgendaController? controller;

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onDateSelected;

  final Color? backgroundColor;
  final SelectedDayPosition selectedDayPosition;
  final Color selectedDateColor;
  final Color dateColor;
  final Color headerDateColor;
  final Color? calendarBackground;
  final Color calendarEventSelectedColor;
  final Color calendarEventColor;
  final FullCalendarScroll fullCalendarScroll;
  final Widget? calendarLogo;
  final ImageProvider<Object>? selectedDayLogo;

  final String? locale;
  final bool? fullCalendar;
  final WeekDay fullCalendarDay;
  final double? padding;
  final Widget? leading;
  final WeekDay weekDay;
  final bool appbar;
  final double leftMargin;
  final List<DateTime>? events;

  CalendarAgenda({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.backgroundColor,
    this.selectedDayLogo,
    this.controller,
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
    this.events,
    this.fullCalendar = true,
    this.leftMargin = 0,
    this.fullCalendarScroll = FullCalendarScroll.vertical,
    this.fullCalendarDay = WeekDay.short,
    this.weekDay = WeekDay.short,
    this.selectedDayPosition = SelectedDayPosition.left,
  })  : assert(
          initialDate.difference(firstDate).inDays >= 0,
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

  @override
  CalendarAgendaState createState() => CalendarAgendaState();

  @override
  Size get preferredSize => const Size.fromHeight(250.0);
}

class CalendarAgendaState extends State<CalendarAgenda>
    with TickerProviderStateMixin {
  final ItemScrollController _scrollController = ItemScrollController();

  late Color backgroundColor;
  late double padding;
  late Widget leading;
  late double _scrollAlignment;

  final List<String> _eventDates = [];
  List<DateTime> _dates = [];
  DateTime? _selectedDate;
  int? _daySelectedIndex;

  String get _locale =>
      widget.locale ?? Localizations.localeOf(context).languageCode;

  // 1x1 image as base64 (dipakai untuk efek logo hari)
  static String uri =
      'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD...'; // (dipersingkat)

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(_locale);
    _initCalendar();
    padding = widget.padding ?? 25.0;
    leading = widget.leading ?? const SizedBox.shrink();
    _scrollAlignment = widget.leftMargin / 440;

    if (widget.events != null) {
      for (var element in widget.events!) {
        _eventDates.add(element.toString().split(' ').first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.backgroundColor ?? Theme.of(context).primaryColor;

    Widget dayList() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.appbar ? 125 : 100,
        padding: const EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: ScrollablePositionedList.builder(
          padding: _dates.length < 5
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      (5 - _dates.length) /
                      10,
                )
              : const EdgeInsets.symmetric(horizontal: 10),
          initialScrollIndex: _daySelectedIndex ?? 0,
          initialAlignment:
              widget.selectedDayPosition == SelectedDayPosition.center
                  ? 78 / 200
                  : _scrollAlignment,
          scrollDirection: Axis.horizontal,
          reverse: widget.selectedDayPosition == SelectedDayPosition.left
              ? false
              : true,
          itemScrollController: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: _dates.length,
          itemBuilder: (context, index) {
            final date = _dates[index];
            final isSelected = _daySelectedIndex == index;

            return Align(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: GestureDetector(
                  onTap: () => _goToActualDay(index),
                  child: Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width / 5 - 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: isSelected ? Colors.white : null,
                      boxShadow: [
                        isSelected
                            ? BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.2), // was withOpacity
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            : BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.0),
                                spreadRadius: 5,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                              ),
                      ],
                      image: isSelected
                          ? DecorationImage(
                              image: widget.selectedDayLogo ??
                                  MemoryImage(
                                    base64.decode(uri.split(',').last),
                                  ),
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.8),
                                BlendMode.dstOut,
                              ),
                            )
                          : DecorationImage(
                              image: MemoryImage(
                                base64.decode(uri.split(',').last),
                              ),
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.9),
                                BlendMode.clear,
                              ),
                            ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _eventDates.contains(date.toString().split(' ').first)
                            ? (isSelected
                                ? Icon(
                                    Icons.bookmark,
                                    size: 16,
                                    color: widget.selectedDateColor,
                                  )
                                : Icon(
                                    Icons.bookmark,
                                    size: 8,
                                    color:
                                        widget.dateColor.withValues(alpha: 0.5),
                                  ))
                            : const SizedBox(height: 5.0),
                        const SizedBox(height: 2.0),
                        Text(
                          DateFormat('dd').format(date),
                          style: TextStyle(
                            fontSize: 22.0,
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
                            fontSize: 12.0,
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

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: widget.appbar ? 210 : 150.0,
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 190.0,
              color: backgroundColor,
            ),
          ),
          Positioned(
            top: widget.appbar ? 50.0 : 20.0,
            child: Padding(
              padding: EdgeInsets.only(right: padding, left: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leading,
                    if (widget.fullCalendar ?? true)
                      GestureDetector(
                        onTap: () => _showFullCalendar(_locale, widget.weekDay),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18.0,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              DateFormat.yMMMM(Locale(_locale).toString())
                                  .format(_selectedDate!),
                              style: const TextStyle(
                                fontSize: 18.0,
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
            bottom: 0.0,
            child: dayList(),
          ),
        ],
      ),
    );
  }

  void _generateDates() {
    _dates.clear();

    final DateTime first = DateTime.parse(
      '${widget.firstDate.toString().split(' ').first} 00:00:00.000',
    );

    final DateTime last = DateTime.parse(
      '${widget.lastDate.toString().split(' ').first} 23:00:00.000',
    );

    final DateTime basicDate = DateTime.parse(
      '${first.toString().split(' ').first} 12:00:00.000',
    );

    final List<DateTime> listDates = List.generate(
      (last.difference(first).inHours / 24).round(),
      (index) => basicDate.add(Duration(days: index)),
    );

    if (widget.selectedDayPosition == SelectedDayPosition.left) {
      listDates.sort((b, a) => b.compareTo(a));
    } else {
      listDates.sort((b, a) => a.compareTo(b));
    }

    setState(() {
      _dates = listDates;
    });
  }

  void _showFullCalendar(String locale, WeekDay weekday) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        double height;
        final DateTime endDate = widget.lastDate;

        if (widget.firstDate.year == endDate.year &&
            widget.firstDate.month == endDate.month) {
          height = ((MediaQuery.of(context).size.width - 2 * padding) / 7) * 5 +
              150.0;
        } else {
          height = (MediaQuery.of(context).size.height - 100.0);
        }
        return SizedBox(
          height: widget.fullCalendarScroll == FullCalendarScroll.vertical
              ? height
              : (MediaQuery.of(context).size.height / 7) * 4.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: const Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: FullCalendar(
                  startDate: widget.firstDate,
                  endDate: endDate,
                  padding: padding,
                  dateColor: widget.dateColor,
                  dateSelectedBg: widget.calendarEventColor,
                  dateSelectedColor: widget.calendarEventSelectedColor,
                  events: _eventDates,
                  selectedDate: _selectedDate,
                  fullCalendarDay: widget.fullCalendarDay,
                  calendarScroll: widget.fullCalendarScroll,
                  calendarBackground: widget.calendarLogo,
                  locale: locale,
                  onDateChange: (value) {
                    getDate(value);
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

  void _selectedDay() {
    final DateTime getSelected = DateTime.parse(
      '${_selectedDate.toString().split(' ').first} 00:00:00.000',
    );

    _daySelectedIndex = _dates.indexOf(
      _dates.firstWhere(
        (dayDate) =>
            DateTime.parse(
              '${dayDate.toString().split(' ').first} 00:00:00.000',
            ) ==
            getSelected,
      ),
    );
  }

  void _goToActualDay(int index) {
    _moveToDayIndex(index);
    setState(() {
      _daySelectedIndex = index;
      _selectedDate = _dates[index];
    });
    widget.onDateSelected(_selectedDate);
  }

  void _moveToDayIndex(int index) {
    _scrollController.scrollTo(
      index: index,
      alignment: widget.selectedDayPosition == SelectedDayPosition.center
          ? 78 / 200
          : _scrollAlignment,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void getDate(DateTime value) {
    setState(() {
      _selectedDate = value;
    });
    _selectedDay();
    _goToActualDay(_daySelectedIndex!);
  }

  void _initCalendar() {
    if (widget.controller != null &&
        widget.controller is CalendarAgendaController) {
      widget.controller!.bindState(this);
    }
    _selectedDate = widget.initialDate;
    _generateDates();
    _selectedDay();
  }
}
