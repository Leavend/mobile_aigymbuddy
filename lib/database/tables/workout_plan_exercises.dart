// lib/database/tables/workout_plan_exercises.dart

part of '../app_db.dart';

class WorkoutPlanExercises extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  
  TextColumn get planDayId => text().named('plan_day_id').customConstraint('REFERENCES workout_plan_days(id) ON DELETE CASCADE')();
  TextColumn get exerciseId => text().named('exercise_id').customConstraint('REFERENCES exercises(id) ON DELETE RESTRICT')();
  IntColumn get orderIndex => integer().named('order_index')();

  IntColumn get sets => integer()();
  IntColumn get repsMin => integer().named('reps_min')();
  IntColumn get repsMax => integer().named('reps_max')();
  RealColumn get rpeTarget => real().named('rpe_target').nullable()();
  TextColumn get tempo => text().nullable()();
  IntColumn get restSec => integer().named('rest_sec').nullable()();
  RealColumn get percent1rm => real().named('percent_1rm').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}