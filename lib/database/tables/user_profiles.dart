// lib/database/tables/user_profiles.dart

part of '../app_db.dart';

class UserProfiles extends Table {
  TextColumn get userId => text().named('user_id').customConstraint('REFERENCES users(id) ON DELETE CASCADE UNIQUE')();
  
  TextColumn get displayName => text().named('display_name')();
  TextColumn get gender => text().map(const EnumTextConverter<Gender>(Gender.values))();
  DateTimeColumn get dob => dateTime().nullable()();

  RealColumn get heightCm => real().named('height_cm')();
  TextColumn get level => text().map(const EnumTextConverter<Level>(Level.values))();
  TextColumn get goal => text().map(const EnumTextConverter<Goal>(Goal.values))();
  TextColumn get locationPref => text().named('location_pref').map(const EnumTextConverter<LocationPref>(LocationPref.values))();
}