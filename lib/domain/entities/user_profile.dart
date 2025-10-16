enum Gender { male, female, other }

enum FitnessGoal { loseWeight, buildMuscle, endurance }

enum ExperienceLevel { beginner, intermediate, advanced }

enum WorkoutMode { home, gym }

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.level,
    required this.preferredMode,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String? name;
  final int age;
  final double heightCm;
  final double weightKg;
  final Gender gender;
  final FitnessGoal goal;
  final ExperienceLevel level;
  final WorkoutMode preferredMode;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? name,
    int? age,
    double? heightCm,
    double? weightKg,
    Gender? gender,
    FitnessGoal? goal,
    ExperienceLevel? level,
    WorkoutMode? preferredMode,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      preferredMode: preferredMode ?? this.preferredMode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.heightCm == heightCm &&
        other.weightKg == weightKg &&
        other.gender == gender &&
        other.goal == goal &&
        other.level == level &&
        other.preferredMode == preferredMode &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        age,
        heightCm,
        weightKg,
        gender,
        goal,
        level,
        preferredMode,
        createdAt,
        updatedAt,
      );
}

extension GenderX on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

extension FitnessGoalX on FitnessGoal {
  String get label {
    switch (this) {
      case FitnessGoal.loseWeight:
        return 'Lose Weight';
      case FitnessGoal.buildMuscle:
        return 'Build Muscle';
      case FitnessGoal.endurance:
        return 'Endurance';
    }
  }
}

extension ExperienceLevelX on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.advanced:
        return 'Advanced';
    }
  }
}

extension WorkoutModeX on WorkoutMode {
  String get label {
    switch (this) {
      case WorkoutMode.home:
        return 'Home';
      case WorkoutMode.gym:
        return 'Gym';
    }
  }
}
