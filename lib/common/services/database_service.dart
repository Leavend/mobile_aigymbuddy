// lib/common/services/database_service.dart

import '../../database/app_db.dart';
import '../../database/repositories/user_repository.dart';

class DatabaseService {
  static DatabaseService? _instance;
  late final AppDatabase _database;
  late final UserRepository _userRepository;

  DatabaseService._internal() {
    _database = AppDatabase();
    _userRepository = UserRepository(_database);
  }

  factory DatabaseService() {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  AppDatabase get database => _database;
  UserRepository get userRepository => _userRepository;

  Future<void> close() async {
    await _database.closeDb();
    _instance = null;
  }

  // For testing
  static void dispose() {
    _instance = null;
  }
}
