import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/date_time_utils.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common_widget/icon_title_next_row.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'photo_progress_models.dart';
import 'photo_progress_strings.dart';

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
    final localize = context.localize;

    return Scaffold(
      appBar: _buildAppBar(localize),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            IconTitleNextRow(
              icon: 'assets/img/date.png',
              title: localize(ComparisonTexts.selectMonth1),
              time: DateTimeUtils.formatDate(_firstMonth, pattern: 'MMMM yyyy'),
              onPressed: () => _pickMonth(isFirst: true),
              color: TColor.lightGray,
            ),
            const SizedBox(height: 15),
            IconTitleNextRow(
              icon: 'assets/img/date.png',
              title: localize(ComparisonTexts.selectMonth2),
              time: DateTimeUtils.formatDate(
                _secondMonth,
                pattern: 'MMMM yyyy',
              ),
              onPressed: () => _pickMonth(isFirst: false),
              color: TColor.lightGray,
            ),
            const Spacer(),
            RoundButton(
              title: localize(ComparisonTexts.compareButton),
              onPressed: _onCompare,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Localizer localize) {
    return AppBar(
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
        localize(ComparisonTexts.title),
        style: const TextStyle(
          color: Colors.black,
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
    );
  }

  Future<void> _pickMonth({required bool isFirst}) async {
    final initialDate = isFirst ? _firstMonth : _secondMonth;
    final helpText = context.localize(ComparisonTexts.selectMonthHelp);
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
      helpText: helpText,
      initialDatePickerMode: DatePickerMode.year,
      selectableDayPredicate: (day) => day.day == 1,
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      final normalized = DateTime(selectedDate.year, selectedDate.month);
      if (isFirst) {
        _firstMonth = normalized;
      } else {
        _secondMonth = normalized;
      }
    });
  }

  void _onCompare() {
    if (!_isSelectionValid()) {
      _showSnackBar(context.localize(ComparisonTexts.invalidSelection));
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
      builder: (sheetContext) {
        final localize = sheetContext.localize;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(localize(ComparisonTexts.shareProgress)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showSnackBar(localize(ComparisonTexts.shareInfo));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(localize(ComparisonTexts.resetSelection)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
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
