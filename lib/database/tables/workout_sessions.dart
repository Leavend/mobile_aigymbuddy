// lib/databases/tables/workout_sessions.dart

part of '../app_db.dart';

class WorkoutSessions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get planId => text()
      .named('plan_id')
      .nullable()
      .customConstraint(
        'NULL REFERENCES workout_plans(id) ON DELETE SET NULL',
      )();
  TextColumn get planDayId => text()
      .named('plan_day_id')
      .nullable()
      .customConstraint(
        'NULL REFERENCES workout_plan_days(id) ON DELETE SET NULL',
      )();
  DateTimeColumn get startedAt =>
      dateTime().named('started_at').withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().named('ended_at').nullable()();
  TextColumn get location =>
      text().map(const EnumTextConverter<LocationPref>(LocationPref.values))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
