import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/view/login/models/onboarding_draft.dart';
import 'package:aigymbuddy/view/shared/repositories/profile_repository.dart';
import 'package:aigymbuddy/view/shared/repositories/tracking_repository.dart';
import 'package:flutter/foundation.dart';

import '../../shared/models/user_profile.dart' as domain;

enum GoalSubmissionStatus {
  onboardingCompleted,
  profileUpdated,
  alreadyInProgress,
  failure,
}

class GoalSubmissionResult {
  const GoalSubmissionResult(this.status, {this.draft, this.error});

  const GoalSubmissionResult.onboarding(OnboardingDraft draft)
      : this(GoalSubmissionStatus.onboardingCompleted, draft: draft);
  const GoalSubmissionResult.updated(OnboardingDraft draft)
      : this(GoalSubmissionStatus.profileUpdated, draft: draft);
  const GoalSubmissionResult.inProgress()
      : this(GoalSubmissionStatus.alreadyInProgress);

  final GoalSubmissionStatus status;
  final OnboardingDraft? draft;
  final Object? error;
}

class GoalSelectionController extends ChangeNotifier {
  GoalSelectionController({required OnboardingDraft draft}) : _draft = draft {
    _goalIndex = _goalIndexFor(draft.goal);
    _selectedLevel = draft.level ?? domain.ExperienceLevel.beginner;
    _selectedMode = draft.mode ?? domain.WorkoutMode.gym;
  }

  OnboardingDraft _draft;
  late int _goalIndex;
  late domain.ExperienceLevel _selectedLevel;
  late domain.WorkoutMode _selectedMode;
  bool _isSaving = false;

  OnboardingDraft get draft => _draft;
  int get goalIndex => _goalIndex;
  domain.ExperienceLevel get selectedLevel => _selectedLevel;
  domain.WorkoutMode get selectedMode => _selectedMode;
  bool get isSaving => _isSaving;

  void updateDraft(OnboardingDraft draft) {
    _draft = draft;
    _goalIndex = _goalIndexFor(draft.goal);
    _selectedLevel = draft.level ?? domain.ExperienceLevel.beginner;
    _selectedMode = draft.mode ?? domain.WorkoutMode.gym;
    notifyListeners();
  }

  void updateGoalIndex(int index) {
    if (index == _goalIndex) return;
    _goalIndex = index;
    _draft = _draft.copyWith(goal: goalCards[index].goal);
    notifyListeners();
  }

  void selectLevel(domain.ExperienceLevel level) {
    if (_selectedLevel == level) return;
    _selectedLevel = level;
    _draft = _draft.copyWith(level: level);
    notifyListeners();
  }

  void selectMode(domain.WorkoutMode mode) {
    if (_selectedMode == mode) return;
    _selectedMode = mode;
    _draft = _draft.copyWith(mode: mode);
    notifyListeners();
  }

  Future<GoalSubmissionResult> submit({
    required ProfileRepository profileRepository,
    required TrackingRepository trackingRepository,
    required AuthService authService,
    required ProfileFormMode mode,
  }) async {
    if (_isSaving) {
      return const GoalSubmissionResult.inProgress();
    }

    final selectedGoal = goalCards[_goalIndex].goal;
    final updatedDraft = _draft.copyWith(
      goal: selectedGoal,
      level: _selectedLevel,
      mode: _selectedMode,
    );

    _draft = updatedDraft;
    _setSaving(true);

    try {
      final profile = updatedDraft.toUserProfile();
      await profileRepository.saveProfile(profile);

      if (mode == ProfileFormMode.onboarding) {
        final weight = updatedDraft.weightKg;
        if (weight != null) {
          await trackingRepository.addBodyWeight(weight);
        }
        await authService.setHasCredentials(true);
        return GoalSubmissionResult.onboarding(updatedDraft);
      } else {
        return GoalSubmissionResult.updated(updatedDraft);
      }
    } catch (error) {
      return GoalSubmissionResult(GoalSubmissionStatus.failure, error: error);
    } finally {
      _setSaving(false);
    }
  }

  static List<GoalCardData> get cards => goalCards;

  void _setSaving(bool value) {
    if (_isSaving == value) return;
    _isSaving = value;
    notifyListeners();
  }

  int _goalIndexFor(domain.FitnessGoal? goal) {
    if (goal == null) return 0;
    final index = goalCards.indexWhere((element) => element.goal == goal);
    return index == -1 ? 0 : index;
  }
}

class GoalCardData {
  const GoalCardData({
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

const goalCards = [
  GoalCardData(
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
  GoalCardData(
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
  GoalCardData(
    goal: domain.FitnessGoal.loseWeight,
    image: 'assets/img/goal_3.png',
    title: LocalizedText(
      english: 'Lose Fat',
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
