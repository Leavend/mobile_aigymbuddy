enum Gender { male, female, other }

enum FitnessGoal { loseWeight, buildMuscle, endurance }

enum ExperienceLevel { beginner, intermediate, advanced }

enum WorkoutMode { home, gym }

class UserProfile {
  const UserProfile({
    this.id,
    this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.level,
    required this.mode,
  });

  final int? id;
  final String? name;
  final int age;
  final double heightCm;
  final double weightKg;
  final Gender gender;
  final FitnessGoal goal;
  final ExperienceLevel level;
  final WorkoutMode mode;

  UserProfile copyWith({
    int? id,
    String? name,
    int? age,
    double? heightCm,
    double? weightKg,
    Gender? gender,
    FitnessGoal? goal,
    ExperienceLevel? level,
    WorkoutMode? mode,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      mode: mode ?? this.mode,
    );
  }
}

Gender genderFromDb(String value) {
  switch (value) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    default:
      return Gender.other;
  }
}

String genderToDb(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'male';
    case Gender.female:
      return 'female';
    case Gender.other:
      return 'other';
  }
}

FitnessGoal goalFromDb(String value) {
  switch (value) {
    case 'lose_weight':
      return FitnessGoal.loseWeight;
    case 'build_muscle':
      return FitnessGoal.buildMuscle;
    default:
      return FitnessGoal.endurance;
  }
}

String goalToDb(FitnessGoal goal) {
  switch (goal) {
    case FitnessGoal.loseWeight:
      return 'lose_weight';
    case FitnessGoal.buildMuscle:
      return 'build_muscle';
    case FitnessGoal.endurance:
      return 'endurance';
  }
}

ExperienceLevel levelFromDb(String value) {
  switch (value) {
    case 'beginner':
      return ExperienceLevel.beginner;
    case 'advanced':
      return ExperienceLevel.advanced;
    default:
      return ExperienceLevel.intermediate;
  }
}

String levelToDb(ExperienceLevel level) {
  switch (level) {
    case ExperienceLevel.beginner:
      return 'beginner';
    case ExperienceLevel.intermediate:
      return 'intermediate';
    case ExperienceLevel.advanced:
      return 'advanced';
  }
}

WorkoutMode modeFromDb(String value) {
  switch (value) {
    case 'home':
      return WorkoutMode.home;
    case 'gym':
    default:
      return WorkoutMode.gym;
  }
}

String modeToDb(WorkoutMode mode) {
  switch (mode) {
    case WorkoutMode.home:
      return 'home';
    case WorkoutMode.gym:
      return 'gym';
  }
}

String describeGender(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'Male';
    case Gender.female:
      return 'Female';
    case Gender.other:
      return 'Other';
  }
}

String describeGoal(FitnessGoal goal) {
  switch (goal) {
    case FitnessGoal.loseWeight:
      return 'Lose Weight';
    case FitnessGoal.buildMuscle:
      return 'Build Muscle';
    case FitnessGoal.endurance:
      return 'Endurance';
  }
}

String describeLevel(ExperienceLevel level) {
  switch (level) {
    case ExperienceLevel.beginner:
      return 'Beginner';
    case ExperienceLevel.intermediate:
      return 'Intermediate';
    case ExperienceLevel.advanced:
      return 'Advanced';
  }
}

String describeMode(WorkoutMode mode) {
  switch (mode) {
    case WorkoutMode.home:
      return 'Home';
    case WorkoutMode.gym:
      return 'Gym';
  }
}
