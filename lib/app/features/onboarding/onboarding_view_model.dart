import 'package:flutter/foundation.dart';

import '../../../core/session_controller.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/upsert_user_profile.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel({
    required this.upsertUserProfile,
    required this.sessionController,
  });

  final UpsertUserProfile upsertUserProfile;
  final SessionController sessionController;

  String? name;
  int? age;
  double? heightCm;
  double? weightKg;
  Gender gender = Gender.other;
  FitnessGoal goal = FitnessGoal.buildMuscle;
  ExperienceLevel level = ExperienceLevel.beginner;
  WorkoutMode preferredMode = WorkoutMode.home;

  bool _isSaving = false;
  String? _errorMessage;

  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  void updateGender(Gender value) {
    gender = value;
    notifyListeners();
  }

  void updateGoal(FitnessGoal value) {
    goal = value;
    notifyListeners();
  }

  void updateLevel(ExperienceLevel value) {
    level = value;
    notifyListeners();
  }

  void updateMode(WorkoutMode value) {
    preferredMode = value;
    notifyListeners();
  }

  void setName(String? value) {
    name = value?.trim().isEmpty == true ? null : value?.trim();
  }

  void updateAge(int value) {
    age = value;
  }

  void updateHeight(double value) {
    heightCm = value;
  }

  void updateWeight(double value) {
    weightKg = value;
  }

  Future<bool> submit() async {
    if (age == null || heightCm == null || weightKg == null) {
      _errorMessage = 'Lengkapi data usia, tinggi, dan berat badan.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now().toUtc();
      final profile = UserProfile(
        id: 0,
        name: name,
        age: age!,
        heightCm: heightCm!,
        weightKg: weightKg!,
        gender: gender,
        goal: goal,
        level: level,
        preferredMode: preferredMode,
        createdAt: now,
        updatedAt: now,
      );
      await upsertUserProfile(profile);
      sessionController.setOnboarded(true);
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to save profile: $error\n$stackTrace');
      _errorMessage = 'Gagal menyimpan profil. Silakan coba lagi.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
