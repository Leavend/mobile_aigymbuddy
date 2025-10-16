// Run `flutter pub get` then `dart run build_runner build -d` before using
// the generated code. Launch the app with `flutter run` afterwards.

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

LazyDatabase _openConnection() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'ai_gym_buddy.sqlite'));
  final executor = NativeDatabase.createInBackground(file);
  return executor;
});

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
  daos: [
    UserProfileDao,
    ExerciseDao,
    WorkoutDao,
    TrackingDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting() : super(NativeDatabase.memory()) {
    // Ensures foreign keys are respected when using in-memory database.
    customStatement('PRAGMA foreign_keys = ON');
  }

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
