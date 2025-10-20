// lib/database/auth_repository.dart
import 'dart:convert';

import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_db.dart';
import 'type_converters.dart';

class EmailAlreadyUsed implements Exception {}

class InvalidCredentials implements Exception {}

class IncompleteSignUpData implements Exception {
  IncompleteSignUpData(this.missingFields)
      : assert(missingFields.isNotEmpty, 'missingFields cannot be empty');

  final List<String> missingFields;

  @override
  String toString() =>
      'IncompleteSignUpData(missing: ${missingFields.join(', ')})';
}

class AuthRepository {
  AuthRepository(this.db);

  final AppDatabase db;

  Future<AuthUser> register(SignUpData data) async {
    _validateSignUpData(data);

    return db.transaction<AuthUser>(() async {
      final email = _normalizeEmail(data.email);
      final existing = await (db.select(db.users)
            ..where((u) => u.email.equals(email))
            ..where((u) => u.deletedAt.isNull()))
          .getSingleOrNull();

      if (existing != null) {
        throw EmailAlreadyUsed();
      }

      final passwordHash = _hashPassword(data.password);
      final now = DateTime.now();
      final userId = const Uuid().v4();

      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: Value(userId),
              email: email,
              passwordHash: passwordHash,
              role: const Value(UserRole.user),
              createdAt: Value(now),
              updateAt: Value(now),
              deletedAt: const Value.absent(),
            ),
          );

      await db.into(db.userProfiles).insert(
            UserProfilesCompanion.insert(
              userId: userId,
              displayName: data.displayName,
              gender: data.gender!,
              dob: Value(data.dob),
              heightCm: data.heightCm!,
              level: data.level ?? Level.beginner,
              goal: data.goal ?? Goal.maintain,
              locationPref: data.location ?? LocationPref.home,
            ),
          );

      if (data.weightKg != null) {
        await db.into(db.bodyMetrics).insert(
              BodyMetricsCompanion.insert(
                id: Value(const Uuid().v4()),
                userId: userId,
                loggedAt: Value(now),
                weightKg: data.weightKg!,
                bodyFatPct: const Value.absent(),
                notes: const Value('initial'),
              ),
            );
      }

      return _readAuthUser(userId);
    });
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final user = await (db.select(db.users)
          ..where((u) => u.email.equals(normalizedEmail))
          ..where((u) => u.deletedAt.isNull()))
        .getSingleOrNull();

    if (user == null) {
      throw InvalidCredentials();
    }

    if (!_verifyPassword(user.passwordHash, password)) {
      throw InvalidCredentials();
    }

    final profile = await (db.select(db.userProfiles)
          ..where((p) => p.userId.equals(user.id)))
        .getSingleOrNull();

    return AuthUser.fromData(user: user, profile: profile);
  }

  Future<AuthUser> _readAuthUser(String userId) async {
    final user = await (db.select(db.users)
          ..where((u) => u.id.equals(userId)))
        .getSingle();
    final profile = await (db.select(db.userProfiles)
          ..where((p) => p.userId.equals(userId)))
        .getSingleOrNull();
    return AuthUser.fromData(user: user, profile: profile);
  }

  void _validateSignUpData(SignUpData data) {
    final missing = <String>[];
    if (data.gender == null) missing.add('gender');
    if (data.dob == null) missing.add('dob');
    if (data.heightCm == null) missing.add('heightCm');
    if (data.goal == null) missing.add('goal');
    if (data.location == null) missing.add('location');
    if (data.level == null) missing.add('level');

    if (missing.isNotEmpty) {
      throw IncompleteSignUpData(missing);
    }
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  String _hashPassword(String password) {
    final salt = const Uuid().v4();
    final hash = sha256.convert(utf8.encode('$password::$salt')).toString();
    return '$salt:$hash';
  }

  bool _verifyPassword(String storedHash, String password) {
    final parts = storedHash.split(':');
    if (parts.length != 2) return false;
    final salt = parts.first;
    final expectedHash = parts.last;
    final candidateHash =
        sha256.convert(utf8.encode('$password::$salt')).toString();
    return _constantTimeEquals(expectedHash, candidateHash);
  }

  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
