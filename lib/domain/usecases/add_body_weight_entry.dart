import '../entities/weight_entry.dart';
import '../repositories/progress_repository.dart';

class AddBodyWeightEntry {
  const AddBodyWeightEntry(this._repository);

  final ProgressRepository _repository;

  Future<WeightEntry> call({required double weightKg, DateTime? recordedAt}) {
    return _repository.addBodyWeight(weightKg: weightKg, recordedAt: recordedAt);
  }
}
