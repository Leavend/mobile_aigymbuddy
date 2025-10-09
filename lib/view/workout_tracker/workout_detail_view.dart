import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
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
  static const List<Map<String, String>> _equipmentItems = [
    {'image': 'assets/img/barbell.png', 'title': 'Barbell'},
    {'image': 'assets/img/skipping_rope.png', 'title': 'Skipping Rope'},
    {'image': 'assets/img/bottle.png', 'title': 'Bottle 1 Liters'},
  ];

  static final List<ExerciseSet> _workoutSets = List.unmodifiable([
    ExerciseSet.fromJson({
      'name': 'Set 1',
      'set': [
        {'image': 'assets/img/img_1.png', 'title': 'Warm Up', 'value': '05:00'},
        {
          'image': 'assets/img/img_2.png',
          'title': 'Jumping Jack',
          'value': '12x',
        },
        {'image': 'assets/img/img_1.png', 'title': 'Skipping', 'value': '15x'},
        {'image': 'assets/img/img_2.png', 'title': 'Squats', 'value': '20x'},
        {
          'image': 'assets/img/img_1.png',
          'title': 'Arm Raises',
          'value': '00:53',
        },
        {
          'image': 'assets/img/img_2.png',
          'title': 'Rest and Drink',
          'value': '02:00',
        },
      ],
    }),
    ExerciseSet.fromJson({
      'name': 'Set 2',
      'set': [
        {'image': 'assets/img/img_1.png', 'title': 'Warm Up', 'value': '05:00'},
        {
          'image': 'assets/img/img_2.png',
          'title': 'Jumping Jack',
          'value': '12x',
        },
        {'image': 'assets/img/img_1.png', 'title': 'Skipping', 'value': '15x'},
        {'image': 'assets/img/img_2.png', 'title': 'Squats', 'value': '20x'},
        {
          'image': 'assets/img/img_1.png',
          'title': 'Arm Raises',
          'value': '00:53',
        },
        {
          'image': 'assets/img/img_2.png',
          'title': 'Rest and Drink',
          'value': '02:00',
        },
      ],
    }),
  ]);

  bool _isFavorite = false;

  Map<String, dynamic> get _workout => widget.workout;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildHeaderAppBar(context),
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
                      _buildWorkoutHeader(context),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: 'assets/img/time.png',
                        title: 'Schedule Workout',
                        time: '5/27, 09:00 AM',
                        color: TColor.primaryColor2.withValues(alpha: 0.3),
                        onPressed: () =>
                            context.pushNamed(AppRoute.workoutScheduleName),
                      ),
                      SizedBox(height: media.width * 0.02),
                      IconTitleNextRow(
                        icon: 'assets/img/difficulity.png',
                        title: 'Difficulity',
                        time: 'Beginner',
                        color: TColor.secondaryColor2.withValues(alpha: 0.3),
                        onPressed: _showDifficultyInfo,
                      ),
                      SizedBox(height: media.width * 0.05),
                      _buildEquipmentSection(media),
                      SizedBox(height: media.width * 0.05),
                      _buildExercisesSection(),
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
                        title: 'Start Workout',
                        onPressed: _startWorkout,
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
              const SnackBar(content: Text('More actions coming soon.')),
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

  Widget _buildWorkoutHeader(BuildContext context) {
    final exercises = _workout['exercises'] ?? '11 Exercises';
    final time = _workout['time'] ?? '32 mins';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _workout['title']?.toString() ?? 'Workout Plan',
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$exercises | $time | 320 Calories Burn',
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

  Widget _buildEquipmentSection(Size media) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You'll Need",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: _showEquipmentSheet,
              child: Text(
                '${_equipmentItems.length} Items',
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
                        item['image']!,
                        width: media.width * 0.2,
                        height: media.width * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['title']!,
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

  Widget _buildExercisesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercises',
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: _showExerciseSummary,
              child: Text(
                '${_workoutSets.length} Sets',
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _workoutSets.length,
          itemBuilder: (context, index) {
            final set = _workoutSets[index];
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favourites' : 'Removed from favourites',
        ),
      ),
    );
  }

  Future<void> _showDifficultyInfo() async {
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
                  'Difficulty Levels',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Beginner workouts focus on mastering form and building a consistent routine. '
                  'Increase to Intermediate or Advanced once you can complete every set without breaking form.',
                  style: TextStyle(color: TColor.gray, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Got it'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEquipmentSheet() async {
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
                  "You'll Need",
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
                      item['image']!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      item['title']!,
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

  Future<void> _showExerciseSummary() async {
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
                  'Exercises Overview',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ..._workoutSets.map((set) {
                  final exercises = set.exercises.length;
                  return ListTile(
                    title: Text(
                      set.name,
                      style: TextStyle(color: TColor.black),
                    ),
                    subtitle: Text(
                      '$exercises exercises',
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

  void _startWorkout() {
    final firstExercise =
        _workoutSets.isNotEmpty && _workoutSets.first.exercises.isNotEmpty
            ? _workoutSets.first.exercises.first
            : null;

    if (firstExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises available yet.')),
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
}
