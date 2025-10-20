// lib/database/tables/exercise_muscles.dart

part of '../app_db.dart';

class ExerciseMuscles extends Table {
  TextColumn get exerciseId => text().named('exercise_id').customConstraint('REFERENCES exercises(id) ON DELETE CASCADE')();

  TextColumn get muscleId => text().named('muscle_id').customConstraint('REFERENCES muscles(id) ON DELETE CASCADE')();
  TextColumn get priority => text()(); // 'primary' | 'secondary'

  @override
  Set<Column> get primaryKey => {exerciseId, muscleId, priority};
}