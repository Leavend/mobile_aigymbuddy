// lib/view/shared/repositories/drift_exercise_repository.dart

import 'package:aigymbuddy/data/db/daos/exercise_dao.dart';
import 'package:aigymbuddy/data/db/app_database.dart' show Exercise;
import '../models/exercise.dart';
import 'exercise_repository.dart';

class DriftExerciseRepository implements ExerciseRepository {
  DriftExerciseRepository(this._dao);

  final ExerciseDao _dao;

  @override
  Future<List<ExerciseSummary>> listExercises() async {
    final rows = await _dao.list();
    return List.unmodifiable(rows.map(_mapRow));
  }

  ExerciseSummary _mapRow(Exercise row) {
    return ExerciseSummary(
      id: row.id,
      name: row.name,
      difficulty: row.difficulty,
      mode: row.mode,
    );
  }
}
