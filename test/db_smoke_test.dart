import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import 'package:aigymbuddy/data/db/app_database.dart';

void main() {
  test('upsert and fetch user profile', () async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await db.userProfileDao.upsert(
      UserProfilesCompanion.insert(
        name: const Value('Test User'),
        age: 30,
        heightCm: 180.0,
        weightKg: 80.0,
        gender: 'male',
        goal: 'lose_weight',
        level: 'beginner',
        preferredMode: 'home',
      ),
    );

    final profile = await db.userProfileDao.getSingle();
    expect(profile, isNotNull);
    expect(profile!.name, 'Test User');
  });
}
