// lib/database/daos/users_dao.dart

part of '../app_db.dart';

@DriftAccessor(tables: [Users, UserProfiles])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<User?> findByEmail(String email) {
    return (select(users)..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();
  }

  Future<User> createUser({
    required String email,
    required String passwordHash,
  }) async {
    final companion = UsersCompanion.insert(
      email: email,
      passwordHash: passwordHash,
      role: const Value(UserRole.user),
    );

    return into(users).insertReturning(companion);
  }

  Future<(User, UserProfile?)?> getUserWithProfile(String userId) async {
    final query = select(users).join([
      leftOuterJoin(userProfiles, userProfiles.userId.equalsExp(users.id))
    ])
      ..where(users.id.equals(userId));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    return (result.readTable(users), result.readTableOrNull(userProfiles));
  }

  Future<UserProfile?> findProfile(String userId) {
    return (select(userProfiles)..where((tbl) => tbl.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> upsertProfile(UserProfilesCompanion companion) {
    return into(userProfiles).insertOnConflictUpdate(companion);
  }

  Future<void> updateGoal({
    required String userId,
    required Goal goal,
  }) {
    return (update(userProfiles)..where((tbl) => tbl.userId.equals(userId)))
        .write(UserProfilesCompanion(goal: Value(goal)));
  }
}