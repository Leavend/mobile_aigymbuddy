// lib/view/login/what_your_goal_view.dart

import 'dart:developer' as developer;

import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/database/repositories/auth_repository.dart';
import 'package:aigymbuddy/database/type_converters.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  static const emailInUse = LocalizedText(
    english: 'This email address is already registered.',
    indonesian: 'Alamat email ini sudah terdaftar.',
  );
  static const incompleteProfile = LocalizedText(
    english: 'Please complete your profile details before continuing.',
    indonesian: 'Lengkapi detail profil Anda sebelum melanjutkan.',
  );
  static const genericError = LocalizedText(
    english: 'We could not create your account. Please try again.',
    indonesian: 'Kami tidak dapat membuat akun Anda. Silakan coba lagi.',
  );
}

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key, required this.signUpData});
  final SignUpData signUpData;

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
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
      goal: Goal.muscleGain,
      defaultLocation: LocationPref.gym,
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
      goal: Goal.maintain,
      defaultLocation: LocationPref.home,
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
      goal: Goal.fatLoss,
      defaultLocation: LocationPref.home,
    ),
  ];

  int _currentIndex = 0;

  Future<void> _onConfirm() async {
    final controller = context.read<AuthController>();
    final selected = _goals[_currentIndex];

    widget.signUpData
      ..goal = selected.goal
      ..level ??= Level.beginner
      ..location = selected.defaultLocation;

    try {
      await controller.register(widget.signUpData);
      if (!mounted) return;
      context.go(AppRoute.welcome);
    } on EmailAlreadyUsed {
      _showErrorMessage(_GoalTexts.emailInUse);
    } on IncompleteSignUpData {
      _showErrorMessage(_GoalTexts.incompleteProfile);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to register user',
        error: error,
        stackTrace: stackTrace,
      );
      _showErrorMessage(_GoalTexts.genericError);
    }
  }

  void _showErrorMessage(LocalizedText text) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.localize(text))));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final isProcessing = context.watch<AuthController>().isLoading;

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
                onPageChanged: (index, reason) =>
                    setState(() => _currentIndex = index),
              ),
            ),
          ),
          const SizedBox(height: 90),
          RoundButton(
            title: context.localize(_GoalTexts.confirm),
            onPressed: () => _onConfirm(),
            isEnabled: !isProcessing,
            isLoading: isProcessing,
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
    required this.goal,
    required this.defaultLocation,
  });

  final String image;
  final LocalizedText title;
  final LocalizedText subtitle;
  final Goal goal;
  final LocationPref defaultLocation;
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
          Image.asset(goal.image, width: imageWidth, fit: BoxFit.contain),
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
