import 'package:drift/drift.dart';

/// Stores the single local user profile.
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().nullable()();

  // ignore: recursive_getters
  IntColumn get age => integer().check(age.isBiggerOrEqualValue(0))();

  RealColumn get heightCm => real()();

  RealColumn get weightKg => real()();

  TextColumn get gender =>
      // ignore: recursive_getters
      text().check(gender.isIn(const ['male', 'female', 'other']))();

  TextColumn get goal => text().check(
        // ignore: recursive_getters
        goal.isIn(const ['lose_weight', 'build_muscle', 'endurance']),
      )();

  TextColumn get level => text().check(
        // ignore: recursive_getters
        level.isIn(const ['beginner', 'intermediate', 'advanced']),
      )();

  TextColumn get preferredMode =>
      // ignore: recursive_getters
      text().check(preferredMode.isIn(const ['home', 'gym']))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
