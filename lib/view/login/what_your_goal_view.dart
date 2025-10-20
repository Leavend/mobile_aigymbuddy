// lib/view/login/what_your_goal_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/di/app_scope.dart';
import 'package:aigymbuddy/common/domain/enums.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/auth_page_layout.dart';
import 'package:aigymbuddy/features/auth/application/models/sign_up_flow_state.dart';
import 'package:aigymbuddy/features/auth/domain/errors/auth_failures.dart';

abstract final class _GoalTexts {
  static const title = LocalizedText(
    english: 'What is your goal?',
    indonesian: 'Apa tujuanmu?',
  );
  static const subtitle = LocalizedText(
    english: 'It will help us to choose a best program for you',
    indonesian: 'Ini membantu kami memilih program terbaik untukmu',
  );
  static const confirm = LocalizedText(
    english: 'Confirm',
    indonesian: 'Konfirmasi',
  );
  static const submitError = LocalizedText(
    english: 'We could not save your goal. Please try again.',
    indonesian: 'Tujuan tidak dapat disimpan. Silakan coba lagi.',
  );
}

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key, required this.flow});

  final SignUpFlowState flow;

  static const _goals = [
    _GoalCardData(
      image: 'assets/img/goal_1.png',
      goal: Goal.muscleGain,
      title: LocalizedText(
        english: 'Improve Shape',
        indonesian: 'Bentuk Tubuh Ideal',
      ),
      subtitle: LocalizedText(
        english:
            'I have a low amount of body fat and\nneed / want to build more muscle',
        indonesian:
            'Lemak tubuhku rendah dan aku ingin\nmembangun lebih banyak otot',
      ),
    ),
    _GoalCardData(
      image: 'assets/img/goal_2.png',
      goal: Goal.maintain,
      title: LocalizedText(
        english: 'Lean & Tone',
        indonesian: 'Badan Ramping & Kencang',
      ),
      subtitle: LocalizedText(
        english:
            'I’m “skinny fat”, look thin but have\nno shape. I want to add lean muscle\nin the right way',
        indonesian:
            'Tubuhku tampak kurus tapi kurang berisi.\nAku ingin menambah otot tanpa lemak\ndengan cara tepat',
      ),
    ),
    _GoalCardData(
      image: 'assets/img/goal_3.png',
      goal: Goal.fatLoss,
      title: LocalizedText(english: 'Lose a Fat', indonesian: 'Turunkan Lemak'),
      subtitle: LocalizedText(
        english:
            'I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle mass',
        indonesian:
            'Aku perlu menurunkan banyak lemak\ndan ingin menambah massa otot',
      ),
    ),
  ];

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  int _currentIndex = 0;
  bool _isSubmitting = false;

  Goal get _selectedGoal => WhatYourGoalView._goals[_currentIndex].goal;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return AuthPageLayout(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            context.localize(_GoalTexts.title),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TColor.black,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.localize(_GoalTexts.subtitle),
            textAlign: TextAlign.center,
            style: const TextStyle(color: TColor.gray, fontSize: 12),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: media.height * 0.65,
            child: CarouselSlider.builder(
              itemCount: WhatYourGoalView._goals.length,
              itemBuilder: (context, index, _) {
                final goal = WhatYourGoalView._goals[index];
                return _GoalCard(data: goal, imageWidth: media.width * 0.5);
              },
              options: CarouselOptions(
                enlargeCenterPage: true,
                viewportFraction: 0.75,
                aspectRatio: 3 / 4,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, _) => setState(() => _currentIndex = index),
              ),
            ),
          ),
          const SizedBox(height: 90),
          RoundButton(
            title: context.localize(_GoalTexts.confirm),
            onPressed: _onConfirmPressed,
            isEnabled: !_isSubmitting,
          ),
          if (_isSubmitting) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _onConfirmPressed() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      await context.authController
          .updateGoal(flow: widget.flow, goal: _selectedGoal);
      if (!mounted) return;
      context.push(AppRoute.welcome);
    } on AuthFailure {
      _showError(context.localize(_GoalTexts.submitError));
    } catch (_) {
      _showError(context.localize(_GoalTexts.submitError));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _GoalCardData {
  const _GoalCardData({
    required this.image,
    required this.goal,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final Goal goal;
  final LocalizedText title;
  final LocalizedText subtitle;
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.data, required this.imageWidth});

  final _GoalCardData data;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(data.image, width: imageWidth, fit: BoxFit.contain),
          const SizedBox(height: 24),
          Text(
            context.localize(data.title),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TColor.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(width: 40, height: 1, color: TColor.white),
          const SizedBox(height: 12),
          Text(
            context.localize(data.subtitle),
            textAlign: TextAlign.center,
            style: const TextStyle(color: TColor.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
