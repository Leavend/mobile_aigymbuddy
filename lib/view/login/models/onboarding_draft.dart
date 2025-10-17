import 'package:aigymbuddy/view/shared/models/user_profile.dart' as domain;

enum ProfileFormMode { onboarding, edit }

class OnboardingDraft {
  const OnboardingDraft({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.age,
    this.heightCm,
    this.weightKg,
    this.goal,
    this.level,
    this.mode,
  });

  factory OnboardingDraft.fromProfile(domain.UserProfile profile) {
    final name = profile.name?.trim();
    String? first;
    String? last;
    if (name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      first = parts.isNotEmpty ? parts.first : null;
      if (parts.length > 1) {
        last = parts.sublist(1).join(' ');
      }
    }

    return OnboardingDraft(
      id: profile.id,
      firstName: first,
      lastName: last,
      email: null,
      gender: profile.gender,
      dateOfBirth: DateTime.now().subtract(Duration(days: profile.age * 365)),
      age: profile.age,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      goal: profile.goal,
      level: profile.level,
      mode: profile.mode,
    );
  }

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final domain.Gender? gender;
  final DateTime? dateOfBirth;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final domain.FitnessGoal? goal;
  final domain.ExperienceLevel? level;
  final domain.WorkoutMode? mode;

  String? get displayName {
    final buffer = StringBuffer();
    if (firstName != null && firstName!.trim().isNotEmpty) {
      buffer.write(firstName!.trim());
    }
    if (lastName != null && lastName!.trim().isNotEmpty) {
      if (buffer.isNotEmpty) {
        buffer.write(' ');
      }
      buffer.write(lastName!.trim());
    }
    final result = buffer.toString();
    return result.isEmpty ? null : result;
  }

  OnboardingDraft copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    domain.Gender? gender,
    DateTime? dateOfBirth,
    int? age,
    double? heightCm,
    double? weightKg,
    domain.FitnessGoal? goal,
    domain.ExperienceLevel? level,
    domain.WorkoutMode? mode,
  }) {
    return OnboardingDraft(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      mode: mode ?? this.mode,
    );
  }

  OnboardingDraft updateWithDob(DateTime dob) {
    return copyWith(
      dateOfBirth: dob,
      age: _calculateAge(dob),
    );
  }

  domain.UserProfile toUserProfile() {
    final gender = this.gender;
    final age = this.age;
    final height = heightCm;
    final weight = weightKg;
    final goal = this.goal;
    final level = this.level;
    final mode = this.mode;

    if (gender == null ||
        age == null ||
        height == null ||
        weight == null ||
        goal == null ||
        level == null ||
        mode == null) {
      throw StateError('Onboarding draft is incomplete.');
    }

    return domain.UserProfile(
      id: id,
      name: displayName,
      age: age,
      heightCm: height,
      weightKg: weight,
      gender: gender,
      goal: goal,
      level: level,
      mode: mode,
    );
  }

  static int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    var age = today.year - dob.year;
    final hasHadBirthdayThisYear =
        today.month > dob.month || (today.month == dob.month && today.day >= dob.day);
    if (!hasHadBirthdayThisYear) {
      age -= 1;
    }
    return age;
  }
}

class ProfileFormArguments {
  const ProfileFormArguments({
    required this.draft,
    this.mode = ProfileFormMode.onboarding,
  });

  final OnboardingDraft draft;
  final ProfileFormMode mode;

  ProfileFormArguments copyWith({OnboardingDraft? draft, ProfileFormMode? mode}) {
    return ProfileFormArguments(
      draft: draft ?? this.draft,
      mode: mode ?? this.mode,
    );
  }
}

class WelcomeArgs {
  const WelcomeArgs({this.displayName});

  final String? displayName;
}
