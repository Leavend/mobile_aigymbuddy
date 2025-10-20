// lib/features/auth/domain/repositories/session_repository.dart

abstract class SessionRepository {
  Future<void> persistActiveUser(String userId);

  Future<String?> readActiveUserId();

  Future<void> clearSession();

  Future<void> setOnboardingComplete(bool value);

  Future<bool> isOnboardingComplete();
}
