import 'package:drift/drift.dart' show Value;

import '../../domain/entities/user_profile.dart' as domain;
import '../db/app_database.dart';

class UserProfileMapper {
  const UserProfileMapper();

  domain.UserProfile? toDomain(UserProfile? model) {
    if (model == null) {
      return null;
    }

    return domain.UserProfile(
      id: model.id,
      name: model.name,
      age: model.age,
      heightCm: model.heightCm,
      weightKg: model.weightKg,
      gender: _mapGenderFromDb(model.gender),
      goal: _mapGoalFromDb(model.goal),
      level: _mapLevelFromDb(model.level),
      preferredMode: _mapModeFromDb(model.preferredMode),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  UserProfilesCompanion toCompanion(domain.UserProfile profile) {
    return UserProfilesCompanion(
      id: Value(profile.id == 0 ? null : profile.id),
      name: Value(profile.name),
      age: Value(profile.age),
      heightCm: Value(profile.heightCm),
      weightKg: Value(profile.weightKg),
      gender: Value(_mapGenderToDb(profile.gender)),
      goal: Value(_mapGoalToDb(profile.goal)),
      level: Value(_mapLevelToDb(profile.level)),
      preferredMode: Value(_mapModeToDb(profile.preferredMode)),
      updatedAt: Value(DateTime.now().toUtc()),
    );
  }

  domain.Gender _mapGenderFromDb(String value) {
    switch (value) {
      case 'male':
        return domain.Gender.male;
      case 'female':
        return domain.Gender.female;
      default:
        return domain.Gender.other;
    }
  }

  String _mapGenderToDb(domain.Gender gender) {
    switch (gender) {
      case domain.Gender.male:
        return 'male';
      case domain.Gender.female:
        return 'female';
      case domain.Gender.other:
        return 'other';
    }
  }

  domain.FitnessGoal _mapGoalFromDb(String value) {
    switch (value) {
      case 'lose_weight':
        return domain.FitnessGoal.loseWeight;
      case 'endurance':
        return domain.FitnessGoal.endurance;
      case 'build_muscle':
      default:
        return domain.FitnessGoal.buildMuscle;
    }
  }

  String _mapGoalToDb(domain.FitnessGoal goal) {
    switch (goal) {
      case domain.FitnessGoal.loseWeight:
        return 'lose_weight';
      case domain.FitnessGoal.buildMuscle:
        return 'build_muscle';
      case domain.FitnessGoal.endurance:
        return 'endurance';
    }
  }

  domain.ExperienceLevel _mapLevelFromDb(String value) {
    switch (value) {
      case 'beginner':
        return domain.ExperienceLevel.beginner;
      case 'advanced':
        return domain.ExperienceLevel.advanced;
      case 'intermediate':
      default:
        return domain.ExperienceLevel.intermediate;
    }
  }

  String _mapLevelToDb(domain.ExperienceLevel level) {
    switch (level) {
      case domain.ExperienceLevel.beginner:
        return 'beginner';
      case domain.ExperienceLevel.intermediate:
        return 'intermediate';
      case domain.ExperienceLevel.advanced:
        return 'advanced';
    }
  }

  domain.WorkoutMode _mapModeFromDb(String value) {
    switch (value) {
      case 'home':
        return domain.WorkoutMode.home;
      case 'gym':
      default:
        return domain.WorkoutMode.gym;
    }
  }

  String _mapModeToDb(domain.WorkoutMode mode) {
    switch (mode) {
      case domain.WorkoutMode.home:
        return 'home';
      case domain.WorkoutMode.gym:
        return 'gym';
    }
  }
}
