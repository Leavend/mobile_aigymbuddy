import 'package:aigymbuddy/app/app_state.dart';
import 'package:aigymbuddy/app/dependencies.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/view/shared/models/user_profile.dart' as domain;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/onboarding_draft.dart';
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
  static const save = LocalizedText(
    english: 'Save',
    indonesian: 'Simpan',
  );
}

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key, required this.args});

  final ProfileFormArguments args;

  static const _goals = [
    _GoalCardData(
      goal: domain.FitnessGoal.buildMuscle,
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
      goal: domain.FitnessGoal.endurance,
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
      goal: domain.FitnessGoal.loseWeight,
      image: 'assets/img/goal_3.png',
      title: LocalizedText(english: 'Lose Fat', indonesian: 'Turunkan Lemak'),
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
  late OnboardingDraft _draft;
  late int _goalIndex;
  late domain.ExperienceLevel _selectedLevel;
  late domain.WorkoutMode _selectedMode;
  bool _saving = false;

  ProfileFormMode get _mode => widget.args.mode;

  @override
  void initState() {
    super.initState();
    _draft = widget.args.draft;
    _goalIndex = _goalIndexFor(_draft.goal);
    _selectedLevel = _draft.level ?? domain.ExperienceLevel.beginner;
    _selectedMode = _draft.mode ?? domain.WorkoutMode.gym;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final confirmLabel = context.localize(
      _mode == ProfileFormMode.edit ? _GoalTexts.save : _GoalTexts.confirm,
    );

    return AuthPageLayout(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
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
            const SizedBox(height: 24),
            SizedBox(
              height: media.height * 0.5,
              child: CarouselSlider.builder(
                itemCount: WhatYourGoalView._goals.length,
                itemBuilder: (context, index, _) {
                  final goal = WhatYourGoalView._goals[index];
                  return _GoalCard(goal: goal, imageWidth: media.width * 0.5);
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  viewportFraction: 0.75,
                  aspectRatio: 3 / 4,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  initialPage: _goalIndex,
                  onPageChanged: (index, _) {
                    setState(() {
                      _goalIndex = index;
                      _draft = _draft.copyWith(
                        goal: WhatYourGoalView._goals[index].goal,
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Experience Level'),
            const SizedBox(height: 8),
            _buildLevelChips(),
            const SizedBox(height: 24),
            _buildSectionTitle('Preferred Training Mode'),
            const SizedBox(height: 8),
            _buildModeChips(),
            const SizedBox(height: 32),
            RoundButton(
              title: confirmLabel,
              // FIX: Removed the ternary operator because `isEnabled` handles the disabled state.
              onPressed: () => _onConfirm(),
              isEnabled: !_saving,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLevelChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: domain.ExperienceLevel.values.map((level) {
        final label = domain.describeLevel(level);
        return ChoiceChip(
          label: Text(label),
          selected: _selectedLevel == level,
          onSelected: (_) {
            setState(() {
              _selectedLevel = level;
              _draft = _draft.copyWith(level: level);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildModeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: domain.WorkoutMode.values.map((mode) {
        final label = domain.describeMode(mode);
        return ChoiceChip(
          label: Text(label),
          selected: _selectedMode == mode,
          onSelected: (_) {
            setState(() {
              _selectedMode = mode;
              _draft = _draft.copyWith(mode: mode);
            });
          },
        );
      }).toList(),
    );
  }

  int _goalIndexFor(domain.FitnessGoal? goal) {
    if (goal == null) return 0;
    return WhatYourGoalView._goals
        .indexWhere((element) => element.goal == goal)
        .clamp(0, WhatYourGoalView._goals.length - 1);
  }

  Future<void> _onConfirm() async {
    // Return early if already saving to prevent multiple submissions.
    if (_saving) return;

    final deps = AppDependencies.of(context);
    final profileRepository = deps.profileRepository;
    final trackingRepository = deps.trackingRepository;

    final selectedGoal = WhatYourGoalView._goals[_goalIndex].goal;
    final updatedDraft = _draft.copyWith(
      goal: selectedGoal,
      level: _selectedLevel,
      mode: _selectedMode,
    );

    setState(() {
      _saving = true;
      _draft = updatedDraft;
    });

    try {
      final profile = updatedDraft.toUserProfile();
      await profileRepository.saveProfile(profile);

      if (_mode == ProfileFormMode.onboarding) {
        final weight = updatedDraft.weightKg;
        if (weight != null) {
          await trackingRepository.addBodyWeight(weight);
        }
        await AuthService.instance.setHasCredentials(true);
        if (!mounted) return;
        AppStateScope.of(context).updateHasProfile(true);
        context.go(
          AppRoute.welcome,
          extra: WelcomeArgs(displayName: updatedDraft.displayName),
        );
      } else {
        if (!mounted) return;
        context.go(AppRoute.profile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _GoalCardData {
  const _GoalCardData({
    required this.goal,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final domain.FitnessGoal goal;
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