// lib/data/db/tables/meals.dart

import 'package:drift/drift.dart';

class Meals extends Table {
  @override
  String get tableName => 'meals';

  IntColumn get id => integer()();
  IntColumn get categoryId => integer().named('category_id')();
  TextColumn get nameEn => text().named('name_en')();
  TextColumn get nameId => text().named('name_id')();
  TextColumn get descriptionEn => text().named('description_en')();
  TextColumn get descriptionId => text().named('description_id')();
  TextColumn get imageAsset => text().named('image_asset')();
  TextColumn get heroImageAsset => text().named('hero_image_asset')();
  TextColumn get period => text()();
  IntColumn get prepMinutes => integer().named('prep_minutes')();

  // nullable in your SQL
  IntColumn get calories => integer().nullable()();
  TextColumn get difficulty => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
