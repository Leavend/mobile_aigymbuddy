// lib/database/repositories/user_repository.dart

import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/base_repository.dart';
// import '../../common/services/error_service.dart';

class UserRepository extends BaseRepository {
  UserRepository(super.database);

  Future<List<User>> getAllUsers() async {
    return safeExecuteWithTimer(
      'get_all_users',
      () => database.usersDao.getAllUsers(),
    );
  }

  Future<User?> getUserById(String userId) async {
    return safeExecuteWithTimer(
      'get_user_by_id',
      () => database.usersDao.getUserById(userId),
    );
  }

  Future<void> createUser({
    required String email,
    required String passwordHash,
  }) async {
    return safeExecuteWithTimer(
      'create_user',
      () => database.usersDao.upsertUser(
        email: email,
        passwordHash: passwordHash,
      ),
    );
  }

  Future<(User, UserProfile?)?> getUserWithProfile(String userId) async {
    return safeExecuteWithTimer(
      'get_user_with_profile',
      () => database.usersDao.getUserWithProfile(userId),
    );
  }

  Future<int> getUserCount() async {
    return safeExecuteWithTimer(
      'get_user_count',
      () => database.usersDao.getUserCount(),
    );
  }
}
