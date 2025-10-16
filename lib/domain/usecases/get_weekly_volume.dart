import '../entities/progress_models.dart';
import '../repositories/progress_repository.dart';

class GetWeeklyVolume {
  const GetWeeklyVolume(this._repository);

  final ProgressRepository _repository;

  Future<List<WeeklyVolumePoint>> call({int weeks = 6}) {
    return _repository.loadWeeklyVolume(weeks: weeks);
  }
}
