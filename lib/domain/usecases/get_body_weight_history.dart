import '../entities/weight_entry.dart';
import '../repositories/progress_repository.dart';

class GetBodyWeightHistory {
  const GetBodyWeightHistory(this._repository);

  final ProgressRepository _repository;

  Future<List<WeightEntry>> call({int days = 30}) {
    return _repository.loadBodyWeightHistory(days: days);
  }
}
