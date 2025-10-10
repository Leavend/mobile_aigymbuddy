import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common_widget/icon_title_next_row.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widget/exercises_row.dart';
import '../../common_widget/exercises_set_section.dart';

class WorkoutDetailView extends StatefulWidget {
  const WorkoutDetailView({super.key, required this.workout});

  final Map<String, dynamic> workout;

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  static const _moreActionsSnack = LocalizedText(
    english: 'More actions coming soon.',
    indonesian: 'Aksi lainnya segera hadir.',
  );

  static const _scheduleWorkoutLabel = LocalizedText(
    english: 'Schedule Workout',
    indonesian: 'Jadwalkan Latihan',
  );

  static const _difficultyLabel = LocalizedText(
    english: 'Difficulty',
    indonesian: 'Tingkat Kesulitan',
  );

  static const _defaultDifficulty = LocalizedText(
    english: 'Beginner',
    indonesian: 'Pemula',
  );

  static const _equipmentTitle = LocalizedText(
    english: "You'll Need",
    indonesian: 'Peralatan yang Dibutuhkan',
  );

  static const _equipmentSummaryLabel = LocalizedText(
    english: '{count} Items',
    indonesian: '{count} Peralatan',
  );

  static const _exercisesTitle = LocalizedText(
    english: 'Exercises',
    indonesian: 'Latihan',
  );

  static const _exercisesSummaryLabel = LocalizedText(
    english: '{count} Sets',
    indonesian: '{count} Set',
  );

  static const _startWorkoutLabel = LocalizedText(
    english: 'Start Workout',
    indonesian: 'Mulai Latihan',
  );

  static const _calorieSummary = LocalizedText(
    english: '320 Calories Burn',
    indonesian: '320 Kalori Terbakar',
  );

  static const _difficultyInfoTitle = LocalizedText(
    english: 'Difficulty Levels',
    indonesian: 'Tingkat Kesulitan',
  );

  static const _difficultyInfoBody = LocalizedText(
    english:
        'Beginner workouts focus on mastering form and building a consistent routine. Increase to Intermediate or Advanced once you can complete every set without breaking form.',
    indonesian:
        'Latihan untuk pemula berfokus pada teknik dan konsistensi. Naik ke Menengah atau Lanjutan ketika kamu bisa menyelesaikan semua set tanpa kehilangan bentuk.',
  );

  static const _gotItLabel = LocalizedText(
    english: 'Got it',
    indonesian: 'Mengerti',
  );

  static const _equipmentSheetTitle = LocalizedText(
    english: "You'll Need",
    indonesian: 'Peralatan yang Dibutuhkan',
  );

  static const _exercisesOverviewTitle = LocalizedText(
    english: 'Exercises Overview',
    indonesian: 'Ringkasan Latihan',
  );

  static const _addedToFavourite = LocalizedText(
    english: 'Added to favourites',
    indonesian: 'Ditambahkan ke favorit',
  );

  static const _removedFromFavourite = LocalizedText(
    english: 'Removed from favourites',
    indonesian: 'Dihapus dari favorit',
  );

  static const _noExercisesSnack = LocalizedText(
    english: 'No exercises available yet.',
    indonesian: 'Belum ada latihan tersedia.',
  );

  static const _equipmentItems = <_EquipmentItem>[
    _EquipmentItem(
      imageAsset: 'assets/img/barbell.png',
      title: LocalizedText(
        english: 'Barbell',
        indonesian: 'Barbel',
      ),
    ),
    _EquipmentItem(
      imageAsset: 'assets/img/skipping_rope.png',
      title: LocalizedText(
        english: 'Skipping Rope',
        indonesian: 'Tali Skipping',
      ),
    ),
    _EquipmentItem(
      imageAsset: 'assets/img/bottle.png',
      title: LocalizedText(
        english: 'Bottle 1 Liter',
        indonesian: 'Botol 1 Liter',
      ),
    ),
  ];

  static const _exerciseSets = <_ExerciseSetConfig>[
    _ExerciseSetConfig(
      name: LocalizedText(english: 'Set 1', indonesian: 'Set 1'),
      exercises: [
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_1.png',
          title: LocalizedText(english: 'Warm Up', indonesian: 'Pemanasan'),
          subtitle: LocalizedText(english: '05:00', indonesian: '05:00'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_2.png',
          title: LocalizedText(english: 'Jumping Jack', indonesian: 'Jumping Jack'),
          subtitle: LocalizedText(english: '12x', indonesian: '12x'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_1.png',
          title: LocalizedText(english: 'Skipping', indonesian: 'Skipping'),
          subtitle: LocalizedText(english: '15x', indonesian: '15x'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_2.png',
          title: LocalizedText(english: 'Squats', indonesian: 'Squat'),
          subtitle: LocalizedText(english: '20x', indonesian: '20x'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_1.png',
          title: LocalizedText(english: 'Arm Raises', indonesian: 'Angkat Lengan'),
          subtitle: LocalizedText(english: '00:53', indonesian: '00:53'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_2.png',
          title: LocalizedText(english: 'Rest and Drink', indonesian: 'Istirahat dan Minum'),
          subtitle: LocalizedText(english: '02:00', indonesian: '02:00'),
        ),
      ],
    ),
    _ExerciseSetConfig(
      name: LocalizedText(english: 'Set 2', indonesian: 'Set 2'),
      exercises: [
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_1.png',
          title: LocalizedText(english: 'Warm Up', indonesian: 'Pemanasan'),
          subtitle: LocalizedText(english: '05:00', indonesian: '05:00'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_2.png',
          title: LocalizedText(english: 'Jumping Jack', indonesian: 'Jumping Jack'),
          subtitle: LocalizedText(english: '12x', indonesian: '12x'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_1.png',
          title: LocalizedText(english: 'Skipping', indonesian: 'Skipping'),
          subtitle: LocalizedText(english: '15x', indonesian: '15x'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_2.png',
          title: LocalizedText(english: 'Squats', indonesian: 'Squat'),
          subtitle: LocalizedText(english: '20x', indonesian: '20x'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_1.png',
          title: LocalizedText(english: 'Arm Raises', indonesian: 'Angkat Lengan'),
          subtitle: LocalizedText(english: '00:53', indonesian: '00:53'),
        ),
        _ExerciseItemConfig(
          imageAsset: 'assets/img/img_2.png',
          title: LocalizedText(english: 'Rest and Drink', indonesian: 'Istirahat dan Minum'),
          subtitle: LocalizedText(english: '02:00', indonesian: '02:00'),
        ),
      ],
    ),
  ];

  bool _isFavorite = false;

  Map<String, dynamic> get _workout => widget.workout;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;
    final workoutSets = _buildWorkoutSets(language);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildHeaderAppBar(context, language),
          _buildHeroImage(media),
        ],
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: TColor.gray.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      _buildWorkoutHeader(context, language),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: 'assets/img/time.png',
                        title: _scheduleWorkoutLabel.resolve(language),
                        time: _workout['time']?.toString() ??
                            (language == AppLanguage.english
                                ? '5/27, 09:00 AM'
                                : '27/5, 09.00'),
                        color: TColor.primaryColor2.withValues(alpha: 0.3),
                        onPressed: () =>
                            context.pushNamed(AppRoute.workoutScheduleName),
                      ),
                      SizedBox(height: media.width * 0.02),
                      IconTitleNextRow(
                        icon: 'assets/img/difficulity.png',
                        title: _difficultyLabel.resolve(language),
                        time: _workout['difficulty']?.toString() ??
                            _defaultDifficulty.resolve(language),
                        color: TColor.secondaryColor2.withValues(alpha: 0.3),
                        onPressed: _showDifficultyInfo,
                      ),
                      SizedBox(height: media.width * 0.05),
                      _buildEquipmentSection(media, language),
                      SizedBox(height: media.width * 0.05),
                      _buildExercisesSection(context, language, workoutSets),
                      SizedBox(height: media.width * 0.1),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundButton(
                        title: _startWorkoutLabel.resolve(language),
                        onPressed: () => _startWorkout(workoutSets),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildHeaderAppBar(
    BuildContext context,
    AppLanguage language,
  ) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
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
            'assets/img/black_btn.png',
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_moreActionsSnack.resolve(language))),
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
      ],
    );
  }

  SliverAppBar _buildHeroImage(Size media) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      expandedHeight: media.width * 0.5,
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/detail_top.png',
          width: media.width * 0.75,
          height: media.width * 0.8,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader(BuildContext context, AppLanguage language) {
    final exercises = _workout['exercises']?.toString() ??
        (language == AppLanguage.english ? '11 Exercises' : '11 Latihan');
    final time = _workout['time']?.toString() ??
        (language == AppLanguage.english ? '32 mins' : '32 menit');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _workout['title']?.toString() ??
                    (language == AppLanguage.english
                        ? 'Workout Plan'
                        : 'Rencana Latihan'),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$exercises | $time | ${_calorieSummary.resolve(language)}',
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _toggleFavorite,
          child: Image.asset(
            'assets/img/fav.png',
            width: 15,
            height: 15,
            fit: BoxFit.contain,
            color: _isFavorite ? TColor.secondaryColor2 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentSection(Size media, AppLanguage language) {
    final summary = _equipmentSummaryLabel
        .resolve(language)
        .replaceFirst('{count}', _equipmentItems.length.toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _equipmentTitle.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: _showEquipmentSheet,
              child: Text(
                summary,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
          ],
        ),
        SizedBox(
          height: media.width * 0.5,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: _equipmentItems.length,
            itemBuilder: (context, index) {
              final item = _equipmentItems[index];
              return Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: media.width * 0.35,
                      width: media.width * 0.35,
                      decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        item.imageAsset,
                        width: media.width * 0.2,
                        height: media.width * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.title.resolve(language),
                        style: TextStyle(color: TColor.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExercisesSection(
    BuildContext context,
    AppLanguage language,
    List<ExerciseSet> workoutSets,
  ) {
    final summary = _exercisesSummaryLabel
        .resolve(language)
        .replaceFirst('{count}', workoutSets.length.toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _exercisesTitle.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => _showExerciseSummary(workoutSets),
              child: Text(
                summary,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: workoutSets.length,
          itemBuilder: (context, index) {
            final set = workoutSets[index];
            return ExercisesSetSection(
              set: set,
              onPressed: (exercise) {
                context.pushNamed(
                  AppRoute.exerciseStepsName,
                  extra: ExerciseStepsArgs(
                    exercise: Map<String, dynamic>.from(exercise.toJson()),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    final language = context.appLanguage;
    final message = _isFavorite
        ? _addedToFavourite.resolve(language)
        : _removedFromFavourite.resolve(language);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showDifficultyInfo() async {
    final language = context.appLanguage;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _difficultyInfoTitle.resolve(language),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _difficultyInfoBody.resolve(language),
                  style: TextStyle(color: TColor.gray, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(_gotItLabel.resolve(language)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEquipmentSheet() async {
    final language = context.appLanguage;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
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
                const SizedBox(height: 16),
                Text(
                  _equipmentSheetTitle.resolve(language),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ..._equipmentItems.map((item) {
                  return ListTile(
                    leading: Image.asset(
                      item.imageAsset,
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      item.title.resolve(language),
                      style: TextStyle(color: TColor.black),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showExerciseSummary(List<ExerciseSet> workoutSets) async {
    final language = context.appLanguage;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
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
                const SizedBox(height: 16),
                Text(
                  _exercisesOverviewTitle.resolve(language),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...workoutSets.map((set) {
                  final exercises = set.exercises.length;
                  final subtitle = language == AppLanguage.english
                      ? '$exercises exercises'
                      : '$exercises latihan';
                  return ListTile(
                    title: Text(
                      set.name,
                      style: TextStyle(color: TColor.black),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: TextStyle(color: TColor.gray),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startWorkout(List<ExerciseSet> workoutSets) {
    final firstExercise = workoutSets.isNotEmpty &&
            workoutSets.first.exercises.isNotEmpty
        ? workoutSets.first.exercises.first
        : null;

    if (firstExercise == null) {
      final language = context.appLanguage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_noExercisesSnack.resolve(language))),
      );
      return;
    }

    context.pushNamed(
      AppRoute.exerciseStepsName,
      extra: ExerciseStepsArgs(
        exercise: Map<String, dynamic>.from(firstExercise.toJson()),
      ),
    );
  }

  List<ExerciseSet> _buildWorkoutSets(AppLanguage language) {
    return _exerciseSets
        .map(
          (set) => ExerciseSet(
            name: set.name.resolve(language),
            exercises: set.exercises
                .map(
                  (exercise) => ExerciseListItem(
                    imageAsset: exercise.imageAsset,
                    title: exercise.title.resolve(language),
                    subtitle: exercise.subtitle.resolve(language),
                  ),
                )
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
  }
}

class _EquipmentItem {
  const _EquipmentItem({required this.imageAsset, required this.title});

  final String imageAsset;
  final LocalizedText title;
}

class _ExerciseSetConfig {
  const _ExerciseSetConfig({required this.name, required this.exercises});

  final LocalizedText name;
  final List<_ExerciseItemConfig> exercises;
}

class _ExerciseItemConfig {
  const _ExerciseItemConfig({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final LocalizedText title;
  final LocalizedText subtitle;
}
