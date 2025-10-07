import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/date_time_utils.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/round_button.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key, required this.date});

  final DateTime date;

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  late DateTime _selectedDateTime;
  String _selectedWorkout = 'Upperbody Workout';
  String _selectedDifficulty = 'Beginner';
  int? _customRepetitions;
  double? _customWeight;

  static const List<String> _workoutOptions = <String>[
    'Upperbody Workout',
    'Fullbody Workout',
    'Lowerbody Workout',
    'Core Burner',
  ];

  static const List<String> _difficultyOptions = <String>[
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      widget.date.hour,
      widget.date.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            context.pop();
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
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Add Schedule",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/img/date.png", width: 20, height: 20),
                const SizedBox(width: 8),
                Text(
                  DateTimeUtils.formatDate(
                    widget.date,
                    pattern: "E, dd MMMM yyyy",
                  ),
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Time",
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                initialDateTime: DateTime(
                  widget.date.year,
                  widget.date.month,
                  widget.date.day,
                  _selectedDateTime.hour,
                  _selectedDateTime.minute,
                ),
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: _handleTimeChanged,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Details Workout",
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            IconTitleNextRow(
              icon: "assets/img/choose_workout.png",
              title: "Choose Workout",
              time: _selectedWorkout,
              color: TColor.lightGray,
              onPressed: _pickWorkout,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/difficulity.png",
              title: "Difficulity",
              time: _selectedDifficulty,
              color: TColor.lightGray,
              onPressed: _pickDifficulty,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/repetitions.png",
              title: "Custom Repetitions",
              time: _customRepetitions == null
                  ? 'Not set'
                  : '${_customRepetitions!} reps',
              color: TColor.lightGray,
              onPressed: _pickRepetitions,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/repetitions.png",
              title: "Custom Weights",
              time: _customWeight == null
                  ? 'Not set'
                  : '${_customWeight!.toStringAsFixed(1)} kg',
              color: TColor.lightGray,
              onPressed: _pickWeight,
            ),
            const Spacer(),
            RoundButton(title: "Save", onPressed: _handleSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleTimeChanged(DateTime newDate) {
    setState(() {
      _selectedDateTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        newDate.hour,
        newDate.minute,
      );
    });
  }

  Future<void> _pickWorkout() async {
    final selected = await _showOptionPicker<String>(
      title: 'Choose Workout',
      options: _workoutOptions,
      currentValue: _selectedWorkout,
    );
    if (selected != null) {
      setState(() => _selectedWorkout = selected);
    }
  }

  Future<void> _pickDifficulty() async {
    final selected = await _showOptionPicker<String>(
      title: 'Select Difficulty',
      options: _difficultyOptions,
      currentValue: _selectedDifficulty,
    );
    if (selected != null) {
      setState(() => _selectedDifficulty = selected);
    }
  }

  Future<void> _pickRepetitions() async {
    final options = List<int>.generate(20, (index) => (index + 1) * 5);
    final selected = await _showOptionPicker<int>(
      title: 'Custom Repetitions',
      options: options,
      currentValue: _customRepetitions,
      labelBuilder: (value) => '$value reps',
    );
    if (selected != null) {
      setState(() => _customRepetitions = selected);
    }
  }

  Future<void> _pickWeight() async {
    final options = List<double>.generate(16, (index) => 5 + (index * 2.5));
    final selected = await _showOptionPicker<double>(
      title: 'Custom Weights',
      options: options,
      currentValue: _customWeight,
      labelBuilder: (value) => '${value.toStringAsFixed(1)} kg',
    );
    if (selected != null) {
      setState(() => _customWeight = selected);
    }
  }

  Future<T?> _showOptionPicker<T>({
    required String title,
    required List<T> options,
    T? currentValue,
    String Function(T value)? labelBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TColor.gray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...options.map((option) {
                  final label = labelBuilder != null
                      ? labelBuilder(option)
                      : option.toString();
                  final isSelected =
                      currentValue != null && option == currentValue;
                  return ListTile(
                    title: Text(label),
                    trailing: isSelected
                        ? Icon(Icons.check, color: TColor.primaryColor2)
                        : null,
                    onTap: () => context.pop(option),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSave() {
    final messenger = ScaffoldMessenger.of(context);
    final formattedDate = DateTimeUtils.formatDate(
      _selectedDateTime,
      pattern: 'E, dd MMM yyyy • h:mm a',
    );

    messenger.showSnackBar(
      SnackBar(content: Text('Schedule saved for $formattedDate')),
    );

    context.pop({
      'date': _selectedDateTime,
      'workout': _selectedWorkout,
      'difficulty': _selectedDifficulty,
      'repetitions': _customRepetitions,
      'weight': _customWeight,
    });
  }
}
