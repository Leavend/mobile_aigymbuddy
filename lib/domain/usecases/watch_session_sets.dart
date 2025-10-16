import '../entities/progress_models.dart';
import '../repositories/progress_repository.dart';

class WatchSessionSets {
  const WatchSessionSets(this._repository);

  final ProgressRepository _repository;

  Stream<List<LoggedSet>> call(int sessionId) {
    return _repository.watchSessionSets(sessionId);
  }
}
