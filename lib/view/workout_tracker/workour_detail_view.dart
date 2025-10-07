import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/icon_title_next_row.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widget/exercises_set_section.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({super.key, required this.dObj});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  final List<Map<String, String>> youArr = [
    {"image": "assets/img/barbell.png", "title": "Barbell"},
    {"image": "assets/img/skipping_rope.png", "title": "Skipping Rope"},
    {"image": "assets/img/bottle.png", "title": "Bottle 1 Liters"},
  ];

  final List<Map<String, dynamic>> exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {"image": "assets/img/img_1.png", "title": "Warm Up", "value": "05:00"},
        {
          "image": "assets/img/img_2.png",
          "title": "Jumping Jack",
          "value": "12x",
        },
        {"image": "assets/img/img_1.png", "title": "Skipping", "value": "15x"},
        {"image": "assets/img/img_2.png", "title": "Squats", "value": "20x"},
        {
          "image": "assets/img/img_1.png",
          "title": "Arm Raises",
          "value": "00:53",
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Rest and Drink",
          "value": "02:00",
        },
      ],
    },
    {
      "name": "Set 2",
      "set": [
        {"image": "assets/img/img_1.png", "title": "Warm Up", "value": "05:00"},
        {
          "image": "assets/img/img_2.png",
          "title": "Jumping Jack",
          "value": "12x",
        },
        {"image": "assets/img/img_1.png", "title": "Skipping", "value": "15x"},
        {"image": "assets/img/img_2.png", "title": "Squats", "value": "20x"},
        {
          "image": "assets/img/img_1.png",
          "title": "Arm Raises",
          "value": "00:53",
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Rest and Drink",
          "value": "02:00",
        },
      ],
    },
  ];

  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
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
                    "assets/img/black_btn.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
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
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["title"].toString(),
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].toString()} | ${widget.dObj["time"].toString()} | 320 Calories Burn",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _toggleFavorite,
                            child: Image.asset(
                              "assets/img/fav.png",
                              width: 15,
                              height: 15,
                              fit: BoxFit.contain,
                              color: _isFavorite
                                  ? TColor.secondaryColor2
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: "assets/img/time.png",
                        title: "Schedule Workout",
                        time: "5/27, 09:00 AM",
                        color: TColor.primaryColor2.withValues(alpha: 0.3),
                        onPressed: () {
                          context.push(AppRoute.workoutSchedule);
                        },
                      ),
                      SizedBox(height: media.width * 0.02),
                      IconTitleNextRow(
                        icon: "assets/img/difficulity.png",
                        title: "Difficulity",
                        time: "Beginner",
                        color: TColor.secondaryColor2.withValues(alpha: 0.3),
                        onPressed: _showDifficultyInfo,
                      ),
                      SizedBox(height: media.width * 0.05),
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
                              "${youArr.length} Items",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.5,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: youArr.length,
                          itemBuilder: (context, index) {
                            var yObj = youArr[index] as Map? ?? {};
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
                                      yObj["image"].toString(),
                                      width: media.width * 0.2,
                                      height: media.width * 0.2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      yObj["title"].toString(),
                                      style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: _showExerciseSummary,
                            child: Text(
                              "${youArr.length} Sets",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: exercisesArr.length,
                        itemBuilder: (context, index) {
                          var sObj = exercisesArr[index] as Map? ?? {};
                          return ExercisesSetSection(
                            sObj: sObj,
                            onPressed: (obj) {
                              context.push(
                                AppRoute.exerciseSteps,
                                extra: ExerciseStepsArgs(
                                  exercise: Map<String, dynamic>.from(obj),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                        title: "Start Workout",
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

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
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
      builder: (context) {
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
                  onPressed: () => Navigator.of(context).pop(),
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
                ...youArr.map((item) {
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
                ...exercisesArr.map((set) {
                  final exercises =
                      (set['set'] as List<dynamic>? ?? const []).length;
                  return ListTile(
                    title: Text(
                      set['name'].toString(),
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
    final firstSet = exercisesArr.isNotEmpty ? exercisesArr.first : null;
    final setItems = firstSet != null
        ? (firstSet['set'] as List<dynamic>? ?? const [])
        : const [];
    if (setItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises available yet.')),
      );
      return;
    }

    final firstExercise = Map<String, dynamic>.from(setItems.first as Map);

    context.push(
      AppRoute.exerciseSteps,
      extra: ExerciseStepsArgs(exercise: firstExercise),
    );
  }
}
