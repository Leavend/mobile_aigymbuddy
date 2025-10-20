// lib/database/tables/muscles.dart

part of '../app_db.dart';

class Muscles extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().unique()();
  TextColumn get group =>
      text().map(const EnumTextConverter<MuscleGroup>(MuscleGroup.values))();

  @override
  Set<Column> get primaryKey => {id};
}
