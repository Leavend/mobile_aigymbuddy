import 'package:drift/drift.dart';

/// Workout plan header stored per day or template.
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  TextColumn get goal => text().check(
        // ignore: recursive_getters
        goal.isIn(const ['lose_weight', 'build_muscle', 'endurance']),
      )();

  TextColumn get level => text().check(
        // ignore: recursive_getters
        level.isIn(const ['beginner', 'intermediate', 'advanced']),
      )();

  // ignore: recursive_getters
  TextColumn get mode => text().check(mode.isIn(const ['home', 'gym']))();

  DateTimeColumn get scheduledFor => dateTime().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
