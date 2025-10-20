// lib/auth/registration_flow.dart

class SignUpData {
  String firstName;
  String lastName;
  String email;
  String password; // simpan sementara; nanti di-hash saat commit

  // diisi di complete_profile
  String? gender;      // 'male' | 'female' (samakan dengan enum DB kamu)
  DateTime? dob;
  double? weightKg;
  double? heightCm;

  // diisi di goal view (atau nanti)
  String? level;       // 'beginner' | 'intermediate' | 'advanced'
  String? goal;        // 'fat_loss' | 'muscle_gain' | 'maintain'
  String? location;    // 'home' | 'gym'

  SignUpData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}
