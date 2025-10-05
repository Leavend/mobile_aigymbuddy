// lib/view/login/what_your_goal_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_state.dart';
import 'package:aigymbuddy/common_widget/app_language_toggle.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView>
    with AppLanguageState<WhatYourGoalView> {
  final CarouselSliderController _controller = CarouselSliderController();

  static const _title = LocalizedText(
    english: 'What is your goal?',
    indonesian: 'Apa tujuanmu?',
  );
  static const _subtitle = LocalizedText(
    english: 'It will help us to choose a best program for you',
    indonesian: 'Ini membantu kami memilih program terbaik untukmu',
  );
  static const _confirmText = LocalizedText(
    english: 'Confirm',
    indonesian: 'Konfirmasi',
  );

  static const List<_GoalCardData> _goals = [
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
      title: LocalizedText(
        english: 'Lose a Fat',
        indonesian: 'Turunkan Lemak',
      ),
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

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: AppLanguageToggle(
                  selectedLanguage: language,
                  onSelected: updateLanguage,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localized(_title),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                localized(_subtitle),
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: _goals.length,
                  itemBuilder: (context, index, realIdx) {
                    final goal = _goals[index];
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            goal.image,
                            width: media.width * 0.5,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            localized(goal.title),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(width: 40, height: 1, color: TColor.white),
                          const SizedBox(height: 12),
                          Text(
                            localized(goal.subtitle),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.white, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    viewportFraction: 0.75,
                    aspectRatio: 3 / 4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RoundButton(
                title: localized(_confirmText),
                onPressed: () {
                  context.push(AppRoute.welcome);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
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
