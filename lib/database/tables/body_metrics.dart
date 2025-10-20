// lib/database/tables/body_metrics.dart

part of '../app_db.dart';

class BodyMetrics extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  
  TextColumn get userId => text().named('user_id').customConstraint('REFERENCES users(id) ON DELETE CASCADE')();
  DateTimeColumn get loggedAt => dateTime().named('logged_at').withDefault(currentDateAndTime)();
  RealColumn get weightKg => real().named('weight_kg')();
  RealColumn get bodyFatPct => real().named('body_fat_pct').nullable()();
  TextColumn get notes => text().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(user_id, logged_at)'
  ];

  @override
  Set<Column> get primaryKey => {id};
}