import '../../domain/entities/user_profile.dart' as domain;
import '../../domain/repositories/user_profile_repository.dart';
import '../db/daos/user_profile_dao.dart';
import '../mappers/user_profile_mapper.dart';

class UserProfileLocalRepository implements UserProfileRepository {
  UserProfileLocalRepository(this._dao, [this._mapper = const UserProfileMapper()]);

  final UserProfileDao _dao;
  final UserProfileMapper _mapper;

  @override
  Future<domain.UserProfile?> load() async {
    final profile = await _dao.getSingle();
    return _mapper.toDomain(profile);
  }

  @override
  Stream<domain.UserProfile?> watch() {
    return _dao.watchSingle().map(_mapper.toDomain);
  }

  @override
  Future<domain.UserProfile> upsert(domain.UserProfile profile) async {
    final companion = _mapper.toCompanion(profile);
    final id = await _dao.upsert(companion);
    final stored = await _dao.getSingle();
    return _mapper.toDomain(stored) ??
        domain.UserProfile(
          id: id,
          name: profile.name,
          age: profile.age,
          heightCm: profile.heightCm,
          weightKg: profile.weightKg,
          gender: profile.gender,
          goal: profile.goal,
          level: profile.level,
          preferredMode: profile.preferredMode,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        );
  }

  @override
  Future<void> updateWeight({required int profileId, required double weightKg}) {
    return _dao.updateWeight(profileId, weightKg);
  }
}
