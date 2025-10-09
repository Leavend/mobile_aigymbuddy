import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  static const List<_FeatureDestination> _destinations = [
    _FeatureDestination(
      label: 'Workout Tracker',
      route: AppRoute.workoutTracker,
    ),
    _FeatureDestination(
      label: 'Meal Planner',
      route: AppRoute.mealPlanner,
    ),
    _FeatureDestination(
      label: 'Sleep Tracker',
      route: AppRoute.sleepTracker,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < _destinations.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _FeatureButton(destination: _destinations[i]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureDestination {
  const _FeatureDestination({required this.label, required this.route});

  final String label;
  final String route;
}

class _FeatureButton extends StatelessWidget {
  const _FeatureButton({required this.destination});

  final _FeatureDestination destination;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: destination.label,
      child: RoundButton(
        title: destination.label,
        onPressed: () => context.push(destination.route),
      ),
    );
  }
}
