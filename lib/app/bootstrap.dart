import 'dart:async';

import '../core/session_controller.dart';
import '../data/db/app_database.dart';
import '../data/repositories/progress_local_repository.dart';
import '../data/repositories/user_profile_local_repository.dart';
import '../data/seed/seed_repository.dart';
import '../domain/repositories/progress_repository.dart';
import '../domain/repositories/user_profile_repository.dart';
import '../domain/usecases/add_body_weight_entry.dart';
import '../domain/usecases/add_set_to_session.dart';
import '../domain/usecases/finish_session.dart';
import '../domain/usecases/get_body_weight_history.dart';
import '../domain/usecases/get_user_profile.dart';
import '../domain/usecases/get_weekly_volume.dart';
import '../domain/usecases/start_session.dart';
import '../domain/usecases/upsert_user_profile.dart';
import '../domain/usecases/watch_body_weight_history.dart';
import '../domain/usecases/watch_recent_sessions.dart';
import '../domain/usecases/watch_session_sets.dart';
import '../domain/usecases/watch_user_profile.dart';

class AppDependencies {
  AppDependencies({
    required this.database,
    required this.userProfileRepository,
    required this.progressRepository,
    required this.getUserProfile,
    required this.watchUserProfile,
    required this.upsertUserProfile,
    required this.addBodyWeightEntry,
    required this.watchBodyWeightHistory,
    required this.getBodyWeightHistory,
    required this.getWeeklyVolume,
    required this.watchRecentSessions,
    required this.startSession,
    required this.addSetToSession,
    required this.finishSession,
    required this.watchSessionSets,
    required this.sessionController,
  });

  final AppDatabase database;
  final UserProfileRepository userProfileRepository;
  final ProgressRepository progressRepository;

  final GetUserProfile getUserProfile;
  final WatchUserProfile watchUserProfile;
  final UpsertUserProfile upsertUserProfile;

  final AddBodyWeightEntry addBodyWeightEntry;
  final WatchBodyWeightHistory watchBodyWeightHistory;
  final GetBodyWeightHistory getBodyWeightHistory;
  final GetWeeklyVolume getWeeklyVolume;
  final WatchRecentSessions watchRecentSessions;
  final StartSession startSession;
  final AddSetToSession addSetToSession;
  final FinishSession finishSession;
  final WatchSessionSets watchSessionSets;

  final SessionController sessionController;

  StreamSubscription? _profileSubscription;

  void observeProfile() {
    _profileSubscription ??= watchUserProfile().listen((profile) {
      sessionController.setOnboarded(profile != null);
    });
  }

  Future<void> dispose() async {
    await _profileSubscription?.cancel();
    await database.close();
  }
}

Future<AppDependencies> bootstrap() async {
  final database = AppDatabase();
  final seedRepository = SeedRepository(database.exerciseDao);
  await seedRepository.seedExercisesIfEmpty();

  final userProfileRepository = UserProfileLocalRepository(database.userProfileDao);
  final progressRepository = ProgressLocalRepository(database);

  final dependencies = AppDependencies(
    database: database,
    userProfileRepository: userProfileRepository,
    progressRepository: progressRepository,
    getUserProfile: GetUserProfile(userProfileRepository),
    watchUserProfile: WatchUserProfile(userProfileRepository),
    upsertUserProfile: UpsertUserProfile(userProfileRepository),
    addBodyWeightEntry: AddBodyWeightEntry(progressRepository),
    watchBodyWeightHistory: WatchBodyWeightHistory(progressRepository),
    getBodyWeightHistory: GetBodyWeightHistory(progressRepository),
    getWeeklyVolume: GetWeeklyVolume(progressRepository),
    watchRecentSessions: WatchRecentSessions(progressRepository),
    startSession: StartSession(progressRepository),
    addSetToSession: AddSetToSession(progressRepository),
    finishSession: FinishSession(progressRepository),
    watchSessionSets: WatchSessionSets(progressRepository),
    sessionController: SessionController(
      isOnboarded: (await userProfileRepository.load()) != null,
    ),
  );

  dependencies.observeProfile();

  return dependencies;
}
