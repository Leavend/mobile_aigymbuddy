import '../entities/weight_entry.dart';
import '../repositories/progress_repository.dart';

class WatchBodyWeightHistory {
  const WatchBodyWeightHistory(this._repository);

  final ProgressRepository _repository;

  Stream<List<WeightEntry>> call({int days = 30}) {
    return _repository.watchBodyWeightHistory(days: days);
  }
}
