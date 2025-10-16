import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class UpsertUserProfile {
  const UpsertUserProfile(this._repository);

  final UserProfileRepository _repository;

  Future<UserProfile> call(UserProfile profile) {
    return _repository.upsert(profile);
  }
}
