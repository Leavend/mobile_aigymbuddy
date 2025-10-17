import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../common/app_router.dart';
import '../../common/color_extension.dart';
import '../../common/localization/app_language.dart';
import '../../common/localization/app_language_scope.dart';
import '../../common/models/navigation_args.dart';
import '../../common_widget/exercises_row.dart';
import '../../common_widget/exercises_set_section.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/round_button.dart';
import '../shared/models/workout.dart';
import '../shared/repositories/workout_repository.dart';
import 'workout_localizations.dart';
import 'workout_visuals.dart';

class WorkoutDetailView extends StatefulWidget {
  const WorkoutDetailView({super.key, required this.args});

  final WorkoutDetailArgs args;

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

  bool _isFavorite = false;
  late WorkoutRepository _repository;
  Future<WorkoutDetail?>? _detailFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository = AppDependencies.of(context).workoutRepository;
    _detailFuture ??= _repository.loadWorkoutDetail(widget.args.workoutId);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

    final detailFuture = _detailFuture;
    if (detailFuture == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<WorkoutDetail?>(
      future: detailFuture,
      builder: (context, snapshot) {
        final detail = snapshot.data;
        final overview = detail?.overview ?? widget.args.fallbackOverview;
        final isLoading = snapshot.connectionState != ConnectionState.done;

        if (overview == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: const Text('Workout'),
            ),
            body: Center(
              child: Text(
                language == AppLanguage.english
                    ? 'Workout not found.'
                    : 'Latihan tidak ditemukan.',
              ),
            ),
          );
        }

        final workoutSets = detail == null
            ? _defaultExerciseSets(language)
            : _mapExercisesToSets(language, detail.exercises);

        return _WorkoutDetailScaffold(
          media: media,
          language: language,
          overview: overview,
          workoutSets: workoutSets,
          isLoading: isLoading,
          isFavorite: _isFavorite,
          onToggleFavorite: _toggleFavorite,
          onShowDifficultyInfo: _showDifficultyInfo,
          onShowEquipmentSheet: _showEquipmentSheet,
          onShowExerciseSummary: () => _showExerciseSummary(workoutSets),
          onStartWorkout: () => _startWorkout(workoutSets),
        );
      },
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    final language = context.appLanguage;
    final message = _isFavorite
        ? _addedToFavourite.resolve(language)
        : _removedFromFavourite.resolve(language);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
    final firstExercise =
        workoutSets.isNotEmpty && workoutSets.first.exercises.isNotEmpty
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

  List<ExerciseSet> _mapExercisesToSets(
    AppLanguage language,
    List<WorkoutExerciseDetail> exercises,
  ) {
    if (exercises.isEmpty) {
      return _defaultExerciseSets(language);
    }

    final items = exercises.map((exercise) {
      final segments = <String>['${exercise.sets} sets'];
      if (exercise.reps != null) {
        segments.add('${exercise.reps} reps');
      }
      if (exercise.duration != null) {
        segments.add(
          WorkoutLocalizations.durationLabel(language, exercise.duration),
        );
      }
      if (exercise.rest > 0) {
        final restLabel = language == AppLanguage.english
            ? 'Rest ${exercise.rest}s'
            : 'Istirahat ${exercise.rest}dtk';
        segments.add(restLabel);
      }

      return ExerciseListItem(
        imageAsset: WorkoutVisuals.exerciseImageForCategory(exercise.category),
        title: exercise.name,
        subtitle: segments.join(' • '),
      );
    }).toList(growable: false);

    final name = language == AppLanguage.english ? 'Exercises' : 'Latihan';
    return [ExerciseSet(name: name, exercises: items)];
  }

  List<ExerciseSet> _defaultExerciseSets(AppLanguage language) {
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

class _WorkoutDetailScaffold extends StatelessWidget {
  const _WorkoutDetailScaffold({
    required this.media,
    required this.language,
    required this.overview,
    required this.workoutSets,
    required this.isLoading,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onShowDifficultyInfo,
    required this.onShowEquipmentSheet,
    required this.onShowExerciseSummary,
    required this.onStartWorkout,
  });

  final Size media;
  final AppLanguage language;
  final WorkoutOverview overview;
  final List<ExerciseSet> workoutSets;
  final bool isLoading;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShowDifficultyInfo;
  final VoidCallback onShowEquipmentSheet;
  final VoidCallback onShowExerciseSummary;
  final VoidCallback onStartWorkout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildHeaderAppBar(context),
          _buildHeroImage(),
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
                      if (isLoading)
                        const LinearProgressIndicator(minHeight: 2),
                      SizedBox(height: media.width * 0.05),
                      _buildWorkoutHeader(),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: 'assets/img/time.png',
                        title: _WorkoutDetailViewState._scheduleWorkoutLabel
                            .resolve(language),
                        time: _scheduleLabel(),
                        color: TColor.primaryColor2.withValues(alpha: 0.3),
                        onPressed: () =>
                            context.pushNamed(AppRoute.workoutScheduleName),
                      ),
                      SizedBox(height: media.width * 0.02),
                      IconTitleNextRow(
                        icon: 'assets/img/difficulity.png',
                        title: _WorkoutDetailViewState._difficultyLabel
                            .resolve(language),
                        time: _difficultyLabelText(),
                        color: TColor.secondaryColor2.withValues(alpha: 0.3),
                        onPressed: onShowDifficultyInfo,
                      ),
                      SizedBox(height: media.width * 0.05),
                      _buildEquipmentSection(),
                      SizedBox(height: media.width * 0.05),
                      _buildExercisesSection(context),
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
                        title: _WorkoutDetailViewState._startWorkoutLabel
                            .resolve(language),
                        onPressed: onStartWorkout,
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

  SliverAppBar _buildHeaderAppBar(BuildContext context) {
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
              SnackBar(
                content: Text(
                  _WorkoutDetailViewState._moreActionsSnack.resolve(language),
                ),
              ),
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

  SliverAppBar _buildHeroImage() {
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
          WorkoutVisuals.coverImageFor(overview.goal),
          width: media.width * 0.75,
          height: media.width * 0.8,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    final exercisesLabel = WorkoutLocalizations.exerciseCount(
      language,
      overview.exerciseCount,
    );
    final durationLabel = WorkoutLocalizations.durationLabel(
      language,
      overview.estimatedDuration,
    );
    final subtitle =
        '$exercisesLabel | $durationLabel | ${_WorkoutDetailViewState._calorieSummary.resolve(language)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overview.title,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onToggleFavorite,
          child: Image.asset(
            'assets/img/fav.png',
            width: 15,
            height: 15,
            fit: BoxFit.contain,
            color: isFavorite ? TColor.secondaryColor2 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentSection() {
    final summary = _WorkoutDetailViewState._equipmentSummaryLabel
        .resolve(language)
        .replaceFirst('{count}', _equipmentItems.length.toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _WorkoutDetailViewState._equipmentTitle.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: onShowEquipmentSheet,
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

  Widget _buildExercisesSection(BuildContext context) {
    final summary = _WorkoutDetailViewState._exercisesSummaryLabel
        .resolve(language)
        .replaceFirst('{count}', workoutSets.length.toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _WorkoutDetailViewState._exercisesTitle.resolve(language),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: onShowExerciseSummary,
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

  String _scheduleLabel() {
    final scheduled = overview.scheduledFor;
    if (scheduled == null) {
      return language == AppLanguage.english
          ? 'Not scheduled'
          : 'Belum dijadwalkan';
    }
    return WorkoutLocalizations.scheduleTime(language, scheduled);
  }

  String _difficultyLabelText() {
    return WorkoutLocalizations.levelLabel(language, overview.level);
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

const _equipmentItems = <_EquipmentItem>[
  _EquipmentItem(
    imageAsset: 'assets/img/barbell.png',
    title: LocalizedText(english: 'Barbell', indonesian: 'Barbel'),
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

const _exerciseSets = <_ExerciseSetConfig>[
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
        title: LocalizedText(
          english: 'Jumping Jack',
          indonesian: 'Jumping Jack',
        ),
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
        title: LocalizedText(
          english: 'Arm Raises',
          indonesian: 'Angkat Lengan',
        ),
        subtitle: LocalizedText(english: '00:53', indonesian: '00:53'),
      ),
      _ExerciseItemConfig(
        imageAsset: 'assets/img/img_2.png',
        title: LocalizedText(
          english: 'Rest and Drink',
          indonesian: 'Istirahat dan Minum',
        ),
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
        title: LocalizedText(
          english: 'Jumping Jack',
          indonesian: 'Jumping Jack',
        ),
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
        title: LocalizedText(
          english: 'Arm Raises',
          indonesian: 'Angkat Lengan',
        ),
        subtitle: LocalizedText(english: '00:53', indonesian: '00:53'),
      ),
      _ExerciseItemConfig(
        imageAsset: 'assets/img/img_2.png',
        title: LocalizedText(
          english: 'Rest and Drink',
          indonesian: 'Istirahat dan Minum',
        ),
        subtitle: LocalizedText(english: '02:00', indonesian: '02:00'),
      ),
    ],
  ),
];
