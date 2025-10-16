import 'exercise.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseSummary>> listExercises();
}
