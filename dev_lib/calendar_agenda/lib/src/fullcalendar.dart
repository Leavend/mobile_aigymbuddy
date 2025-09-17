// dev_lib/calendar_agenda/lib/src/fullcalendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'typedata.dart';

class FullCalendar extends StatefulWidget {
  /// Rentang tanggal yang akan ditampilkan
  final DateTime startDate;
  final DateTime endDate;

  /// Tanggal yang sedang dipilih
  final DateTime? selectedDate;

  /// Warna-warna tampilan (punya default agar aman)
  final Color dateColor;
  final Color dateSelectedColor;
  final Color dateSelectedBg;

  /// Padding horizontal keseluruhan kalender (wajib dari parent agar konsisten)
  final double padding;

  /// Locale & opsi tampilan
  final String locale;
  final WeekDay fullCalendarDay;
  final FullCalendarScroll calendarScroll;

  /// Opsional latar belakang (mis. logo) & event markers (format: 'yyyy-MM-dd')
  final Widget? calendarBackground;
  final List<String> events;

  /// Callback ketika user memilih tanggal
  final ValueChanged<DateTime> onDateChange;

  const FullCalendar({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.padding,
    required this.onDateChange,
    this.calendarBackground,
    this.events = const [],
    this.dateColor = Colors.white,
    this.dateSelectedColor = Colors.black,
    this.dateSelectedBg = Colors.blue,
    this.locale = 'en',
    this.selectedDate,
    this.fullCalendarDay = WeekDay.short,
    this.calendarScroll = FullCalendarScroll.vertical,
  }) : super(key: key);

  @override
  FullCalendarState createState() => FullCalendarState();
}

class FullCalendarState extends State<FullCalendar> {
  late DateTime startDate;
  late DateTime endDate;
  late int _initialPage;
  late PageController _horizontalScroll;

  // Disimpan sebagai list biasa (non-null) agar aman dipakai
  late final List<String> _events;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse(
      '${widget.startDate.toString().split(" ").first} 00:00:00.000',
    );

    endDate = DateTime.parse(
      '${widget.endDate.toString().split(" ").first} 23:00:00.000',
    );

    _events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    final partsStart = startDate.toString().split(' ').first.split('-');
    final firstDate = DateTime.parse(
      '${partsStart.first}-${partsStart[1].padLeft(2, '0')}-01 00:00:00.000',
    );

    final partsEnd = endDate.toString().split(' ').first.split('-');
    final lastDate = DateTime.parse(
      '${partsEnd.first}-${(int.parse(partsEnd[1]) + 1).toString().padLeft(2, '0')}-01 23:00:00.000',
    ).subtract(const Duration(days: 1));

    final width = MediaQuery.of(context).size.width - (2 * widget.padding);

    // Konstruksi daftar tanggal (tiap hari jam 12 siang untuk stabilitas)
    final List<DateTime> dates = [];
    var referenceDate = firstDate;
    while (referenceDate.isBefore(lastDate)) {
      final referenceParts = referenceDate.toString().split(' ');
      final newDate =
          DateTime.parse('${referenceParts.first} 12:00:00.000');
      dates.add(newDate);
      referenceDate = newDate.add(const Duration(days: 1));
    }

    // Jika hanya satu bulan
    if (firstDate.year == lastDate.year && firstDate.month == lastDate.month) {
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.padding, 40.0, widget.padding, 0.0),
        child: month(dates, width, widget.locale, widget.fullCalendarDay),
      );
    }

    // Multi-bulan → buat indeks awal sesuai selectedDate
    final List<DateTime> months = [];
    for (int i = 0; i < dates.length; i++) {
      if (i == 0 || (dates[i].month != dates[i - 1].month)) {
        months.add(dates[i]);
      }
    }
    months.sort((b, a) => a.compareTo(b));

    final initialIndex = months.indexWhere((element) =>
        element.month == (widget.selectedDate ?? startDate).month &&
        element.year == (widget.selectedDate ?? startDate).year);

    _initialPage = initialIndex < 0 ? 0 : initialIndex;
    _horizontalScroll = PageController(initialPage: _initialPage);

    // Horizontal vs Vertical mode
    if (widget.calendarScroll == FullCalendarScroll.horizontal) {
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
              controller: _horizontalScroll,
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: months.length,
              itemBuilder: (context, index) {
                final date = months[index];
                final List<DateTime> daysOfMonth = [
                  for (final item in dates)
                    if (date.month == item.month && date.year == item.year) item
                ];

                final isLast = index == 0;
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: isLast ? 0.0 : 10.0),
                  child: month(
                      daysOfMonth, width, widget.locale, widget.fullCalendarDay),
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
                      _horizontalScroll.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: () {
                      _horizontalScroll.previousPage(
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
    } else {
      // Vertical
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
              initialScrollIndex: _initialPage,
              itemCount: months.length,
              reverse: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final date = months[index];
                final List<DateTime> daysOfMonth = [
                  for (final item in dates)
                    if (date.month == item.month && date.year == item.year) item
                ];
                final isLast = index == 0;

                return Padding(
                  padding:
                      EdgeInsets.only(bottom: isLast ? 0.0 : 25.0),
                  child: month(
                      daysOfMonth, width, widget.locale, widget.fullCalendarDay),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  Widget daysOfWeek(double width, String locale, WeekDay weekday) {
    final List<String> daysNames = [];
    for (var day = 12; day <= 18; day++) {
      if (weekday == WeekDay.long) {
        daysNames.add(DateFormat.EEEE(locale)
            .format(DateTime.parse('1970-01-$day')));
      } else {
        daysNames.add(DateFormat.E(locale)
            .format(DateTime.parse('1970-01-$day')));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < 7; i++) dayName(width / 7, daysNames[i]),
      ],
    );
  }

  Widget dayName(double width, String text) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget dateInCalendar(
    DateTime date,
    bool outOfRange,
    double width,
    bool event,
  ) {
    final isSelectedDate =
        date.toString().split(' ').first ==
        (widget.selectedDate ?? startDate).toString().split(' ').first;

    final Color baseDateColor = outOfRange
        ? (isSelectedDate
            ? widget.dateSelectedColor.withValues(alpha: 0.9)
            : widget.dateColor.withValues(alpha: 0.4))
        : (isSelectedDate ? widget.dateSelectedColor : widget.dateColor);

    return GestureDetector(
      onTap: () => outOfRange ? null : widget.onDateChange(date),
      child: Container(
        width: width / 7,
        height: width / 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelectedDate ? widget.dateSelectedBg : Colors.transparent,
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
                style: TextStyle(color: baseDateColor),
              ),
            ),
            if (event)
              Icon(
                Icons.bookmark,
                size: 8,
                color:
                    isSelectedDate ? widget.dateSelectedColor : widget.dateSelectedBg,
              )
            else
              const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  Widget month(
    List<DateTime> dates,
    double width,
    String locale,
    WeekDay weekday,
  ) {
    // Pegang tanggal pertama untuk judul bulan
    final DateTime first = dates.first;

    // Isi tanggal di depan sampai Senin
    while (DateFormat('E').format(dates.first) != 'Mon') {
      dates.add(dates.first.subtract(const Duration(days: 1)));
      dates.sort();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMM(Locale(locale).toString()).format(first),
          style: TextStyle(
            fontSize: 18.0,
            color: widget.dateColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 30.0),
        daysOfWeek(width, widget.locale, widget.fullCalendarDay),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: dates.length > 28
                ? (dates.length > 35 ? 6.2 * width / 7 : 5.2 * width / 7)
                : 4 * width / 7,
            width: MediaQuery.of(context).size.width - 2 * widget.padding,
            child: GridView.builder(
              itemCount: dates.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                final date = dates[index];
                final outOfRange =
                    date.isBefore(startDate) || date.isAfter(endDate);

                if (date.isBefore(first)) {
                  return const SizedBox.shrink();
                }

                final hasEvent = _events.contains(
                      date.toString().split(' ').first,
                    ) &&
                    !outOfRange;

                return dateInCalendar(
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
}
