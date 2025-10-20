// lib/features/auth/domain/entities/user_profile.dart

import 'package:aigymbuddy/common/domain/enums.dart';

/// Immutable snapshot of the user's fitness profile stored locally.
class UserProfile {
  const UserProfile({
    required this.userId,
    required this.displayName,
    required this.gender,
    required this.heightCm,
    required this.level,
    required this.goal,
    required this.locationPref,
    this.dob,
  });

  final String userId;
  final String displayName;
  final Gender gender;
  final DateTime? dob;
  final double heightCm;
  final Level level;
  final Goal goal;
  final LocationPref locationPref;

  UserProfile copyWith({
    String? displayName,
    Gender? gender,
    DateTime? dob,
    double? heightCm,
    Level? level,
    Goal? goal,
    LocationPref? locationPref,
  }) {
    return UserProfile(
      userId: userId,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      heightCm: heightCm ?? this.heightCm,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      locationPref: locationPref ?? this.locationPref,
    );
  }
}
