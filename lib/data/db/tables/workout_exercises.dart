import 'package:drift/drift.dart';

import 'exercises.dart';
import 'workouts.dart';

/// Detail rows for each exercise planned inside a workout.
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  IntColumn get sets => integer().check(sets.isBiggerOrEqualValue(1))();

  IntColumn get reps => integer().nullable()();

  IntColumn get durationSec => integer().nullable()();

  IntColumn get restSec =>
      integer().withDefault(const Constant(60)).check(restSec.isBiggerOrEqualValue(0))();
}
