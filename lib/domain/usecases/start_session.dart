import '../repositories/progress_repository.dart';

class StartSession {
  const StartSession(this._repository);

  final ProgressRepository _repository;

  Future<int> call({
    required String title,
    String? note,
    required String goal,
    required String level,
    required String mode,
  }) {
    return _repository.startSession(
      title: title,
      note: note,
      goal: goal,
      level: level,
      mode: mode,
    );
  }
}
