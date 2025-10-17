import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/dependencies.dart';
import '../../common/date_time_utils.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/round_button.dart';
import '../shared/models/workout.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key, required this.date});

  final DateTime date;

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  late DateTime _selectedDateTime;
  late _WorkoutOption _selectedWorkout;
  late _DifficultyOption _selectedDifficulty;
  int? _customRepetitions;
  double? _customWeight;
  bool _isSaving = false;

  static const _appBarTitle = LocalizedText(
    english: 'Add Schedule',
    indonesian: 'Tambah Jadwal',
  );

  static const _scheduleTooltip = LocalizedText(
    english: 'Schedule actions',
    indonesian: 'Aksi jadwal',
  );

  static const _scheduleHint = LocalizedText(
    english: 'Templates for schedules coming soon.',
    indonesian: 'Template jadwal segera hadir.',
  );

  static const _timeLabel = LocalizedText(english: 'Time', indonesian: 'Waktu');

  static const _detailsLabel = LocalizedText(
    english: 'Workout Details',
    indonesian: 'Detail Latihan',
  );

  static const _chooseWorkoutLabel = LocalizedText(
    english: 'Choose Workout',
    indonesian: 'Pilih Latihan',
  );

  static const _difficultyLabel = LocalizedText(
    english: 'Difficulty',
    indonesian: 'Tingkat Kesulitan',
  );

  static const _customRepetitionsLabel = LocalizedText(
    english: 'Custom Repetitions',
    indonesian: 'Repetisi Khusus',
  );

  static const _customWeightsLabel = LocalizedText(
    english: 'Custom Weights',
    indonesian: 'Beban Khusus',
  );

  static const _notSetLabel = LocalizedText(
    english: 'Not set',
    indonesian: 'Belum diatur',
  );

  static const _saveLabel = LocalizedText(
    english: 'Save',
    indonesian: 'Simpan',
  );

  static const _workoutOptions = <_WorkoutOption>[
    _WorkoutOption(
      id: 'upperbody',
      label: LocalizedText(
        english: 'Upperbody Workout',
        indonesian: 'Latihan Tubuh Atas',
      ),
      goal: WorkoutGoal.buildMuscle,
      environment: WorkoutEnvironment.gym,
    ),
    _WorkoutOption(
      id: 'fullbody',
      label: LocalizedText(
        english: 'Fullbody Workout',
        indonesian: 'Latihan Seluruh Tubuh',
      ),
      goal: WorkoutGoal.loseWeight,
      environment: WorkoutEnvironment.home,
    ),
    _WorkoutOption(
      id: 'lowerbody',
      label: LocalizedText(
        english: 'Lowerbody Workout',
        indonesian: 'Latihan Tubuh Bawah',
      ),
      goal: WorkoutGoal.buildMuscle,
      environment: WorkoutEnvironment.gym,
    ),
    _WorkoutOption(
      id: 'core_burner',
      label: LocalizedText(english: 'Core Burner', indonesian: 'Pembakar Inti'),
      goal: WorkoutGoal.endurance,
      environment: WorkoutEnvironment.home,
    ),
  ];

  static const _difficultyOptions = <_DifficultyOption>[
    _DifficultyOption(
      id: 'beginner',
      label: LocalizedText(english: 'Beginner', indonesian: 'Pemula'),
      level: WorkoutLevel.beginner,
    ),
    _DifficultyOption(
      id: 'intermediate',
      label: LocalizedText(english: 'Intermediate', indonesian: 'Menengah'),
      level: WorkoutLevel.intermediate,
    ),
    _DifficultyOption(
      id: 'advanced',
      label: LocalizedText(english: 'Advanced', indonesian: 'Lanjutan'),
      level: WorkoutLevel.advanced,
    ),
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
    _selectedWorkout = _workoutOptions.first;
    _selectedDifficulty = _difficultyOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
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
              'assets/img/closed_btn.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          _appBarTitle.resolve(language),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Semantics(
            label: _scheduleTooltip.resolve(language),
            button: true,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_scheduleHint.resolve(language))),
                );
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
                  'assets/img/more_btn.png',
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                ),
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
                Image.asset('assets/img/date.png', width: 20, height: 20),
                const SizedBox(width: 8),
                Text(
                  _formatFullDate(widget.date, language),
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _timeLabel.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                initialDateTime: _selectedDateTime,
                use24hFormat: language == AppLanguage.indonesian,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: _handleTimeChanged,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _detailsLabel.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            IconTitleNextRow(
              icon: 'assets/img/choose_workout.png',
              title: _chooseWorkoutLabel.resolve(language),
              time: _selectedWorkout.label.resolve(language),
              color: TColor.lightGray,
              onPressed: _pickWorkout,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: 'assets/img/difficulity.png',
              title: _difficultyLabel.resolve(language),
              time: _selectedDifficulty.label.resolve(language),
              color: TColor.lightGray,
              onPressed: _pickDifficulty,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: 'assets/img/repetitions.png',
              title: _customRepetitionsLabel.resolve(language),
              time: _customRepetitions == null
                  ? _notSetLabel.resolve(language)
                  : _localizedRepetition(_customRepetitions!, language),
              color: TColor.lightGray,
              onPressed: _pickRepetitions,
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: 'assets/img/repetitions.png',
              title: _customWeightsLabel.resolve(language),
              time: _customWeight == null
                  ? _notSetLabel.resolve(language)
                  : _localizedWeight(_customWeight!, language),
              color: TColor.lightGray,
              onPressed: _pickWeight,
            ),
            const Spacer(),
            RoundButton(
              title: _saveLabel.resolve(language),
              onPressed: () {
                if (_isSaving) return;
                _handleSave();
              },
            ),
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
    final selected = await _showOptionPicker<_WorkoutOption>(
      title: _chooseWorkoutLabel,
      options: _workoutOptions,
      currentValue: _selectedWorkout,
      labelBuilder: (option, language) => option.label.resolve(language),
    );
    if (selected != null) {
      setState(() => _selectedWorkout = selected);
    }
  }

  Future<void> _pickDifficulty() async {
    final selected = await _showOptionPicker<_DifficultyOption>(
      title: _difficultyLabel,
      options: _difficultyOptions,
      currentValue: _selectedDifficulty,
      labelBuilder: (option, language) => option.label.resolve(language),
    );
    if (selected != null) {
      setState(() => _selectedDifficulty = selected);
    }
  }

  Future<void> _pickRepetitions() async {
    final options = List<int>.generate(20, (index) => (index + 1) * 5);
    final selected = await _showOptionPicker<int>(
      title: _customRepetitionsLabel,
      options: options,
      currentValue: _customRepetitions,
      labelBuilder: (value, language) => _localizedRepetition(value, language),
    );
    if (selected != null) {
      setState(() => _customRepetitions = selected);
    }
  }

  Future<void> _pickWeight() async {
    final options = List<double>.generate(16, (index) => 5 + (index * 2.5));
    final selected = await _showOptionPicker<double>(
      title: _customWeightsLabel,
      options: options,
      currentValue: _customWeight,
      labelBuilder: (value, language) => _localizedWeight(value, language),
    );
    if (selected != null) {
      setState(() => _customWeight = selected);
    }
  }

  Future<T?> _showOptionPicker<T>({
    required LocalizedText title,
    required List<T> options,
    required T? currentValue,
    required String Function(T value, AppLanguage language) labelBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final language = sheetContext.appLanguage;
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
                      title.resolve(language),
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
                  final label = labelBuilder(option, language);
                  final isSelected =
                      currentValue != null && option == currentValue;
                  return ListTile(
                    title: Text(label),
                    trailing: isSelected
                        ? Icon(Icons.check, color: TColor.primaryColor2)
                        : null,
                    onTap: () => sheetContext.pop(option),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    final messenger = ScaffoldMessenger.of(context);
    final language = context.appLanguage;

    setState(() => _isSaving = true);

    try {
      final notes = _buildNotes(language);
      final title = _selectedWorkout.label.resolve(AppLanguage.english);
      final draft = WorkoutScheduleDraft(
        title: title,
        goal: _selectedWorkout.goal,
        level: _selectedDifficulty.level,
        environment: _selectedWorkout.environment,
        scheduledFor: _selectedDateTime,
        notes: notes,
      );

      final repository = AppDependencies.of(context).workoutRepository;
      final workoutId = await repository.createQuickSchedule(draft);
      if (!mounted) return;

      final formattedDate = DateTimeUtils.formatDate(
        _selectedDateTime,
        pattern: language == AppLanguage.english
            ? 'E, dd MMM yyyy • h:mm a'
            : 'E, dd MMM yyyy • HH.mm',
      );

      final confirmation = language == AppLanguage.english
          ? 'Schedule saved for $formattedDate'
          : 'Jadwal tersimpan untuk $formattedDate';

      messenger.showSnackBar(SnackBar(content: Text(confirmation)));
      context.pop(workoutId);
    } catch (error, stackTrace) {
      debugPrint('Failed to save workout schedule: $error\n$stackTrace');
      if (!mounted) return;
      final message = language == AppLanguage.english
          ? 'Failed to save schedule. Please try again.'
          : 'Gagal menyimpan jadwal. Silakan coba lagi.';
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _buildNotes(AppLanguage language) {
    final notes = <String>[];
    if (_customRepetitions != null) {
      notes.add(
        language == AppLanguage.english
            ? 'Reps: ${_customRepetitions!}'
            : 'Repetisi: ${_customRepetitions!}',
      );
    }
    if (_customWeight != null) {
      final formatted = _customWeight!.toStringAsFixed(1);
      notes.add(
        language == AppLanguage.english
            ? 'Weight: $formatted kg'
            : 'Beban: $formatted kg',
      );
    }
    return notes.isEmpty ? null : notes.join(' • ');
  }

  String _localizedRepetition(int value, AppLanguage language) {
    return language == AppLanguage.english ? '$value reps' : '$value repetisi';
  }

  String _localizedWeight(double value, AppLanguage language) {
    final formatted = value.toStringAsFixed(1);
    return language == AppLanguage.english ? '$formatted kg' : '$formatted kg';
  }

  String _formatFullDate(DateTime date, AppLanguage language) {
    final format = DateFormat('E, dd MMMM yyyy', language.code);
    return format.format(date);
  }
}

class _WorkoutOption {
  const _WorkoutOption({
    required this.id,
    required this.label,
    required this.goal,
    required this.environment,
  });

  final String id;
  final LocalizedText label;
  final WorkoutGoal goal;
  final WorkoutEnvironment environment;
}

class _DifficultyOption {
  const _DifficultyOption({
    required this.id,
    required this.label,
    required this.level,
  });

  final String id;
  final LocalizedText label;
  final WorkoutLevel level;
}
