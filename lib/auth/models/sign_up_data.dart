import 'package:aigymbuddy/database/type_converters.dart';

/// Data carrier for the multi-step registration flow.
class SignUpData {
  SignUpData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Gender? gender;
  DateTime? dob;
  double? weightKg;
  double? heightCm;

  Level? level;
  Goal? goal;
  LocationPref? location;

  String get displayName => '$firstName $lastName'.trim();
}
