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
  AppDatabase() : super(createDriftExecutor());

  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await customStatement('PRAGMA foreign_keys = ON');
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Handle schema migrations when upgrading versions.
        },
      );
}
