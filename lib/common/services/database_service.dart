// lib/common/services/database_service.dart

import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/repositories/user_repository.dart';

class DatabaseService {

  factory DatabaseService() {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  DatabaseService._internal() {
    _database = AppDatabase();
    _userRepository = UserRepository(_database);
  }
  static DatabaseService? _instance;
  late final AppDatabase _database;
  late final UserRepository _userRepository;

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
