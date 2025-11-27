// lib/database/daos/users_dao.dart

part of '../app_db.dart';

@DriftAccessor(tables: [Users, UserProfiles])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  // Method yang sudah ada
  Future<void> upsertUser({
    required String email,
    required String passwordHash,
  }) async {
    await transaction(() async {
      final existingUser = await getUserByEmail(email);

      if (existingUser != null) {
        await (update(
          users,
        )..where((tbl) => tbl.id.equals(existingUser.id))).write(
          UsersCompanion(
            email: Value(email),
            passwordHash: Value(passwordHash),
            role: Value(existingUser.role),
            updateAt: Value(DateTime.now()),
          ),
        );
      } else {
        await into(users).insert(
          UsersCompanion(
            email: Value(email),
            passwordHash: Value(passwordHash),
            role: const Value(UserRole.user),
          ),
        );
      }
    });
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

  // TAMBAHKAN method ini untuk testing
  Future<List<User>> getAllUsers() async {
    return select(users).get();
  }

  // Method tambahan yang berguna
  Future<User?> getUserById(String userId) async {
    return (select(
      users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
  }

  Future<User?> getUserByEmail(String email) async {
    return (select(
      users,
    )..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
  }

  Future<int> getUserCount() async {
    final countExp = countAll();
    final query = selectOnly(users)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<void> deleteUser(String userId) async {
    await (delete(users)..where((tbl) => tbl.id.equals(userId))).go();
  }
}
