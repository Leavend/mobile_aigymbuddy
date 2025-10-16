import '../repositories/progress_repository.dart';

class AddSetToSession {
  const AddSetToSession(this._repository);

  final ProgressRepository _repository;

  Future<void> call({
    required int sessionId,
    required String exerciseName,
    required int setIndex,
    int? reps,
    double? weight,
    String? note,
  }) {
    return _repository.addSet(
      sessionId: sessionId,
      exerciseName: exerciseName,
      setIndex: setIndex,
      reps: reps,
      weight: weight,
      note: note,
    );
  }
}
