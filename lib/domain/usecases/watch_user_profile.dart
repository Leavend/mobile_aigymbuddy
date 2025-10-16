import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class WatchUserProfile {
  const WatchUserProfile(this._repository);

  final UserProfileRepository _repository;

  Stream<UserProfile?> call() {
    return _repository.watch();
  }
}
