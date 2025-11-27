// lib/database/auth_repository.dart
import 'dart:convert';
import 'dart:math';

import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/common/exceptions/database_exceptions.dart';
import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/database_service.dart';
import 'package:aigymbuddy/database/type_converters.dart';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

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

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository(this.db) : _dbService = DatabaseService(db);

  final AppDatabase db;
  final DatabaseService _dbService;
  final LoggingService _logger = LoggingService.instance;

  @override
  Future<AuthUser> register(SignUpData data) async {
    _logger.info('Starting registration process for user: ${data.email}');

    try {
      return await _dbService.transaction<AuthUser>(() async {
        _validateSignUpData(data);

        final email = _normalizeEmail(data.email);
        _logger.debug('Checking for existing user with email: $email');

        final existing = await _safeQuery(
          () =>
              (db.select(db.users)
                    ..where((u) => u.email.equals(email))
                    ..where((u) => u.deletedAt.isNull()))
                  .getSingleOrNull(),
        );

        if (existing != null) {
          _logger.warning('Registration failed - email already exists: $email');
          throw EmailAlreadyUsed();
        }

        final passwordHash = await _hashPassword(data.password);
        final now = DateTime.now();
        final userId = const Uuid().v4();

        await _safeQuery(
          () => db
              .into(db.users)
              .insert(
                UsersCompanion.insert(
                  id: Value(userId),
                  email: email,
                  passwordHash: passwordHash,
                  role: const Value(UserRole.user),
                  createdAt: Value(now),
                  updateAt: Value(now),
                ),
              ),
        );

        await _safeQuery(
          () => db
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
              ),
        );

        if (data.weightKg != null) {
          await _safeQuery(
            () => db
                .into(db.bodyMetrics)
                .insert(
                  BodyMetricsCompanion.insert(
                    id: Value(const Uuid().v4()),
                    userId: userId,
                    loggedAt: Value(now),
                    weightKg: data.weightKg!,
                    notes: const Value('initial'),
                  ),
                ),
          );
        }

        _logger.info('Registration successful for user: ${data.email}');
        return _readAuthUser(userId);
      });
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Registration failed for user: ${data.email} - ${e.runtimeType}: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error during registration for user: ${data.email} - ${e.runtimeType}: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    _logger.info('Login attempt for user: $email');

    try {
      final normalizedEmail = _normalizeEmail(email);
      final user = await _safeQuery(
        () =>
            (db.select(db.users)
                  ..where((u) => u.email.equals(normalizedEmail))
                  ..where((u) => u.deletedAt.isNull()))
                .getSingleOrNull(),
      );

      if (user == null) {
        _logger.warning('Login failed - user not found: $email');
        throw InvalidCredentials();
      }

      if (!await _verifyPassword(user.passwordHash, password)) {
        _logger.warning('Login failed - invalid password for user: $email');
        throw InvalidCredentials();
      }

      final profile = await _safeQuery(
        () => (db.select(
          db.userProfiles,
        )..where((p) => p.userId.equals(user.id))).getSingleOrNull(),
      );

      _logger.info('Login successful for user: $email');
      return AuthUser.fromData(user: user, profile: profile);
    } on Exception catch (e, stackTrace) {
      // Log with more specific exception handling to avoid internal objects leaking
      _logger.error(
        'Login failed for user: $email - ${e.runtimeType}: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      // Fallback for any other types of errors
      _logger.error(
        'Unexpected error during login for user: $email - ${e.runtimeType}: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// A wrapper method to safely execute database queries and handle WASM-specific issues
  Future<T?> _safeQuery<T>(Future<T?> Function() query) async {
    try {
      return await query();
    } catch (e) {
      // Check if this is the specific WASM database result error
      if (e.toString().contains('WasmDatabaseResult') &&
          e.toString().contains('QueryExecutor')) {
        // Log a more user-friendly error message
        _logger.error(
          'Database connection error: WASM database not properly initialized',
        );
        // Throw typed exception instead of generic Exception
        throw const WasmDatabaseException(
          'Database connection error. Please refresh the page and try again.',
        );
      }
      rethrow;
    }
  }

  Future<AuthUser> _readAuthUser(String userId) async {
    final user = await _safeQueryNonNullable(
      () =>
          (db.select(db.users)..where((u) => u.id.equals(userId))).getSingle(),
    );
    final profile = await _safeQuery(
      () => (db.select(
        db.userProfiles,
      )..where((p) => p.userId.equals(userId))).getSingleOrNull(),
    );
    return AuthUser.fromData(user: user, profile: profile);
  }

  /// A wrapper method to safely execute database queries that return non-nullable results
  Future<T> _safeQueryNonNullable<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e) {
      // Check if this is the specific WASM database result error
      if (e.toString().contains('WasmDatabaseResult') &&
          e.toString().contains('QueryExecutor')) {
        // Log a more user-friendly error message
        _logger.error(
          'Database connection error: WASM database not properly initialized',
        );
        // Throw typed exception instead of generic Exception
        throw const WasmDatabaseException(
          'Database connection error. Please refresh the page and try again.',
        );
      }
      rethrow;
    }
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
      final bits = bitsValue is int && bitsValue > 0 ? bitsValue : _pbkdf2.bits;

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
