// lib/data/db/app_database.dart

import 'package:drift/drift.dart';

import 'connection/connection_factory.dart';
import 'daos/exercise_dao.dart';
import 'daos/tracking_dao.dart';
import 'daos/user_profile_dao.dart';
import 'daos/workout_dao.dart';
import 'tables/body_weight_entries.dart';
import 'tables/exercises.dart';
import 'tables/sessions.dart';
import 'tables/set_logs.dart';
import 'tables/user_profiles.dart';
import 'tables/workout_exercises.dart';
import 'tables/workouts.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    Exercises,
    Workouts,
    WorkoutExercises,
    Sessions,
    SetLogs,
    BodyWeightEntries,
  ],
  daos: [UserProfileDao, ExerciseDao, WorkoutDao, TrackingDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
      : super(executor ?? createDriftExecutor());

  AppDatabase.forTesting(super.executor);

  static const int _schemaVersion = 1;

  @override
  int get schemaVersion => _schemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator migrator) async {
          await migrator.createAll();
          await _enableForeignKeys();
        },
        beforeOpen: (_) async {
          await _enableForeignKeys();
        },
        onUpgrade: (Migrator migrator, int from, int to) async {
          if (from == to) {
            return;
          }

          await _enableForeignKeys();
        },
      );

  Future<void> _enableForeignKeys() {
    return customStatement('PRAGMA foreign_keys = ON');
  }
}
