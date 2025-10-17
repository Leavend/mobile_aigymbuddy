// lib/data/db/daos/user_profile_dao.dart

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user_profiles.dart';
import 'dao_utils.dart';

part 'user_profile_dao.g.dart';

/// DAO encapsulating operations for the single user profile row.
@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  // ignore: use_super_parameters
  UserProfileDao(AppDatabase db, {UtcNow now = defaultUtcNow})
      : _now = now,
        super(db);

  final UtcNow _now;

  /// Upserts the provided [UserProfilesCompanion].
  Future<int> upsert(UserProfilesCompanion entry) {
    return into(userProfiles).insertOnConflictUpdate(entry);
  }

  /// Returns the stored profile or null when not available.
  Future<UserProfile?> getSingle() {
    return select(userProfiles).getSingleOrNull();
  }

  /// Watches the stored profile and emits null when absent.
  Stream<UserProfile?> watchSingle() {
    return select(userProfiles).watchSingleOrNull();
  }

  /// Updates the weight for the profile identified by [id].
  Future<void> updateWeight(int id, double weightKg) {
    return (update(userProfiles)..where((tbl) => tbl.id.equals(id))).write(
      UserProfilesCompanion(
        weightKg: Value(weightKg),
        updatedAt: Value(_now()),
      ),
    );
  }
}
