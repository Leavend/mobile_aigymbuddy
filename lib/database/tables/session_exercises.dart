// lib/database/tables/session_exercises.dart

part of '../app_db.dart';

class SessionExercises extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  
  TextColumn get sessionId => text().named('session_id').customConstraint('REFERENCES workout_sessions(id) ON DELETE CASCADE')();
  TextColumn get exerciseId => text().named('exercise_id').customConstraint('REFERENCES exercises(id) ON DELETE RESTRICT')();
  IntColumn get orderIndex => integer().named('order_index')();
  TextColumn get notes => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}