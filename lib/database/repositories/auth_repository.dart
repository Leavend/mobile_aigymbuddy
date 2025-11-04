// lib/database/auth_repository.dart
import 'dart:convert';
import 'dart:math';

import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_db.dart';
import '../type_converters.dart';

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
      final existing =
          await (db.select(db.users)
                ..where((u) => u.email.equals(email))
                ..where((u) => u.deletedAt.isNull()))
              .getSingleOrNull();

      if (existing != null) {
        throw EmailAlreadyUsed();
      }

      final passwordHash = await _hashPassword(data.password);
      final now = DateTime.now();
      final userId = const Uuid().v4();

      await db
          .into(db.users)
          .insert(
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

      await db
          .into(db.userProfiles)
          .insert(
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
        await db
            .into(db.bodyMetrics)
            .insert(
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
    final user =
        await (db.select(db.users)
              ..where((u) => u.email.equals(normalizedEmail))
              ..where((u) => u.deletedAt.isNull()))
            .getSingleOrNull();

    if (user == null) {
      throw InvalidCredentials();
    }

    if (!await _verifyPassword(user.passwordHash, password)) {
      throw InvalidCredentials();
    }

    final profile = await (db.select(
      db.userProfiles,
    )..where((p) => p.userId.equals(user.id))).getSingleOrNull();

    return AuthUser.fromData(user: user, profile: profile);
  }

  Future<AuthUser> _readAuthUser(String userId) async {
    final user = await (db.select(
      db.users,
    )..where((u) => u.id.equals(userId))).getSingle();
    final profile = await (db.select(
      db.userProfiles,
    )..where((p) => p.userId.equals(userId))).getSingleOrNull();
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

  static const int _saltLength = 16;
  static final Random _random = Random.secure();
  static final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 150000,
    bits: 256,
  );

  Future<String> _hashPassword(String password) async {
    final salt = List<int>.generate(_saltLength, (_) => _random.nextInt(256));

    final derivedKey = await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final hashBytes = await derivedKey.extractBytes();

    final payload = <String, Object?>{
      'v': 1,
      'algo': 'pbkdf2-hmac-sha256',
      'iter': _pbkdf2.iterations,
      'bits': _pbkdf2.bits,
      'salt': base64Encode(salt),
      'hash': base64Encode(hashBytes),
    };

    return jsonEncode(payload);
  }

  Future<bool> _verifyPassword(String storedHash, String password) async {
    try {
      final decoded = jsonDecode(storedHash);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }

      final iterationsValue = decoded['iter'];
      final iterations = iterationsValue is int && iterationsValue > 0
          ? iterationsValue
          : _pbkdf2.iterations;
      final saltBase64 = decoded['salt'] as String?;
      final hashBase64 = decoded['hash'] as String?;

      if (saltBase64 == null || hashBase64 == null) {
        return false;
      }

      final salt = base64Decode(saltBase64);
      final expectedHash = base64Decode(hashBase64);
      final bitsValue = decoded['bits'];
      final bits = bitsValue is int && bitsValue > 0
          ? bitsValue
          : expectedHash.length * 8;

      final algorithm = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iterations,
        bits: bits,
      );

      final candidateKey = await algorithm.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      final candidateHash = await candidateKey.extractBytes();

      return _constantTimeEquals(candidateHash, expectedHash);
    } catch (_) {
      return false;
    }
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
