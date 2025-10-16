import 'package:drift/drift.dart';

/// Exercise catalog covering both home and gym movements.
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 80)();

  TextColumn get category =>
      text().check(category.isIn(const ['upper', 'lower', 'core', 'full']))();

  BoolColumn get requiresEquipment =>
      boolean().withDefault(const Constant(false))();

  TextColumn get equipment => text().nullable()();

  TextColumn get mode =>
      text().check(mode.isIn(const ['home', 'gym', 'both']))();

  TextColumn get difficulty => text()
      .check(difficulty.isIn(const ['beginner', 'intermediate', 'advanced']))();

  @override
  Set<Index> get indexes => {
        Index('idx_exercises_mode_difficulty', [mode, difficulty]),
      };

  @override
  Set<Set<Column<Object?>>> get uniqueKeys => {
        {name, mode, difficulty},
      };
}
