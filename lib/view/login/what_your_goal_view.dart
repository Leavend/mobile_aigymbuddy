// lib/view/login/what_your_goal_view.dart

import 'package:aigymbuddy/app/app_state.dart';
import 'package:aigymbuddy/app/dependencies.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/goal_selection_controller.dart';
import 'models/onboarding_draft.dart';
import 'package:aigymbuddy/view/shared/models/user_profile.dart' as domain;
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
  static const experienceSection = LocalizedText(
    english: 'Experience Level',
    indonesian: 'Tingkat Pengalaman',
  );
  static const modeSection = LocalizedText(
    english: 'Preferred Training Mode',
    indonesian: 'Mode Latihan Favorit',
  );
  static const profileUpdated = LocalizedText(
    english: 'Profile updated successfully.',
    indonesian: 'Profil berhasil diperbarui.',
  );
  static const saveFailed = LocalizedText(
    english: 'Failed to save profile. Please try again.',
    indonesian: 'Gagal menyimpan profil. Silakan coba lagi.',
  );
}

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({
    super.key,
    ProfileFormArguments? args,
  }) : args = args ?? const ProfileFormArguments(draft: OnboardingDraft());

  final ProfileFormArguments args;

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  late final GoalSelectionController _controller;
  final _carouselController = CarouselSliderController();

  ProfileFormMode get _mode => widget.args.mode;

  @override
  void initState() {
    super.initState();
    _controller = GoalSelectionController(draft: widget.args.draft);
  }

  @override
  void didUpdateWidget(covariant WhatYourGoalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.args.draft != widget.args.draft) {
      _controller.updateDraft(widget.args.draft);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _carouselController.jumpToPage(_controller.goalIndex);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final layoutWidth = media.width < 420 ? media.width : 420;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final confirmLabel = context.localize(
      _mode == ProfileFormMode.edit ? _GoalTexts.save : _GoalTexts.confirm,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return AuthPageLayout(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                _CarouselSection(
                  controller: _carouselController,
                  goalIndex: _controller.goalIndex,
                  imageWidth: layoutWidth * 0.5,
                  maxHeight: media.height * 0.5,
                  onGoalChanged: _controller.updateGoalIndex,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(
                    context.localize(_GoalTexts.experienceSection)),
                const SizedBox(height: 8),
                _buildLevelChips(),
                const SizedBox(height: 24),
                _buildSectionTitle(context.localize(_GoalTexts.modeSection)),
                const SizedBox(height: 8),
                _buildModeChips(),
                const SizedBox(height: 32),
                RoundButton(
                  title: confirmLabel,
                  onPressed: _onConfirm,
                  isEnabled: !_controller.isSaving,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
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
          selected: _controller.selectedLevel == level,
          onSelected: (_) => _controller.selectLevel(level),
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
          selected: _controller.selectedMode == mode,
          onSelected: (_) => _controller.selectMode(mode),
        );
      }).toList(),
    );
  }

  Future<void> _onConfirm() async {
    final deps = AppDependencies.of(context);
    final result = await _controller.submit(
      profileRepository: deps.profileRepository,
      trackingRepository: deps.trackingRepository,
      authService: AuthService.instance,
      mode: _mode,
    );

    if (!mounted) return;

    switch (result.status) {
      case GoalSubmissionStatus.alreadyInProgress:
        return;
      case GoalSubmissionStatus.onboardingCompleted:
        AppStateScope.of(context).updateHasProfile(true);
        if (!mounted) return;
        context.go(
          AppRoute.welcome,
          extra: WelcomeArgs(displayName: result.draft?.displayName),
        );
      case GoalSubmissionStatus.profileUpdated:
        context.go(AppRoute.profile);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
                content: Text(context.localize(_GoalTexts.profileUpdated))),
          );
      case GoalSubmissionStatus.failure:
        final errorText = result.error?.toString();
        final message = (errorText != null && errorText.trim().isNotEmpty)
            ? errorText
            : context.localize(_GoalTexts.saveFailed);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

class _CarouselSection extends StatelessWidget {
  const _CarouselSection({
    required this.controller,
    required this.goalIndex,
    required this.imageWidth,
    required this.maxHeight,
    required this.onGoalChanged,
  });

  static const _maxCarouselHeight = 420.0;

  final CarouselSliderController controller;
  final int goalIndex;
  final double imageWidth;
  final double maxHeight;
  final ValueChanged<int> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight =
        maxHeight.clamp(280.0, _maxCarouselHeight).toDouble();
    return SizedBox(
      height: resolvedHeight,
      child: CarouselSlider.builder(
        carouselController: controller,
        itemCount: GoalSelectionController.cards.length,
        itemBuilder: (context, index, _) {
          final goal = GoalSelectionController.cards[index];
          return _GoalCard(
            goal: goal,
            imageWidth: imageWidth,
          );
        },
        options: CarouselOptions(
          enlargeCenterPage: true,
          viewportFraction: 0.75,
          aspectRatio: 3 / 4,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          initialPage: goalIndex,
          onPageChanged: (index, _) => onGoalChanged(index),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.imageWidth});

  final GoalCardData goal;
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
