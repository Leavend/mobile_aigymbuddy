import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import 'data/db/app_database.dart';
import 'data/seed/seed_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final seedRepository = SeedRepository(database.exerciseDao);
  await seedRepository.seedExercisesIfEmpty();

  final profileDao = database.userProfileDao;
  final profile = await profileDao.getSingle();
  if (profile == null) {
    await profileDao.upsert(
      UserProfilesCompanion.insert(
        name: const Value('Alex Gymgoer'),
        age: 28,
        heightCm: 175.0,
        weightKg: 72.5,
        gender: 'other',
        goal: 'build_muscle',
        level: 'intermediate',
        preferredMode: 'gym',
      ),
    );
  }

  runApp(DatabaseDemoApp(database: database));
}

class DatabaseDemoApp extends StatefulWidget {
  const DatabaseDemoApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<DatabaseDemoApp> createState() => _DatabaseDemoAppState();
}

class _DatabaseDemoAppState extends State<DatabaseDemoApp> {
  @override
  void dispose() {
    widget.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Gym Buddy Drift Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DemoHome(database: widget.database),
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drift Setup Check')),
      body: FutureBuilder<UserProfile?>(
        future: database.userProfileDao.getSingle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('No profile stored yet.'));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${profile.name ?? 'Gym Buddy'}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text('Goal: ${profile.goal}'),
                Text('Level: ${profile.level}'),
                const SizedBox(height: 24),
                FutureBuilder<int>(
                  future: database.exerciseDao.list().then(
                        (value) => value.length,
                      ),
                  builder: (context, exercisesSnapshot) {
                    if (exercisesSnapshot.connectionState !=
                        ConnectionState.done) {
                      return const CircularProgressIndicator();
                    }

                    return Text(
                      'Seeded exercises: ${exercisesSnapshot.data ?? 0}',
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
