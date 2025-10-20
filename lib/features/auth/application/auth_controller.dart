// lib/features/auth/application/auth_controller.dart

import 'package:aigymbuddy/common/domain/enums.dart';

import '../domain/entities/user_profile.dart';
import '../domain/errors/auth_failures.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/session_repository.dart';
import 'models/sign_up_flow_state.dart';

class AuthController {
  AuthController({
    required AuthRepository authRepository,
    required SessionRepository sessionRepository,
  })  : _authRepository = authRepository,
        _sessionRepository = sessionRepository;

  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;

  Future<SignUpFlowState> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final displayName = _buildDisplayName(firstName, lastName);
    final user = await _authRepository.register(
      email: email,
      password: password,
      displayName: displayName,
    );

    await _sessionRepository.persistActiveUser(user.id);

    return SignUpFlowState(
      userId: user.id,
      email: user.email,
      displayName: displayName,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.login(email: email, password: password);
    await _sessionRepository.persistActiveUser(user.id);
    final profile = await _authRepository.loadProfile(user.id);
    if (profile != null) {
      await _sessionRepository.setOnboardingComplete(true);
    }
  }

  Future<void> saveProfile({
    required SignUpFlowState flow,
    required Gender gender,
    DateTime? dob,
    required double heightCm,
    required double weightKg,
    Level level = Level.beginner,
    LocationPref locationPref = LocationPref.home,
  }) async {
    if (flow.userId.isEmpty) {
      throw MissingSignUpDataFailure();
    }

    final profile = UserProfile(
      userId: flow.userId,
      displayName: flow.displayName,
      gender: gender,
      dob: dob,
      heightCm: heightCm,
      level: level,
      goal: Goal.maintain,
      locationPref: locationPref,
    );

    await _authRepository.upsertProfile(profile);
    await _authRepository.logBodyMetrics(
      userId: flow.userId,
      weightKg: weightKg,
    );
  }

  Future<void> updateGoal({
    required SignUpFlowState flow,
    required Goal goal,
  }) async {
    if (flow.userId.isEmpty) {
      throw MissingSignUpDataFailure();
    }

    await _authRepository.updateGoal(userId: flow.userId, goal: goal);
  }

  Future<void> markOnboardingComplete() {
    return _sessionRepository.setOnboardingComplete(true);
  }

  Future<bool> hasActiveUser() async {
    final userId = await _sessionRepository.readActiveUserId();
    return userId != null;
  }

  Future<bool> isOnboardingComplete() {
    return _sessionRepository.isOnboardingComplete();
  }

  Future<void> clearSession() {
    return _sessionRepository.clearSession();
  }

  String _buildDisplayName(String firstName, String lastName) {
    final buffer = StringBuffer(firstName.trim());
    if (lastName.trim().isNotEmpty) {
      buffer.write(' ');
      buffer.write(lastName.trim());
    }
    return buffer.toString();
  }
}
