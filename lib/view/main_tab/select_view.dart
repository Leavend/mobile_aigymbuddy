import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
                title: "Workout Tracker",
                onPressed: () {
                  context.push(AppRoute.workoutTracker);
                }),

                const SizedBox(height: 15,),

                  RoundButton(
                title: "Meal Planner",
                onPressed: () {
                  context.push(AppRoute.mealPlanner);
                }),

                const SizedBox(height: 15,),

                  RoundButton(
                title: "Sleep Tracker",
                onPressed: () {
                  context.push(AppRoute.sleepTracker);
                })
          ],
        ),
      ),
    );
  }
}