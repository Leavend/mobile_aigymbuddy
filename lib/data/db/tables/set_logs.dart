// lib/data/db/tables/set_logs.dart

import 'package:drift/drift.dart';

import 'sessions.dart';
import 'workout_exercises.dart';

/// Detailed logs for each performed set during a session.
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();

  IntColumn get workoutExerciseId => integer().references(
        WorkoutExercises,
        #id,
        onDelete: KeyAction.cascade,
      )();

  // ignore: recursive_getters
  IntColumn get setIndex => integer().check(setIndex.isBiggerOrEqualValue(1))();

  IntColumn get reps => integer().nullable()();

  RealColumn get weight => real().nullable()();

  TextColumn get note => text().nullable()();
}
