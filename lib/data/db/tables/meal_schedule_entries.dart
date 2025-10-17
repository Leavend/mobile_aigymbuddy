// lib/data/db/tables/meal_schedule_entries.dart

import 'package:drift/drift.dart';

class MealScheduleEntries extends Table {
  @override
  String get tableName => 'meal_schedule_entries';

  IntColumn get id => integer()(); // PRIMARY KEY
  IntColumn get mealId => integer().named('meal_id')();

  // Your SQL stores this as TEXT ISO-8601; keep it text to match.
  TextColumn get scheduledAt => text().named('scheduled_at')();

  @override
  Set<Column> get primaryKey => {id};
}
