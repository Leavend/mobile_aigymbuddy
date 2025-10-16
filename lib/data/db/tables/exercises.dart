// lib/data/db/tables/exercises.dart

import 'package:drift/drift.dart';

/// Defines the 'exercises' table, storing details about each exercise.
class Exercises extends Table {
  /// The unique identifier for the exercise.
  IntColumn get id => integer().autoIncrement()();

  /// The name of the exercise, which must be unique.
  TextColumn get name => text().withLength(min: 1, max: 80)();

  /// The category of the exercise (e.g., upper body, lower body, core).
  // ignore: recursive_getters
  TextColumn get category =>
      // ignore: recursive_getters
      text().check(category.isIn(const ['upper', 'lower', 'core', 'full']))();

  /// A boolean flag indicating if the exercise requires equipment.
  BoolColumn get requiresEquipment =>
      boolean().withDefault(const Constant(false))();

  /// A nullable text field for the name of the equipment required.
  TextColumn get equipment => text().nullable()();

  /// The environment where the exercise can be performed (home, gym, or both).
  // ignore: recursive_getters
  TextColumn get mode =>
      // ignore: recursive_getters
      text().check(mode.isIn(const ['home', 'gym', 'both']))();

  /// The difficulty level of the exercise.
  // ignore: recursive_getters
  TextColumn get difficulty => text()
      // ignore: recursive_getters
      .check(difficulty.isIn(const ['beginner', 'intermediate', 'advanced']))();

  /// Defines the unique constraints for the table.
  /// The error was caused by an incorrect override signature. The base class
  /// expects a nullable List of Sets, so the return type is updated to `List<Set<Column>>?`.
  @override
  List<Set<Column>>? get uniqueKeys => [
        {name}
      ];
}
