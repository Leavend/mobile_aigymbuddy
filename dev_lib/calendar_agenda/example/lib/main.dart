// dev_lib/calendar_agenda/example/lib/main.dart

import 'dart:math';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Agenda Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // Pakai final untuk controller; nggak di-reassign
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  final CalendarAgendaController _calendarAgendaControllerNotAppBar =
      CalendarAgendaController();

  late DateTime _selectedDateAppBBar;
  late DateTime _selectedDateNotAppBBar;

  // Hilangkan 'new', gunakan final
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
    _selectedDateNotAppBBar = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png';

    return Scaffold(
      appBar: CalendarAgenda(
        controller: _calendarAgendaControllerAppBar,
        appbar: true,
        selectedDayPosition: SelectedDayPosition.right,
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          tooltip: 'Back',
        ),
        weekDay: WeekDay.long,
        fullCalendarScroll: FullCalendarScroll.horizontal,
        fullCalendarDay: WeekDay.long,
        selectedDateColor: Colors.green.shade900,
        dateColor: Colors.white,
        locale: 'en',
        initialDate: DateTime.now(),
        calendarEventColor: Colors.green,
        firstDate: DateTime.now().subtract(const Duration(days: 140)),
        lastDate: DateTime.now().add(const Duration(days: 60)),
        events: List.generate(
          100,
          (index) => DateTime.now()
              .subtract(Duration(days: index * random.nextInt(5))),
        ),
        onDateSelected: (date) {
          setState(() => _selectedDateAppBBar = date);
        },
        // Logo header kalender (widget)
        calendarLogo: Image.network(imageUrl, scale: 5.0),
        // Logo untuk hari terpilih (ImageProvider)
        selectedDayLogo: NetworkImage(imageUrl, scale: 15.0),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _calendarAgendaControllerAppBar.goToDay(DateTime.now());
              },
              child: const Text('Today, appbar = true'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Selected date is $_selectedDateAppBBar'),
            ),
            const SizedBox(height: 12),
            CalendarAgenda(
              controller: _calendarAgendaControllerNotAppBar,
              leading: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  'Agenda anda hari ini adalah sebagai berikut',
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // fullCalendar: false, // default sesuai lib
              locale: 'en',
              weekDay: WeekDay.long,
              fullCalendarDay: WeekDay.short,
              selectedDateColor: Colors.blue.shade900,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              lastDate: DateTime.now().add(const Duration(days: 4)),
              events: List.generate(
                100,
                (index) => DateTime.now()
                    .subtract(Duration(days: index * random.nextInt(5))),
              ),
              onDateSelected: (date) {
                setState(() => _selectedDateNotAppBBar = date);
              },
              calendarLogo: Image.network(imageUrl, scale: 5.0),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _calendarAgendaControllerNotAppBar.goToDay(DateTime.now());
              },
              child: const Text('Today, appbar = false (default value)'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Selected date is $_selectedDateNotAppBBar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
