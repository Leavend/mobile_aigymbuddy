import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart' as db;
import '../../../data/db/daos/user_profile_dao.dart';
import '../models/user_profile.dart' as domain;
import 'profile_repository.dart';

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
        id: _valueOrAbsent(profile.id),
        name: Value(profile.name),
        age: Value(profile.age),
        heightCm: Value(profile.heightCm),
        weightKg: Value(profile.weightKg),
        gender: Value(profile.gender.dbValue),
        goal: Value(profile.goal.dbValue),
        level: Value(profile.level.dbValue),
        preferredMode: Value(profile.mode.dbValue),
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
      gender: domain.GenderDbMapper.fromDb(row.gender),
      goal: domain.FitnessGoalMapper.fromDb(row.goal),
      level: domain.ExperienceLevelMapper.fromDb(row.level),
      mode: domain.WorkoutModeMapper.fromDb(row.preferredMode),
    );
  }

  Value<T> _valueOrAbsent<T>(T? value) {
    return value == null ? const Value.absent() : Value(value);
  }
}
