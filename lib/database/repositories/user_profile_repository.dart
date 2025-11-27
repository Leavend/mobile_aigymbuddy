import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:drift/drift.dart';

abstract class UserProfileRepositoryInterface {
  Future<void> updateProfile(AuthUser user);
  Future<AuthUser?> getUserProfile(String userId);
}

class UserProfileRepository implements UserProfileRepositoryInterface {
  UserProfileRepository(this.db);

  final AppDatabase db;

  @override
  Future<void> updateProfile(AuthUser user) async {
    await db.transaction(() async {
      // Update user profile
      await (db.update(
        db.userProfiles,
      )..where((u) => u.userId.equals(user.id))).write(
        UserProfilesCompanion(
          displayName: Value(user.displayName),
          gender: user.gender != null
              ? Value(user.gender!)
              : const Value.absent(),
          dob: Value(user.dob),
          heightCm: user.heightCm != null
              ? Value(user.heightCm!)
              : const Value.absent(),
          level: user.level != null ? Value(user.level!) : const Value.absent(),
          goal: user.goal != null ? Value(user.goal!) : const Value.absent(),
          locationPref: user.locationPref != null
              ? Value(user.locationPref!)
              : const Value.absent(),
        ),
      );
    });
  }

  @override
  Future<AuthUser?> getUserProfile(String userId) async {
    final user = await (db.select(
      db.users,
    )..where((u) => u.id.equals(userId))).getSingleOrNull();

    if (user == null) return null;

    final profile = await (db.select(
      db.userProfiles,
    )..where((p) => p.userId.equals(userId))).getSingleOrNull();

    return AuthUser.fromData(user: user, profile: profile);
  }
}
