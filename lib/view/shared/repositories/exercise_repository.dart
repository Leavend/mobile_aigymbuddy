import '../models/exercise.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseSummary>> listExercises();
}
