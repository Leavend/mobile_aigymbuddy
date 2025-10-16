import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../db/app_database.dart';
import '../db/daos/exercise_dao.dart';

/// Mengisi katalog exercise dari aset saat aplikasi pertama kali dijalankan.
class SeedRepository {
  SeedRepository(this._exerciseDao);

  final ExerciseDao _exerciseDao;

  Future<void> seedExercisesIfEmpty() async {
    final existing = await _exerciseDao.list();
    if (existing.isNotEmpty) {
      return;
    }

    final raw = await rootBundle.loadString('assets/seed/seed_exercises.json');
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;

    final entries = decoded.map((dynamic item) {
      final map = item as Map<String, dynamic>;
      return ExercisesCompanion.insert(
        name: map['name'] as String,
        category: map['category'] as String,
        requiresEquipment: Value(map['requiresEquipment'] as bool),
        equipment: Value(map['equipment'] as String?),
        mode: map['mode'] as String,
        difficulty: map['difficulty'] as String,
      );
    }).toList();

    await _exerciseDao.insertMany(entries);
  }
}
