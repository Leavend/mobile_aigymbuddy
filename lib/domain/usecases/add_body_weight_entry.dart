import '../entities/weight_entry.dart';
import '../repositories/progress_repository.dart';
import '../repositories/user_profile_repository.dart';

class AddBodyWeightEntry {
  const AddBodyWeightEntry(this._progressRepository, this._userProfileRepository);

  final ProgressRepository _progressRepository;
  final UserProfileRepository _userProfileRepository;

  Future<WeightEntry> call({required double weightKg, DateTime? recordedAt}) {
    return _recordWeight(weightKg: weightKg, recordedAt: recordedAt);
  }

  Future<WeightEntry> _recordWeight({required double weightKg, DateTime? recordedAt}) async {
    final entry =
        await _progressRepository.addBodyWeight(weightKg: weightKg, recordedAt: recordedAt);

    final profile = await _userProfileRepository.load();
    if (profile != null) {
      await _userProfileRepository.updateWeight(profileId: profile.id, weightKg: weightKg);
    }

    return entry;
  }
}
