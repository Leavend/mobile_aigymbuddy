import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:aigymbuddy/common/services/session_manager.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/database_service.dart';
import 'package:aigymbuddy/database/repositories/auth_repository.dart';
import 'package:aigymbuddy/database/repositories/user_profile_repository.dart';
import 'package:flutter/foundation.dart';

/// Service locator for managing dependencies with proper lifecycle management
class ServiceLocator {

  factory ServiceLocator() => _instance;

  ServiceLocator._internal();
  static final ServiceLocator _instance = ServiceLocator._internal();

  // Services
  AppDatabase? _database;
  DatabaseService? _databaseService;
  SessionManager? _sessionManager;

  // Repositories
  AuthRepositoryInterface? _authRepository;
  UserProfileRepository? _userProfileRepository;

  // Use cases
  AuthUseCase? _authUseCase;

  // Controllers
  AuthController? _authController;

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

      // Initialize session manager
      _sessionManager = SessionManager();

      // Initialize repositories
      _authRepository = AuthRepository(_database!);
      _userProfileRepository = UserProfileRepository(_database!);

      // Initialize use cases
      _authUseCase = AuthUseCaseImpl(repository: _authRepository!);

      // Initialize controllers
      _authController = AuthController(useCase: _authUseCase!);

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

      // Dispose controllers first
      _authController?.dispose();
      _authController = null;

      // Dispose session manager
      _sessionManager?.dispose();
      _sessionManager = null;

      // Close database connection
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

  // Session Manager
  SessionManager get sessionManager {
    if (_sessionManager == null) {
      throw StateError(
        'SessionManager not initialized. Call initialize() first.',
      );
    }
    return _sessionManager!;
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

  // Controllers
  AuthController get authController {
    if (_authController == null) {
      throw StateError(
        'AuthController not initialized. Call initialize() first.',
      );
    }
    return _authController!;
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

  @visibleForTesting
  void registerAuthController(AuthController controller) {
    _authController = controller;
  }
}
