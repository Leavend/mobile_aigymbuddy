// lib/database/app_db.dart

import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:aigymbuddy/database/connection/connection.dart';
import 'package:aigymbuddy/database/type_converters.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

part 'app_db.g.dart';
part 'daos/body_metrics_dao.dart';
part 'daos/users_dao.dart';
part 'daos/workout_plans_dao.dart';
part 'tables/ai_chat_messages.dart';
part 'tables/body_metrics.dart';
part 'tables/equipment.dart';
part 'tables/exercise_equipment.dart';
part 'tables/exercise_muscles.dart';
part 'tables/exercises.dart';
part 'tables/muscles.dart';
part 'tables/session_exercises.dart';
part 'tables/session_sets.dart';
part 'tables/user_profiles.dart';
part 'tables/users.dart';
part 'tables/workout_plan_days.dart';
part 'tables/workout_plan_exercises.dart';
part 'tables/workout_plans.dart';
part 'tables/workout_sessions.dart';

@DriftDatabase(
  tables: [
    Users,
    UserProfiles,
    Exercises,
    BodyMetrics,
    Muscles,
    ExerciseMuscles,
    Equipment,
    ExerciseEquipment,
    WorkoutPlans,
    WorkoutPlanDays,
    WorkoutPlanExercises,
    WorkoutSessions,
    SessionExercises,
    SessionSets,
    AiChatMessages,
  ],
  daos: [UsersDao, BodyMetricsDao, WorkoutPlansDao],
)
class AppDatabase extends _$AppDatabase {

  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  AppDatabase._internal() : super(openConnection()) {
    _isClosed = false;
  }

  // Fix: Use super parameter
  AppDatabase.forTesting(super.connection) {
    _isClosed = false;
  }
  // Singleton pattern untuk testing
  static AppDatabase? _instance;
  bool _isClosed = false;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migration logic ketika schema berubah
    },
    beforeOpen: (details) async {
      // Enable foreign keys
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // Method untuk menutup database dengan enhanced error handling
  Future<void> closeDb() async {
    if (_instance != null && !_instance!._isClosed) {
      try {
        await _instance!.close();
        _instance = null;
      } catch (e) {
        // Log error but don't throw to prevent cascading failures
        LoggingService.instance.error('Error closing database: $e');
      }
    }
  }

  // Method untuk dispose instance - berguna untuk testing
  static void dispose() {
    if (_instance != null && !_instance!._isClosed) {
      _instance!._isClosed = true;
    }
    _instance = null;
  }

  bool get isClosed => _isClosed;

  @override
  Future<void> close() async {
    if (_isClosed) {
      return;
    }

    _isClosed = true;
    try {
      await super.close();
    } catch (e) {
      LoggingService.instance.error('Error during database close: $e');
      rethrow;
    }
  }

  /// Ensure the database is properly closed when the app exits
  static Future<void> cleanup() async {
    if (_instance != null) {
      await _instance!.closeDb();
    }
  }
}
