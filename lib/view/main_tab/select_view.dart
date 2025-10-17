import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  static final List<_FeatureDestination> _destinations = List.unmodifiable([
    const _FeatureDestination(
      label: LocalizedText(
        english: 'Workout Tracker',
        indonesian: 'Pelacak Latihan',
      ),
      route: AppRoute.workoutTracker,
    ),
    const _FeatureDestination(
      label: LocalizedText(
        english: 'Meal Planner',
        indonesian: 'Perencana Makan',
      ),
      route: AppRoute.mealPlanner,
    ),
    const _FeatureDestination(
      label: LocalizedText(
        english: 'Sleep Tracker',
        indonesian: 'Pelacak Tidur',
      ),
      route: AppRoute.sleepTracker,
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _FeatureList(destinations: _destinations),
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

    return ListView.separated(
      itemCount: destinations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      padding: const EdgeInsets.symmetric(vertical: 24),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final destination = destinations[index];
        return _FeatureButton(
          destination: destination,
          label: localize(destination.label),
        );
      },
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
