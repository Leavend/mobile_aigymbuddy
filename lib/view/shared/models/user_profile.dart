import 'package:meta/meta.dart';

enum Gender { male, female, other }

enum FitnessGoal { loseWeight, buildMuscle, endurance }

enum ExperienceLevel { beginner, intermediate, advanced }

enum WorkoutMode { home, gym }

@immutable
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
  })  : assert(age > 0, 'Age must be greater than zero'),
        assert(heightCm > 0, 'Height must be greater than zero'),
        assert(weightKg > 0, 'Weight must be greater than zero');

  final int? id;
  final String? name;
  final int age;
  final double heightCm;
  final double weightKg;
  final Gender gender;
  final FitnessGoal goal;
  final ExperienceLevel level;
  final WorkoutMode mode;

  double get bodyMassIndex {
    final heightInMeters = heightCm / 100;
    return weightKg / (heightInMeters * heightInMeters);
  }

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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserProfile &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            age == other.age &&
            heightCm == other.heightCm &&
            weightKg == other.weightKg &&
            gender == other.gender &&
            goal == other.goal &&
            level == other.level &&
            mode == other.mode;
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
        mode,
      );

  @override
  String toString() =>
      'UserProfile(id: $id, name: $name, goal: ${goal.name}, level: ${level.name})';
}

extension GenderDbMapper on Gender {
  static const Map<Gender, String> _dbValues = {
    Gender.male: 'male',
    Gender.female: 'female',
    Gender.other: 'other',
  };

  static const Map<Gender, String> _descriptions = {
    Gender.male: 'Male',
    Gender.female: 'Female',
    Gender.other: 'Other',
  };

  String get dbValue => _dbValues[this]!;

  String get description => _descriptions[this]!;

  static Gender fromDb(String value) {
    return _dbValues.entries
        .firstWhere(
          (entry) => entry.value == value,
          orElse: () => const MapEntry(Gender.other, 'other'),
        )
        .key;
  }
}

extension FitnessGoalMapper on FitnessGoal {
  static const Map<FitnessGoal, String> _dbValues = {
    FitnessGoal.loseWeight: 'lose_weight',
    FitnessGoal.buildMuscle: 'build_muscle',
    FitnessGoal.endurance: 'endurance',
  };

  static const Map<FitnessGoal, String> _descriptions = {
    FitnessGoal.loseWeight: 'Lose Weight',
    FitnessGoal.buildMuscle: 'Build Muscle',
    FitnessGoal.endurance: 'Endurance',
  };

  String get dbValue => _dbValues[this]!;

  String get description => _descriptions[this]!;

  static FitnessGoal fromDb(String value) {
    return _dbValues.entries
        .firstWhere(
          (entry) => entry.value == value,
          orElse: () => const MapEntry(FitnessGoal.endurance, 'endurance'),
        )
        .key;
  }
}

extension ExperienceLevelMapper on ExperienceLevel {
  static const Map<ExperienceLevel, String> _dbValues = {
    ExperienceLevel.beginner: 'beginner',
    ExperienceLevel.intermediate: 'intermediate',
    ExperienceLevel.advanced: 'advanced',
  };

  static const Map<ExperienceLevel, String> _descriptions = {
    ExperienceLevel.beginner: 'Beginner',
    ExperienceLevel.intermediate: 'Intermediate',
    ExperienceLevel.advanced: 'Advanced',
  };

  String get dbValue => _dbValues[this]!;

  String get description => _descriptions[this]!;

  static ExperienceLevel fromDb(String value) {
    return _dbValues.entries
        .firstWhere(
          (entry) => entry.value == value,
          orElse: () => const MapEntry(ExperienceLevel.intermediate, 'intermediate'),
        )
        .key;
  }
}

extension WorkoutModeMapper on WorkoutMode {
  static const Map<WorkoutMode, String> _dbValues = {
    WorkoutMode.home: 'home',
    WorkoutMode.gym: 'gym',
  };

  static const Map<WorkoutMode, String> _descriptions = {
    WorkoutMode.home: 'Home',
    WorkoutMode.gym: 'Gym',
  };

  String get dbValue => _dbValues[this]!;

  String get description => _descriptions[this]!;

  static WorkoutMode fromDb(String value) {
    return _dbValues.entries
        .firstWhere(
          (entry) => entry.value == value,
          orElse: () => const MapEntry(WorkoutMode.gym, 'gym'),
        )
        .key;
  }
}

@Deprecated('Use GenderDbMapper.fromDb instead')
Gender genderFromDb(String value) => GenderDbMapper.fromDb(value);

@Deprecated('Use gender.dbValue instead')
String genderToDb(Gender gender) => gender.dbValue;

@Deprecated('Use FitnessGoalMapper.fromDb instead')
FitnessGoal goalFromDb(String value) => FitnessGoalMapper.fromDb(value);

@Deprecated('Use goal.dbValue instead')
String goalToDb(FitnessGoal goal) => goal.dbValue;

@Deprecated('Use ExperienceLevelMapper.fromDb instead')
ExperienceLevel levelFromDb(String value) =>
    ExperienceLevelMapper.fromDb(value);

@Deprecated('Use level.dbValue instead')
String levelToDb(ExperienceLevel level) => level.dbValue;

@Deprecated('Use WorkoutModeMapper.fromDb instead')
WorkoutMode modeFromDb(String value) => WorkoutModeMapper.fromDb(value);

@Deprecated('Use mode.dbValue instead')
String modeToDb(WorkoutMode mode) => mode.dbValue;

String describeGender(Gender gender) => gender.description;

String describeGoal(FitnessGoal goal) => goal.description;

String describeLevel(ExperienceLevel level) => level.description;

String describeMode(WorkoutMode mode) => mode.description;
