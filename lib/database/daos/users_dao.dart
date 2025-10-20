// lib/database/daos/users_dao.dart

part of '../app_db.dart';

@DriftAccessor(tables: [Users, UserProfiles])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<void> upsertUser({
    required String email,
    required String passwordHash,
  }) async {
    await into(users).insertOnConflictUpdate(
      UsersCompanion(
        email: Value(email),
        passwordHash: Value(passwordHash),
        role: const Value(UserRole.user),
      ),
    );
  }

  Future<(User, UserProfile?)?> getUserWithProfile(String userId) async {
    final query = select(users).join([
      leftOuterJoin(userProfiles, userProfiles.userId.equalsExp(users.id)),
    ])..where(users.id.equals(userId));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    return (result.readTable(users), result.readTableOrNull(userProfiles));
  }
}
