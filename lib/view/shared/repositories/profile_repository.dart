import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> loadProfile();
  Stream<UserProfile?> watchProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> updateWeight({required int id, required double weightKg});
}
