import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/database_service.dart';
import 'package:aigymbuddy/database/repositories/auth_repository.dart';
import 'package:aigymbuddy/database/repositories/user_profile_repository.dart';
import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:flutter/foundation.dart';

/// Service locator for managing dependencies with proper lifecycle management
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  // Services
  AppDatabase? _database;
  DatabaseService? _databaseService;

  // Repositories
  AuthRepositoryInterface? _authRepository;
  UserProfileRepository? _userProfileRepository;

  // Use cases
  AuthUseCase? _authUseCase;

  bool _isInitialized = false;

  // Initialize services that require async initialization
  Future<void> initialize() async {
    if (_isInitialized) {
      LoggingService.instance.warning(
        'ServiceLocator already initialized, skipping...',
      );
      return;
    }

    try {
      LoggingService.instance.info('Initializing ServiceLocator...');

      // Initialize database
      _database = AppDatabase();

      // Initialize database service
      _databaseService = DatabaseService(_database!);

      // Initialize repositories
      _authRepository = AuthRepository(_database!);
      _userProfileRepository = UserProfileRepository(_database!);

      // Initialize use cases
      _authUseCase = AuthUseCaseImpl(repository: _authRepository!);

      _isInitialized = true;
      LoggingService.instance.info('ServiceLocator initialized successfully');
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to initialize ServiceLocator: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Clean disposal of all services to prevent memory leaks
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      LoggingService.instance.info('Disposing ServiceLocator...');

      // Close database connection first
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // Clear all references
      _databaseService = null;
      _authRepository = null;
      _userProfileRepository = null;
      _authUseCase = null;

      _isInitialized = false;
      LoggingService.instance.info('ServiceLocator disposed successfully');
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Error during ServiceLocator disposal: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Database
  AppDatabase get database {
    if (_database == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  // Database Service
  DatabaseService get databaseService {
    if (_databaseService == null) {
      throw StateError(
        'DatabaseService not initialized. Call initialize() first.',
      );
    }
    return _databaseService!;
  }

  // Repositories
  AuthRepositoryInterface get authRepository {
    if (_authRepository == null) {
      throw StateError(
        'AuthRepository not initialized. Call initialize() first.',
      );
    }
    return _authRepository!;
  }

  UserProfileRepository get userProfileRepository {
    if (_userProfileRepository == null) {
      throw StateError(
        'UserProfileRepository not initialized. Call initialize() first.',
      );
    }
    return _userProfileRepository!;
  }

  // Use cases
  AuthUseCase get authUseCase {
    if (_authUseCase == null) {
      throw StateError('AuthUseCase not initialized. Call initialize() first.');
    }
    return _authUseCase!;
  }

  // Reset all services (useful for testing)
  void reset() {
    _database = null;
    _databaseService = null;
    _authRepository = null;
    _userProfileRepository = null;
    _authUseCase = null;
    _isInitialized = false;
  }

  @visibleForTesting
  void registerAuthRepository(AuthRepositoryInterface repo) {
    _authRepository = repo;
  }

  @visibleForTesting
  void registerAuthUseCase(AuthUseCase useCase) {
    _authUseCase = useCase;
  }

  @visibleForTesting
  void registerDatabase(AppDatabase db) {
    _database = db;
  }

  @visibleForTesting
  void registerDatabaseService(DatabaseService service) {
    _databaseService = service;
  }

  @visibleForTesting
  void registerUserProfileRepository(UserProfileRepository repo) {
    _userProfileRepository = repo;
  }
}
