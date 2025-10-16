import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/exercises.dart';

part 'exercise_dao.g.dart';

/// DAO untuk menangani operasi baca/tulis untuk tabel [Exercises].
@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);
  Future<void> insertMany(List<ExercisesCompanion> entries) async {
    if (entries.isEmpty) return;

    await batch((batch) {
      batch.insertAll(exercises, entries, mode: InsertMode.insertOrIgnore);
    });
  }

  /// Mengambil daftar exercise yang difilter berdasarkan [mode] dan/atau [difficulty].
  Future<List<Exercise>> list({String? mode, String? difficulty}) {
    final query = select(exercises)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    if (mode != null) {
      query.where((tbl) => tbl.mode.equals(mode) | tbl.mode.equals('both'));
    }

    if (difficulty != null) {
      query.where((tbl) => tbl.difficulty.equals(difficulty));
    }

    return query.get();
  }

  Future<Exercise?> getById(int id) {
    return (select(exercises)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }
}
