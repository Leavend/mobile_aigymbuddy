import '../entities/progress_models.dart';
import '../repositories/progress_repository.dart';

class WatchRecentSessions {
  const WatchRecentSessions(this._repository);

  final ProgressRepository _repository;

  Stream<List<SessionSummary>> call({int limit = 10}) {
    return _repository.watchRecentSessions(limit: limit);
  }
}
