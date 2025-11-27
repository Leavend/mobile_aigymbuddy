/// Database-related constants.
///
/// This file contains constants specific to database operations,
/// table names, column names, and database configuration.
abstract final class DatabaseConstants {
  // Prevent instantiation
  DatabaseConstants._();

  /// Database metadata
  static const String databaseName = 'aigymbuddy.db';
  static const int databaseVersion = 1;

  /// Database configuration
  static const int maxDatabaseConnections = 5;
  static const int databaseBusyTimeout = 5000; // milliseconds
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(milliseconds: 100);

  /// SQLite pragmas
  static const String pragmaForeignKeys = 'PRAGMA foreign_keys = ON';
  static const String pragmaJournalMode = 'PRAGMA journal_mode = WAL';
  static const String pragmaSynchronous = 'PRAGMA synchronous = NORMAL';
  static const String pragmaTempStore = 'PRAGMA temp_store = MEMORY';
  static const String pragmaCacheSize = 'PRAGMA cache_size = -2000'; // 2MB

  /// Table names
  static const String tableUsers = 'users';
  static const String tableWorkouts = 'workouts';
  static const String tableExercises = 'exercises';
  static const String tableMeals = 'meals';
  static const String tableSleepRecords = 'sleep_records';
  static const String tableWaterIntake = 'water_intake';
  static const String tableBodyMetrics = 'body_metrics';
  static const String tablePhotos = 'photos';
  static const String tableSettings = 'settings';

  /// Common column names
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnDeletedAt = 'deleted_at';
  static const String columnUserId = 'user_id';

  /// User table columns
  static const String columnEmail = 'email';
  static const String columnPasswordHash = 'password_hash';
  static const String columnPasswordSalt = 'password_salt';
  static const String columnFirstName = 'first_name';
  static const String columnLastName = 'last_name';
  static const String columnDateOfBirth = 'date_of_birth';
  static const String columnGender = 'gender';
  static const String columnHeight = 'height';
  static const String columnWeight = 'weight';
  static const String columnGoal = 'goal';

  /// Workout table columns
  static const String columnWorkoutName = 'name';
  static const String columnWorkoutType = 'type';
  static const String columnDuration = 'duration';
  static const String columnCaloriesBurned = 'calories_burned';
  static const String columnStartTime = 'start_time';
  static const String columnEndTime = 'end_time';
  static const String columnStatus = 'status';

  /// Query limits
  static const int defaultQueryLimit = 100;
  static const int maxQueryLimit = 1000;

  /// Backup configuration
  static const int backupRetentionDays = 7;
  static const String backupFilePrefix = 'backup_';
  static const String backupFileExtension = '.db';

  /// Indexes
  static const String indexUserEmail = 'idx_users_email';
  static const String indexWorkoutUserId = 'idx_workouts_user_id';
  static const String indexWorkoutStartTime = 'idx_workouts_start_time';
  static const String indexMealUserId = 'idx_meals_user_id';
  static const String indexSleepUserId = 'idx_sleep_records_user_id';

  /// Triggers
  static const String triggerUpdateTimestamp = 'update_timestamp';

  /// Views
  static const String viewUserStats = 'user_stats';
  static const String viewRecentWorkouts = 'recent_workouts';
  static const String viewWeeklyProgress = 'weekly_progress';
}
