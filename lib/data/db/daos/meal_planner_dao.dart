// lib/data/db/daos/meal_planner_dao.dart

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

import '../app_database.dart';

class MealPlannerStore {
  MealPlannerStore(this._db);

  final AppDatabase _db;

  Future<bool> hasSeedData() async {
    final result = await _db.customSelect(
      'SELECT COUNT(*) AS total FROM meals',
    ).getSingleOrNull();
    final total = result == null ? 0 : (result.data['total'] as int? ?? 0);
    return total > 0;
  }

  Future<void> seedData() async {
    await _db.transaction(() async {
      await _insertAll('meal_categories', _seedCategories);
      await _insertAll('meals', _seedMeals);
      await _insertAll('meal_nutrition_facts', _seedNutritionFacts);
      await _insertAll('meal_ingredients', _seedIngredients);
      await _insertAll('meal_instructions', _seedInstructions);
      await _insertAll('meal_schedule_entries', _seedSchedules());
      await _insertAll(
        'meal_nutrition_progress_entries',
        _seedProgressEntries(),
      );
    });
  }

  Future<List<Map<String, Object?>>> listCategories() {
    return _db.customSelect(
      'SELECT id, name_en, name_id, image_asset FROM meal_categories ORDER BY id',
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> listMealsByCategory(int categoryId) {
    return _db.customSelect(
      'SELECT * FROM meals WHERE category_id = ? ORDER BY name_en',
      variables: [Variable.withInt(categoryId)],
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> listPopularMeals() {
    return _db.customSelect(
      'SELECT * FROM meals ORDER BY id LIMIT 4',
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> searchMealsByName(String query) {
    if (query.isEmpty) {
      return listPopularMeals();
    }
    final pattern = '%${query.toLowerCase()}%';
    return _db.customSelect(
      'SELECT * FROM meals WHERE lower(name_en) LIKE ? OR lower(name_id) LIKE ? '
      'ORDER BY name_en',
      variables: [Variable.withString(pattern), Variable.withString(pattern)],
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Stream<List<Map<String, Object?>>> watchMealsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _scheduleSelectable(start, end)
        .watch()
        .map((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> listMealsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _scheduleSelectable(start, end)
        .get()
        .then((rows) => rows.map((row) => row.data).toList());
  }

  Selectable<Map<String, Object?>> _scheduleSelectable(
    DateTime start,
    DateTime end,
  ) {
    return _db.customSelect(
      'SELECT mse.id AS schedule_id, mse.meal_id AS schedule_meal_id, mse.scheduled_at AS schedule_time, m.* '
      'FROM meal_schedule_entries mse '
      'JOIN meals m ON m.id = mse.meal_id '
      'WHERE mse.scheduled_at >= ? AND mse.scheduled_at < ? '
      'ORDER BY mse.scheduled_at',
      variables: [
        Variable.withString(start.toIso8601String()),
        Variable.withString(end.toIso8601String()),
      ],
      tableNames: const {'meal_schedule_entries', 'meals'},
    );
  }

  Future<Map<String, Object?>?> findMealById(int id) {
    return _db
        .customSelect(
          'SELECT * FROM meals WHERE id = ? LIMIT 1',
          variables: [Variable.withInt(id)],
        )
        .getSingleOrNull()
        .then((row) => row?.data);
  }

  Future<List<Map<String, Object?>>> listNutritionFacts(int mealId) {
    return _db.customSelect(
      'SELECT * FROM meal_nutrition_facts WHERE meal_id = ? ORDER BY id',
      variables: [Variable.withInt(mealId)],
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> listIngredients(int mealId) {
    return _db.customSelect(
      'SELECT * FROM meal_ingredients WHERE meal_id = ? ORDER BY id',
      variables: [Variable.withInt(mealId)],
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> listInstructions(int mealId) {
    return _db.customSelect(
      'SELECT * FROM meal_instructions WHERE meal_id = ? ORDER BY step_order',
      variables: [Variable.withInt(mealId)],
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<List<Map<String, Object?>>> listNutritionProgress(
    DateTime start,
    DateTime end,
  ) {
    return _db.customSelect(
      'SELECT * FROM meal_nutrition_progress_entries WHERE day >= ? AND day <= ? '
      'ORDER BY day',
      variables: [
        Variable.withString(start.toIso8601String()),
        Variable.withString(end.toIso8601String()),
      ],
    ).get().then((rows) => rows.map((row) => row.data).toList());
  }

  Future<Map<int, int>> countMealsPerCategory() async {
    final rows = await _db.customSelect(
      'SELECT category_id, COUNT(*) as total FROM meals GROUP BY category_id',
    ).get();
    return Map.fromEntries(
      rows.map((row) => MapEntry(row.data['category_id'] as int, row.data['total'] as int)),
    );
  }

  Future<Map<String, int>> countMealsPerPeriod() async {
    final rows = await _db.customSelect(
      'SELECT period, COUNT(*) as total FROM meals GROUP BY period',
    ).get();
    return Map.fromEntries(
      rows.map((row) => MapEntry(row.data['period'] as String, row.data['total'] as int)),
    );
  }

  Future<void> _insertAll(
    String table,
    List<Map<String, Object?>> rows,
  ) async {
    await _db.batch((batch) {
      for (final row in rows) {
        final columns = row.keys.join(', ');
        final placeholders = row.keys.map((_) => '?').join(', ');
        final values = row.values.toList();
        batch.customStatement(
          'INSERT OR REPLACE INTO $table ($columns) VALUES ($placeholders)',
          values,
        );
      }
    });
  }
}

final _seedCategories = [
  {
    'id': 1,
    'name_en': 'Salad',
    'name_id': 'Salad',
    'image_asset': 'assets/img/c_1.png',
  },
  {
    'id': 2,
    'name_en': 'Cake',
    'name_id': 'Kue',
    'image_asset': 'assets/img/c_2.png',
  },
  {
    'id': 3,
    'name_en': 'Pie',
    'name_id': 'Pai',
    'image_asset': 'assets/img/c_3.png',
  },
  {
    'id': 4,
    'name_en': 'Smoothies',
    'name_id': 'Smoothies',
    'image_asset': 'assets/img/c_4.png',
  },
];

final _seedMeals = [
  {
    'id': 1,
    'category_id': 2,
    'name_en': 'Blueberry Pancake',
    'name_id': 'Pancake Blueberry',
    'description_en':
        'A fluffy blueberry pancake packed with fibre and natural sweetness.',
    'description_id': 'Pancake blueberry lembut dengan serat dan manis alami.',
    'image_asset': 'assets/img/f_1.png',
    'hero_image_asset': 'assets/img/pancake_1.png',
    'period': 'breakfast',
    'prep_minutes': 30,
    'calories': 230,
    'difficulty': 'Medium',
  },
  {
    'id': 2,
    'category_id': 1,
    'name_en': 'Salmon Nigiri',
    'name_id': 'Salmon Nigiri',
    'description_en': 'Fresh salmon nigiri served with warm rice.',
    'description_id': 'Nigiri salmon segar dengan nasi hangat.',
    'image_asset': 'assets/img/m_1.png',
    'hero_image_asset': 'assets/img/nigiri.png',
    'period': 'breakfast',
    'prep_minutes': 20,
    'calories': 180,
    'difficulty': 'Medium',
  },
  {
    'id': 3,
    'category_id': 2,
    'name_en': 'Honey Pancake',
    'name_id': 'Pancake Madu',
    'description_en': 'Golden pancake drizzled with warm honey.',
    'description_id': 'Pancake keemasan dengan siraman madu hangat.',
    'image_asset': 'assets/img/rd_1.png',
    'hero_image_asset': 'assets/img/pancake_1.png',
    'period': 'breakfast',
    'prep_minutes': 25,
    'calories': 200,
    'difficulty': 'Easy',
  },
  {
    'id': 4,
    'category_id': 3,
    'name_en': 'Apple Pie',
    'name_id': 'Pai Apel',
    'description_en': 'Classic apple pie with cinnamon aroma.',
    'description_id': 'Pai apel klasik dengan aroma kayu manis.',
    'image_asset': 'assets/img/apple_pie.png',
    'hero_image_asset': 'assets/img/apple_pie.png',
    'period': 'snack',
    'prep_minutes': 45,
    'calories': 260,
    'difficulty': 'Medium',
  },
  {
    'id': 5,
    'category_id': 1,
    'name_en': 'Chicken Steak',
    'name_id': 'Steak Ayam',
    'description_en': 'Lean grilled chicken steak with veggies.',
    'description_id': 'Steak ayam panggang dengan sayuran segar.',
    'image_asset': 'assets/img/chicken.png',
    'hero_image_asset': 'assets/img/chicken.png',
    'period': 'lunch',
    'prep_minutes': 35,
    'calories': 420,
    'difficulty': 'Hard',
  },
  {
    'id': 6,
    'category_id': 4,
    'name_en': 'Lowfat Milk',
    'name_id': 'Susu Rendah Lemak',
    'description_en': 'A refreshing glass of low-fat milk.',
    'description_id': 'Segelas susu rendah lemak yang menyegarkan.',
    'image_asset': 'assets/img/m_2.png',
    'hero_image_asset': 'assets/img/m_2.png',
    'period': 'breakfast',
    'prep_minutes': 5,
    'calories': 120,
    'difficulty': 'Easy',
  },
  {
    'id': 7,
    'category_id': 4,
    'name_en': 'Coffee',
    'name_id': 'Kopi',
    'description_en': 'Warm cup of coffee to start the day.',
    'description_id': 'Secangkir kopi hangat untuk memulai hari.',
    'image_asset': 'assets/img/coffee.png',
    'hero_image_asset': 'assets/img/coffee.png',
    'period': 'breakfast',
    'prep_minutes': 5,
    'calories': 20,
    'difficulty': 'Easy',
  },
  {
    'id': 8,
    'category_id': 1,
    'name_en': 'Orange Slices',
    'name_id': 'Irisan Jeruk',
    'description_en': 'Fresh orange slices rich in vitamin C.',
    'description_id': 'Irisan jeruk segar kaya vitamin C.',
    'image_asset': 'assets/img/orange.png',
    'hero_image_asset': 'assets/img/orange.png',
    'period': 'snack',
    'prep_minutes': 3,
    'calories': 60,
    'difficulty': 'Easy',
  },
  {
    'id': 9,
    'category_id': 1,
    'name_en': 'Green Salad',
    'name_id': 'Salad Hijau',
    'description_en': 'Balanced salad with crisp vegetables.',
    'description_id': 'Salad seimbang dengan sayuran renyah.',
    'image_asset': 'assets/img/salad.png',
    'hero_image_asset': 'assets/img/salad.png',
    'period': 'dinner',
    'prep_minutes': 15,
    'calories': 180,
    'difficulty': 'Easy',
  },
  {
    'id': 10,
    'category_id': 4,
    'name_en': 'Oatmeal Bowl',
    'name_id': 'Semangkuk Oatmeal',
    'description_en': 'Comforting oatmeal with nuts and fruit.',
    'description_id': 'Oatmeal hangat dengan kacang dan buah.',
    'image_asset': 'assets/img/oatmeal.png',
    'hero_image_asset': 'assets/img/oatmeal.png',
    'period': 'dinner',
    'prep_minutes': 20,
    'calories': 240,
    'difficulty': 'Easy',
  },
];

final _seedNutritionFacts = [
  {
    'id': 1,
    'meal_id': 1,
    'image_asset': 'assets/img/burn.png',
    'title_en': 'Calories',
    'title_id': 'Kalori',
    'value_en': '230',
    'value_id': '230',
  },
  {
    'id': 2,
    'meal_id': 1,
    'image_asset': 'assets/img/proteins.png',
    'title_en': 'Proteins',
    'title_id': 'Protein',
    'value_en': '8g',
    'value_id': '8g',
  },
  {
    'id': 3,
    'meal_id': 1,
    'image_asset': 'assets/img/egg.png',
    'title_en': 'Fats',
    'title_id': 'Lemak',
    'value_en': '6g',
    'value_id': '6g',
  },
  {
    'id': 4,
    'meal_id': 1,
    'image_asset': 'assets/img/carbo.png',
    'title_en': 'Carbo',
    'title_id': 'Karbo',
    'value_en': '32g',
    'value_id': '32g',
  },
  {
    'id': 5,
    'meal_id': 2,
    'image_asset': 'assets/img/burn.png',
    'title_en': 'Calories',
    'title_id': 'Kalori',
    'value_en': '180',
    'value_id': '180',
  },
  {
    'id': 6,
    'meal_id': 2,
    'image_asset': 'assets/img/proteins.png',
    'title_en': 'Proteins',
    'title_id': 'Protein',
    'value_en': '12g',
    'value_id': '12g',
  },
  {
    'id': 7,
    'meal_id': 2,
    'image_asset': 'assets/img/egg.png',
    'title_en': 'Fats',
    'title_id': 'Lemak',
    'value_en': '7g',
    'value_id': '7g',
  },
  {
    'id': 8,
    'meal_id': 2,
    'image_asset': 'assets/img/carbo.png',
    'title_en': 'Carbo',
    'title_id': 'Karbo',
    'value_en': '15g',
    'value_id': '15g',
  },
  {
    'id': 9,
    'meal_id': 3,
    'image_asset': 'assets/img/burn.png',
    'title_en': 'Calories',
    'title_id': 'Kalori',
    'value_en': '200',
    'value_id': '200',
  },
  {
    'id': 10,
    'meal_id': 3,
    'image_asset': 'assets/img/proteins.png',
    'title_en': 'Proteins',
    'title_id': 'Protein',
    'value_en': '6g',
    'value_id': '6g',
  },
  {
    'id': 11,
    'meal_id': 3,
    'image_asset': 'assets/img/egg.png',
    'title_en': 'Fats',
    'title_id': 'Lemak',
    'value_en': '5g',
    'value_id': '5g',
  },
  {
    'id': 12,
    'meal_id': 3,
    'image_asset': 'assets/img/carbo.png',
    'title_en': 'Carbo',
    'title_id': 'Karbo',
    'value_en': '28g',
    'value_id': '28g',
  },
];

final _seedIngredients = [
  {
    'id': 1,
    'meal_id': 1,
    'image_asset': 'assets/img/flour.png',
    'name_en': 'Whole grain flour',
    'name_id': 'Tepung gandum',
    'amount_en': '120 g',
    'amount_id': '120 g',
  },
  {
    'id': 2,
    'meal_id': 1,
    'image_asset': 'assets/img/eggs.png',
    'name_en': 'Eggs',
    'name_id': 'Telur',
    'amount_en': '2 pcs',
    'amount_id': '2 butir',
  },
  {
    'id': 3,
    'meal_id': 1,
    'image_asset': 'assets/img/bottle.png',
    'name_en': 'Low fat milk',
    'name_id': 'Susu rendah lemak',
    'amount_en': '200 ml',
    'amount_id': '200 ml',
  },
  {
    'id': 4,
    'meal_id': 1,
    'image_asset': 'assets/img/orange.png',
    'name_en': 'Blueberries',
    'name_id': 'Blueberry',
    'amount_en': '1 cup',
    'amount_id': '1 cangkir',
  },
  {
    'id': 5,
    'meal_id': 2,
    'image_asset': 'assets/img/nigiri.png',
    'name_en': 'Fresh salmon',
    'name_id': 'Salmon segar',
    'amount_en': '120 g',
    'amount_id': '120 g',
  },
  {
    'id': 6,
    'meal_id': 2,
    'image_asset': 'assets/img/flour.png',
    'name_en': 'Sushi rice',
    'name_id': 'Nasi sushi',
    'amount_en': '1 cup',
    'amount_id': '1 cangkir',
  },
];

final _seedInstructions = [
  {
    'id': 1,
    'meal_id': 1,
    'step_order': 1,
    'title_en': 'Prepare batter',
    'title_id': 'Siapkan adonan',
    'description_en':
        'Mix flour, eggs, and milk until smooth then fold the blueberries.',
    'description_id':
        'Campurkan tepung, telur, dan susu hingga rata lalu masukkan blueberry.',
  },
  {
    'id': 2,
    'meal_id': 1,
    'step_order': 2,
    'title_en': 'Cook pancakes',
    'title_id': 'Masak pancake',
    'description_en':
        'Pour a ladle of batter onto a heated pan and cook both sides.',
    'description_id': 'Tuang adonan ke wajan panas dan masak kedua sisinya.',
  },
  {
    'id': 3,
    'meal_id': 1,
    'step_order': 3,
    'title_en': 'Serve',
    'title_id': 'Sajikan',
    'description_en':
        'Stack the pancakes and drizzle with honey before serving.',
    'description_id': 'Tumpuk pancake dan beri madu sebelum disajikan.',
  },
  {
    'id': 4,
    'meal_id': 2,
    'step_order': 1,
    'title_en': 'Shape rice',
    'title_id': 'Bentuk nasi',
    'description_en':
        'Shape the sushi rice into bite-sized portions using damp hands.',
    'description_id':
        'Bentuk nasi sushi menjadi ukuran sekali makan dengan tangan basah.',
  },
  {
    'id': 5,
    'meal_id': 2,
    'step_order': 2,
    'title_en': 'Add salmon',
    'title_id': 'Tambahkan salmon',
    'description_en':
        'Place a slice of salmon on each rice portion and gently press.',
    'description_id':
        'Letakkan irisan salmon pada setiap nasi dan tekan perlahan.',
  },
];

List<Map<String, Object?>> _seedSchedules() {
  final now = DateTime.now();
  final base = DateTime(now.year, now.month, now.day);
  return [
    {
      'id': 1,
      'meal_id': 2,
      'scheduled_at': base.add(const Duration(hours: 7)).toIso8601String(),
    },
    {
      'id': 2,
      'meal_id': 6,
      'scheduled_at': base.add(const Duration(hours: 8)).toIso8601String(),
    },
    {
      'id': 3,
      'meal_id': 5,
      'scheduled_at': base.add(const Duration(hours: 13)).toIso8601String(),
    },
    {
      'id': 4,
      'meal_id': 8,
      'scheduled_at': base.add(const Duration(hours: 16, minutes: 30)).toIso8601String(),
    },
    {
      'id': 5,
      'meal_id': 9,
      'scheduled_at': base.add(const Duration(hours: 19, minutes: 10)).toIso8601String(),
    },
    {
      'id': 6,
      'meal_id': 10,
      'scheduled_at': base.add(const Duration(hours: 20, minutes: 10)).toIso8601String(),
    },
  ];
}

List<Map<String, Object?>> _seedProgressEntries() {
  final today = DateTime.now();
  final end = DateTime(today.year, today.month, today.day);
  final start = end.subtract(const Duration(days: 6));
  final values = [0.35, 0.7, 0.4, 0.8, 0.25, 0.7, 0.35];
  return values
      .mapIndexed(
        (index, value) => {
          'id': index + 1,
          'day': start.add(Duration(days: index)).toIso8601String(),
          'completion': value * 100,
        },
      )
      .toList();
}
