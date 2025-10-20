// lib/database/tables/session_sets.dart

part of '../app_db.dart';

class SessionSets extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get sessionExerciseId => text()
      .named('session_exercise_id')
      .customConstraint(
        'NOT NULL REFERENCES session_exercises(id) ON DELETE CASCADE',
      )();
  IntColumn get setNumber => integer().named('set_number')();

  IntColumn get targetReps => integer().named('target_reps').nullable()();
  RealColumn get targetWeightKg =>
      real().named('target_weight_kg').nullable()();

  IntColumn get actualReps => integer().named('actual_reps')();
  RealColumn get actualWeightKg =>
      real().named('actual_weight_kg').nullable()();
  RealColumn get rpe => real().nullable()();
  BoolColumn get isWarmup =>
      boolean().named('is_warmup').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
