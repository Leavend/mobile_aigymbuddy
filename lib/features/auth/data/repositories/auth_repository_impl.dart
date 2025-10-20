// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import 'package:aigymbuddy/common/domain/enums.dart';
import 'package:aigymbuddy/database/app_db.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/errors/auth_failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final existing = await _localDataSource.findUserByEmail(email);
    if (existing != null) {
      throw EmailAlreadyInUseFailure();
    }

    final hashed = _hashPassword(password);
    final created = await _localDataSource.createUser(
      email: email,
      passwordHash: hashed,
    );

    return AuthUser(id: created.id, email: created.email, displayName: displayName);
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final user = await _localDataSource.findUserByEmail(email);
    if (user == null) {
      throw InvalidCredentialsFailure();
    }

    final hashed = _hashPassword(password);
    if (user.passwordHash != hashed) {
      throw InvalidCredentialsFailure();
    }

    final profile = await _localDataSource.findProfile(user.id);
    final displayName = profile?.displayName ?? email.split('@').first;

    return AuthUser(id: user.id, email: user.email, displayName: displayName);
  }

  @override
  Future<UserProfile?> loadProfile(String userId) async {
    final profileData = await _localDataSource.findProfile(userId);
    if (profileData == null) {
      return null;
    }

    return _mapProfile(profileData);
  }

  @override
  Future<void> upsertProfile(UserProfile profile) {
    final companion = UserProfilesCompanion(
      userId: Value(profile.userId),
      displayName: Value(profile.displayName),
      gender: Value(profile.gender),
      dob: Value(profile.dob),
      heightCm: Value(profile.heightCm),
      level: Value(profile.level),
      goal: Value(profile.goal),
      locationPref: Value(profile.locationPref),
    );

    return _localDataSource.upsertProfile(companion);
  }

  @override
  Future<void> logBodyMetrics({
    required String userId,
    required double weightKg,
    double? bodyFatPercentage,
  }) {
    return _localDataSource.insertBodyMetric(
      userId: userId,
      weightKg: weightKg,
      bodyFatPercentage: bodyFatPercentage,
    );
  }

  @override
  Future<void> updateGoal({
    required String userId,
    required Goal goal,
  }) {
    return _localDataSource.updateGoal(userId: userId, goal: goal);
  }

  UserProfile _mapProfile(UserProfileData data) {
    return UserProfile(
      userId: data.userId,
      displayName: data.displayName,
      gender: data.gender,
      dob: data.dob,
      heightCm: data.heightCm,
      level: data.level,
      goal: data.goal,
      locationPref: data.locationPref,
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
