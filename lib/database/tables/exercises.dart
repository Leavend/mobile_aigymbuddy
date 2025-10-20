// lib/database/tables/exercises.dart

part of '../app_db.dart';

class Exercises extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get name => text().unique()();
  TextColumn get description => text()();
  BoolColumn get isBodyWeight =>
      boolean().named('is_body_weight').withDefault(const Constant(false))();
  TextColumn get videoUrl => text().named('video_url').nullable()();
  IntColumn get defaultRestSec =>
      integer().named('default_rest_sec').withDefault(const Constant(60))();

  @override
  Set<Column> get primaryKey => {id};
}
