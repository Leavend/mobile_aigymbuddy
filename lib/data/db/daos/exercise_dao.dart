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
    final normalizedMode = mode?.trim();
    final normalizedDifficulty = difficulty?.trim();

    final query = select(exercises)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    if (normalizedMode != null && normalizedMode.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.mode.equals(normalizedMode) | tbl.mode.equals('both'),
      );
    }

    if (normalizedDifficulty != null && normalizedDifficulty.isNotEmpty) {
      query.where((tbl) => tbl.difficulty.equals(normalizedDifficulty));
    }

    return query.get();
  }

  Future<Exercise?> getById(int id) {
    return (select(exercises)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }
}
