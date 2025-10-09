import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/auth_page_layout.dart';

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
}

class WhatYourGoalView extends StatelessWidget {
  const WhatYourGoalView({super.key});

  static const _goals = [
    _GoalCardData(
      image: 'assets/img/goal_1.png',
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
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return AuthPageLayout(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
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
            height: media.height * 0.55,
            child: CarouselSlider.builder(
              itemCount: _goals.length,
              itemBuilder: (context, index, _) {
                final goal = _goals[index];
                return _GoalCard(goal: goal, imageWidth: media.width * 0.5);
              },
              options: CarouselOptions(
                enlargeCenterPage: true,
                viewportFraction: 0.75,
                aspectRatio: 3 / 4,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
            ),
          ),
          const SizedBox(height: 24),
          RoundButton(
            title: context.localize(_GoalTexts.confirm),
            onPressed: () => context.push(AppRoute.welcome),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _GoalCardData {
  const _GoalCardData({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final LocalizedText title;
  final LocalizedText subtitle;
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.imageWidth});

  final _GoalCardData goal;
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
          Image.asset(
            goal.image,
            width: imageWidth,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            context.localize(goal.title),
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
            context.localize(goal.subtitle),
            textAlign: TextAlign.center,
            style: const TextStyle(color: TColor.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
