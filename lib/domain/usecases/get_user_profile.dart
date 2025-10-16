import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class GetUserProfile {
  const GetUserProfile(this._repository);

  final UserProfileRepository _repository;

  Future<UserProfile?> call() {
    return _repository.load();
  }
}
