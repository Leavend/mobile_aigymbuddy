// lib/database/app_db.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'type_converters.dart';

part 'tables/users.dart';
part 'tables/user_profiles.dart';
part 'tables/exercises.dart';
part 'tables/body_metrics.dart';
part 'tables/muscles.dart';
part 'tables/exercise_muscles.dart';
part 'tables/equipment.dart';
part 'tables/exercise_equipment.dart';
part 'tables/workout_plans.dart';
part 'tables/workout_plan_days.dart';
part 'tables/workout_plan_exercises.dart';
part 'tables/workout_sessions.dart';
part 'tables/session_exercises.dart';
part 'tables/session_sets.dart';
part 'tables/ai_chat_messages.dart';

part 'daos/users_dao.dart';
part 'daos/body_metrics_dao.dart';
part 'daos/workout_plans_dao.dart';

part 'app_db.g.dart';

// Anotasi @DriftDatabase untuk memberitahu generator
// tabel/dao mana saja yang harus disertakan.
@DriftDatabase(
  tables: [
    Users,
    UserProfiles,
    Exercises,
    BodyMetrics,
    Muscles,
    ExerciseMuscles,
    Equipment,
    ExerciseEquipment,
    WorkoutPlans,
    WorkoutPlanDays,
    WorkoutPlanExercises,
    WorkoutSessions,
    SessionExercises,
    SessionSets,
    AiChatMessages,
  ],
  daos: [
    UsersDao,
    BodyMetricsDao,
    WorkoutPlansDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Constructor
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gym_buddy.db'));
    return NativeDatabase(file);
  });
}