// lib/features/auth/data/repositories/session_repository_impl.dart

import '../../domain/repositories/session_repository.dart';
import '../datasources/session_local_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._localDataSource);

  final SessionLocalDataSource _localDataSource;

  @override
  Future<void> persistActiveUser(String userId) {
    return _localDataSource.persistActiveUser(userId);
  }

  @override
  Future<String?> readActiveUserId() {
    return _localDataSource.readActiveUserId();
  }

  @override
  Future<void> clearSession() {
    return _localDataSource.clearSession();
  }

  @override
  Future<void> setOnboardingComplete(bool value) {
    return _localDataSource.setOnboardingComplete(value);
  }

  @override
  Future<bool> isOnboardingComplete() {
    return _localDataSource.isOnboardingComplete();
  }
}
