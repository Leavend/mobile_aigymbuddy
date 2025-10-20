// lib/database/tables/equipment.dart

part of '../app_db.dart';

class Equipment extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}