import 'package:drift/drift.dart';

import 'workouts.dart';

/// Workout execution logs for a given plan.
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get startedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  DateTimeColumn get endedAt => dateTime().nullable()();

  TextColumn get note => text().nullable()();
}
