import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/exercises.dart';

part 'exercise_dao.g.dart';

/// DAO handling read/write operations for [Exercises].
@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(AppDatabase db) : super(db);

  /// Inserts many exercise rows ignoring duplicates.
  Future<void> insertMany(List<ExercisesCompanion> entries) async {
    if (entries.isEmpty) {
      return;
    }

    await batch((batch) {
      batch.insertAllOnConflictOrIgnore(exercises, entries);
    });
  }

  /// Lists exercises filtered by [mode] and/or [difficulty].
  Future<List<Exercise>> list({String? mode, String? difficulty}) {
    final query = select(exercises)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    if (mode != null) {
      query.where(
        (tbl) => tbl.mode.equals(mode) | tbl.mode.equals('both'),
      );
    }

    if (difficulty != null) {
      query.where((tbl) => tbl.difficulty.equals(difficulty));
    }

    return query.get();
  }
}
