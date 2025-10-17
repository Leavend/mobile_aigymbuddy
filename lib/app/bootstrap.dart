import 'package:go_router/go_router.dart';

import '../data/db/app_database.dart';
import '../data/seed/seed_repository.dart';
import 'app_state.dart';
import 'router.dart';

/// Result of the bootstrap process which contains all lazily created services.
class AppBootstrapData {
  const AppBootstrapData({required this.router});

  final GoRouter router;
}

/// Handles the bootstrap flow for the application so that
/// [AiGymBuddyApp] can stay focused on rendering concerns.
class AppBootstrapper {
  AppBootstrapper(this._database, this._appStateController);

  final AppDatabase _database;
  final AppStateController _appStateController;

  Future<AppBootstrapData> initialize() async {
    final seedRepository = SeedRepository(_database.exerciseDao);
    await seedRepository.seedExercisesIfEmpty();

    final profile = await _database.userProfileDao.getSingle();
    _appStateController.updateHasProfile(profile != null);

    final router = createRouter(_appStateController);
    return AppBootstrapData(router: router);
  }
}
