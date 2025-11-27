import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/workout_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutConfig {

  const WorkoutConfig({
    required this.name,
    required this.image,
    required this.calories,
    required this.minutes,
    required this.progress,
  });
  final LocalizedText name;
  final String image;
  final String calories;
  final String minutes;
  final double progress;

  Map<String, dynamic> toSummaryItem(AppLanguage language) {
    return {
      'name': name.resolve(language),
      'image': image,
      'kcal': calories,
      'time': minutes,
      'progress': progress,
    };
  }
}

class LatestWorkoutSection extends StatelessWidget {
  const LatestWorkoutSection({
    required this.title, required this.seeMoreLabel, required this.workouts, super.key,
  });

  final LocalizedText title;
  final LocalizedText seeMoreLabel;
  final List<WorkoutConfig> workouts;

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    final language = context.appLanguage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localize(title),
              style: const TextStyle(
                color: TColor.black,
                fontSize: UIConstants.fontSizeMedium,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                localize(seeMoreLabel),
                style: const TextStyle(
                  color: TColor.gray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: workouts.length,
          separatorBuilder: (_, index) =>
              const SizedBox(height: UIConstants.spacingMedium),
          itemBuilder: (context, index) {
            final config = workouts[index];
            final workout = config.toSummaryItem(language);
            return WorkoutRow.fromMap(
              workout,
              onTap: () => context.push(AppRoute.finishedWorkout),
            );
          },
        ),
      ],
    );
  }
}
