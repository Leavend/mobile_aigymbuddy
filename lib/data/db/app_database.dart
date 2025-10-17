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
import 'tables/meals.dart';
import 'tables/meal_schedule_entries.dart';

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
    Meals,
    MealScheduleEntries,
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
          await _createMealPlannerTables();
        },
        beforeOpen: (_) async {
          await _enableForeignKeys();
          await _createMealPlannerTables();
        },
        onUpgrade: (Migrator migrator, int from, int to) async {
          if (from == to) {
            return;
          }

          await _enableForeignKeys();
          await _createMealPlannerTables();
        },
      );

  Future<void> _enableForeignKeys() {
    return customStatement('PRAGMA foreign_keys = ON');
  }

  Future<void> _createMealPlannerTables() async {
    await customStatement('''
CREATE TABLE IF NOT EXISTS meal_categories (
  id INTEGER PRIMARY KEY,
  name_en TEXT NOT NULL,
  name_id TEXT NOT NULL,
  image_asset TEXT NOT NULL
);
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS meals (
  id INTEGER PRIMARY KEY,
  category_id INTEGER NOT NULL REFERENCES meal_categories(id) ON DELETE CASCADE,
  name_en TEXT NOT NULL,
  name_id TEXT NOT NULL,
  description_en TEXT NOT NULL,
  description_id TEXT NOT NULL,
  image_asset TEXT NOT NULL,
  hero_image_asset TEXT NOT NULL,
  period TEXT NOT NULL,
  prep_minutes INTEGER NOT NULL,
  calories INTEGER,
  difficulty TEXT
);
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS meal_nutrition_facts (
  id INTEGER PRIMARY KEY,
  meal_id INTEGER NOT NULL REFERENCES meals(id) ON DELETE CASCADE,
  image_asset TEXT NOT NULL,
  title_en TEXT NOT NULL,
  title_id TEXT NOT NULL,
  value_en TEXT NOT NULL,
  value_id TEXT NOT NULL
);
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS meal_ingredients (
  id INTEGER PRIMARY KEY,
  meal_id INTEGER NOT NULL REFERENCES meals(id) ON DELETE CASCADE,
  image_asset TEXT NOT NULL,
  name_en TEXT NOT NULL,
  name_id TEXT NOT NULL,
  amount_en TEXT NOT NULL,
  amount_id TEXT NOT NULL
);
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS meal_instructions (
  id INTEGER PRIMARY KEY,
  meal_id INTEGER NOT NULL REFERENCES meals(id) ON DELETE CASCADE,
  step_order INTEGER NOT NULL,
  title_en TEXT,
  title_id TEXT,
  description_en TEXT NOT NULL,
  description_id TEXT NOT NULL
);
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS meal_schedule_entries (
  id INTEGER PRIMARY KEY,
  meal_id INTEGER NOT NULL REFERENCES meals(id) ON DELETE CASCADE,
  scheduled_at TEXT NOT NULL
);
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS meal_nutrition_progress_entries (
  id INTEGER PRIMARY KEY,
  day TEXT NOT NULL,
  completion REAL NOT NULL
);
''');
  }
}
