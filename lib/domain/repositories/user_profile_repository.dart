import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> load();
  Stream<UserProfile?> watch();
  Future<UserProfile> upsert(UserProfile profile);
  Future<void> updateWeight({required int profileId, required double weightKg});
}
