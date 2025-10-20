// lib/database/tables/exercise_equipment.dart

part of '../app_db.dart';

class ExerciseEquipment extends Table {
  TextColumn get exerciseId => text()
      .named('exercise_id')
      .customConstraint(
        'NOT NULL REFERENCES exercises(id) ON DELETE CASCADE',
      )();
  TextColumn get equipmentId => text()
      .named('equipment_id')
      .customConstraint(
        'NOT NULL REFERENCES equipment(id) ON DELETE CASCADE',
      )();

  @override
  Set<Column> get primaryKey => {exerciseId, equipmentId};
}
