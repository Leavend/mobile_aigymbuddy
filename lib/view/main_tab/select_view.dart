import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  static const List<_FeatureDestination> _destinations = [
    _FeatureDestination(
      label: LocalizedText(
        english: 'Workout Tracker',
        indonesian: 'Pelacak Latihan',
      ),
      route: AppRoute.workoutTracker,
    ),
    _FeatureDestination(
      label: LocalizedText(
        english: 'Meal Planner',
        indonesian: 'Perencana Makan',
      ),
      route: AppRoute.mealPlanner,
    ),
    _FeatureDestination(
      label: LocalizedText(
        english: 'Sleep Tracker',
        indonesian: 'Pelacak Tidur',
      ),
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
            child: _FeatureList(destinations: _destinations),
          ),
        ),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.destinations});

  final List<_FeatureDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < destinations.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
            child: _FeatureButton(
              destination: destinations[i],
              label: localize(destinations[i].label),
            ),
          ),
      ],
    );
  }
}

class _FeatureDestination {
  const _FeatureDestination({required this.label, required this.route});

  final LocalizedText label;
  final String route;
}

class _FeatureButton extends StatelessWidget {
  const _FeatureButton({required this.destination, required this.label});

  final _FeatureDestination destination;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: RoundButton(
        title: label,
        onPressed: () => context.push(destination.route),
      ),
    );
  }
}
