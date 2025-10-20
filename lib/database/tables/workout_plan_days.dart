// lib/database/tables/workout_plan_days.dart 

part of '../app_db.dart';

class WorkoutPlanDays extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get planId => text().named('plan_id').customConstraint('REFERENCES workout_plans(id) ON DELETE CASCADE')();
  IntColumn get dayIndex => integer().named('day_index')();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}