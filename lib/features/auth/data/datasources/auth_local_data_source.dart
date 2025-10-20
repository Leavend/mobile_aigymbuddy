// lib/features/auth/data/datasources/auth_local_data_source.dart

import 'package:aigymbuddy/common/domain/enums.dart';
import 'package:aigymbuddy/database/app_db.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._db);

  final AppDatabase _db;

  UsersDao get _usersDao => _db.usersDao;
  BodyMetricsDao get _bodyMetricsDao => _db.bodyMetricsDao;

  Future<User?> findUserByEmail(String email) => _usersDao.findByEmail(email);

  Future<User> createUser({
    required String email,
    required String passwordHash,
  }) =>
      _usersDao.createUser(email: email, passwordHash: passwordHash);

  Future<(User, UserProfile?)?> getUserWithProfile(String userId) =>
      _usersDao.getUserWithProfile(userId);

  Future<UserProfile?> findProfile(String userId) =>
      _usersDao.findProfile(userId);

  Future<void> upsertProfile(UserProfilesCompanion companion) =>
      _usersDao.upsertProfile(companion);

  Future<void> updateGoal({
    required String userId,
    required Goal goal,
  }) =>
      _usersDao.updateGoal(userId: userId, goal: goal);

  Future<void> insertBodyMetric({
    required String userId,
    required double weightKg,
    double? bodyFatPercentage,
  }) {
    return _bodyMetricsDao.addWeight(
      userId: userId,
      kg: weightKg,
      bodyFatPct: bodyFatPercentage,
    );
  }
}
