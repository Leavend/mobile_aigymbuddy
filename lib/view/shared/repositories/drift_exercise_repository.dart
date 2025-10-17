import '../models/exercise.dart';
import '../../../data/db/daos/exercise_dao.dart';
import 'exercise_repository.dart';

class DriftExerciseRepository implements ExerciseRepository {
  DriftExerciseRepository(this._dao);

  final ExerciseDao _dao;

  @override
  Future<List<ExerciseSummary>> listExercises() async {
    final rows = await _dao.list();
    return rows
        .map(
          (row) => ExerciseSummary(
            id: row.id,
            name: row.name,
            difficulty: row.difficulty,
            mode: row.mode,
          ),
        )
        .toList();
  }
}
