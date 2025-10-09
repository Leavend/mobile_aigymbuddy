import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common_widget/icon_title_next_row.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common/date_time_utils.dart';

class ComparisonView extends StatefulWidget {
  const ComparisonView({super.key});

  @override
  State<ComparisonView> createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  late DateTime _firstMonth;
  late DateTime _secondMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _secondMonth = DateTime(now.year, now.month);
    _firstMonth = DateTime(now.year, now.month - 1);
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
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: Container(
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/img/black_btn.png', fit: BoxFit.contain),
          ),
        ),
        title: Text(
          'Comparison',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showMoreOptions,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/img/more_btn.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            IconTitleNextRow(
              icon: 'assets/img/date.png',
              title: 'Select month 1',
              time: DateTimeUtils.formatDate(_firstMonth, pattern: 'MMMM yyyy'),
              onPressed: () => _pickMonth(isFirst: true),
              color: TColor.lightGray,
            ),
            const SizedBox(height: 15),
            IconTitleNextRow(
              icon: 'assets/img/date.png',
              title: 'Select month 2',
              time: DateTimeUtils.formatDate(
                _secondMonth,
                pattern: 'MMMM yyyy',
              ),
              onPressed: () => _pickMonth(isFirst: false),
              color: TColor.lightGray,
            ),
            const Spacer(),
            RoundButton(title: 'Compare', onPressed: _onCompare),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMonth({required bool isFirst}) async {
    final initialDate = isFirst ? _firstMonth : _secondMonth;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
      helpText: 'Select month',
      initialDatePickerMode: DatePickerMode.year,
      selectableDayPredicate: (day) => day.day == 1,
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      if (isFirst) {
        _firstMonth = DateTime(selectedDate.year, selectedDate.month);
      } else {
        _secondMonth = DateTime(selectedDate.year, selectedDate.month);
      }
    });
  }

  void _onCompare() {
    if (!_isSelectionValid()) {
      _showSnackBar(
        'Please ensure the months are different and the first month is earlier.',
      );
      return;
    }

    context.pushNamed(
      AppRoute.photoResultName,
      extra: PhotoResultArgs(firstDate: _firstMonth, secondDate: _secondMonth),
    );
  }

  bool _isSelectionValid() {
    if (_firstMonth.year == _secondMonth.year &&
        _firstMonth.month == _secondMonth.month) {
      return false;
    }
    return !_firstMonth.isAfter(_secondMonth);
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share progress'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showSnackBar('Share functionality coming soon.');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Reset selection'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    final now = DateTime.now();
                    _secondMonth = DateTime(now.year, now.month);
                    _firstMonth = DateTime(now.year, now.month - 1);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
