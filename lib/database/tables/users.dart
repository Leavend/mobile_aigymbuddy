// lib/database/tables/users.dart

part of '../app_db.dart';

class Users extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get email => text().withLength(min: 1, max: 255).unique()();
  TextColumn get passwordHash =>
      text().withLength(min: 1, max: 255).named('password_hash')();

  TextColumn get role => text()
      .map(const EnumTextConverter<UserRole>(UserRole.values))
      .withDefault(const Constant('user'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updateAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
