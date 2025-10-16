import '../repositories/progress_repository.dart';

class FinishSession {
  const FinishSession(this._repository);

  final ProgressRepository _repository;

  Future<void> call({required int sessionId, String? note}) {
    return _repository.finishSession(sessionId: sessionId, note: note);
  }
}
