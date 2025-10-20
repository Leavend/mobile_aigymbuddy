// lib/database/tables/workout_plans.dart

part of '../app_db.dart';

class WorkoutPlans extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get userId => text()
      .named('user_id')
      .nullable()
      .customConstraint('NULL REFERENCES users(id) ON DELETE SET NULL')();
  TextColumn get name => text()();
  TextColumn get goal =>
      text().map(const EnumTextConverter<Goal>(Goal.values))();
  TextColumn get difficulty =>
      text().map(const EnumTextConverter<Difficulty>(Difficulty.values))();
  TextColumn get location =>
      text().map(const EnumTextConverter<LocationPref>(LocationPref.values))();
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(false))();
  DateTimeColumn get startDate => dateTime().named('start_date').nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
