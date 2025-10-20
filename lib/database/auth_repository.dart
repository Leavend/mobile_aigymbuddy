// lib/database/auth_repository.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'type_converters.dart';

import 'app_db.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';

class EmailAlreadyUsed implements Exception {}

class AuthRepository {
  final AppDatabase db;
  AuthRepository(this.db);

  Future<String> register(SignUpData d) async {
    return await db.transaction<String>(() async {
      // 1) Pastikan email unik
      final exists = await (db.select(db.users)
            ..where((u) => u.email.equals(d.email)))
          .getSingleOrNull();
      if (exists != null) throw EmailAlreadyUsed();

      // 2) Hash password
      final salt = const Uuid().v4();
      final hash =
          sha256.convert(utf8.encode('${d.password}::$salt')).toString();
      final passwordHash = '$salt:$hash';

      // 3) Insert users
      final userId = const Uuid().v4();
      await db.into(db.users).insert(
        UsersCompanion.insert(
          id: Value(userId),
          email: d.email,
          passwordHash: passwordHash,
          role: const Value(UserRole.user),
          createdAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
      );

      // 4) Insert user_profiles
      await db.into(db.userProfiles).insert(
        UserProfilesCompanion.insert(
          userId: userId, // Terapkan perbaikan dari komentar
          displayName: '${d.firstName} ${d.lastName}',
          gender: Gender.values.byName(d.gender!),
          dob: Value(d.dob),
          heightCm: d.heightCm!,
          level: Level.values.byName(d.level ?? 'beginner'),
          goal: Goal.values.byName(d.goal ?? 'maintain'),
          locationPref:
              LocationPref.values.byName(d.location ?? 'home'),
        ),
      );

      // 5) Seed body_metrics pertama (opsional)
      if (d.weightKg != null) {
        await db.into(db.bodyMetrics).insert(
          BodyMetricsCompanion.insert(
            id: Value(const Uuid().v4()),
            userId: userId, // Terapkan perbaikan dari komentar
            loggedAt: Value(DateTime.now()),
            weightKg: d.weightKg!,
            bodyFatPct: const Value.absent(),
            notes: const Value('initial'),
          ),
        );
      }

      return userId;
    });
  }
}