import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/type_converters.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.gender,
    this.dob,
    this.heightCm,
    this.level,
    this.goal,
    this.locationPref,
  });

  factory AuthUser.fromData({required User user, UserProfile? profile}) {
    return AuthUser(
      id: user.id,
      email: user.email,
      displayName: profile?.displayName ?? user.email,
      gender: profile?.gender,
      dob: profile?.dob,
      heightCm: profile?.heightCm,
      level: profile?.level,
      goal: profile?.goal,
      locationPref: profile?.locationPref,
    );
  }

  final String id;
  final String email;
  final String displayName;
  final Gender? gender;
  final DateTime? dob;
  final double? heightCm;
  final Level? level;
  final Goal? goal;
  final LocationPref? locationPref;
}
