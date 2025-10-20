// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:aigymbuddy/common/domain/enums.dart';

import '../entities/auth_user.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<UserProfile?> loadProfile(String userId);

  Future<void> upsertProfile(UserProfile profile);

  Future<void> logBodyMetrics({
    required String userId,
    required double weightKg,
    double? bodyFatPercentage,
  });

  Future<void> updateGoal({
    required String userId,
    required Goal goal,
  });
}
