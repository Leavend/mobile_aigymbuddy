import 'package:drift/drift.dart';

/// Stores historical body weight entries for the user.
class BodyWeightEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get weightKg => real()();

  DateTimeColumn get recordedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
