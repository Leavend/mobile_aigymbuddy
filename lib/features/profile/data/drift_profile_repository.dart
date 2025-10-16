import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart' as db;
import '../../../data/db/daos/user_profile_dao.dart';
import '../../profile/domain/profile_repository.dart';
import '../../profile/domain/user_profile.dart' as domain;

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._dao);

  final UserProfileDao _dao;

  @override
  Future<domain.UserProfile?> loadProfile() async {
    final row = await _dao.getSingle();
    if (row == null) {
      return null;
    }
    return _mapRow(row);
  }

  @override
  Stream<domain.UserProfile?> watchProfile() {
    return _dao.watchSingle().map((row) => row == null ? null : _mapRow(row));
  }

  @override
  Future<void> saveProfile(domain.UserProfile profile) {
    return _dao.upsert(
      db.UserProfilesCompanion(
        id:
            profile.id == null ? const Value.absent() : Value(profile.id!),
        name: Value(profile.name),
        age: Value(profile.age),
        heightCm: Value(profile.heightCm),
        weightKg: Value(profile.weightKg),
        gender: Value(domain.genderToDb(profile.gender)),
        goal: Value(domain.goalToDb(profile.goal)),
        level: Value(domain.levelToDb(profile.level)),
        preferredMode: Value(domain.modeToDb(profile.mode)),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> updateWeight({required int id, required double weightKg}) {
    return _dao.updateWeight(id, weightKg);
  }

  domain.UserProfile _mapRow(db.UserProfile row) {
    return domain.UserProfile(
      id: row.id,
      name: row.name,
      age: row.age,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      gender: domain.genderFromDb(row.gender),
      goal: domain.goalFromDb(row.goal),
      level: domain.levelFromDb(row.level),
      mode: domain.modeFromDb(row.preferredMode),
    );
  }
}
