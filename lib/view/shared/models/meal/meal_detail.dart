// lib/view/shared/models/meal/meal_detail.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/models/ingredient.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:aigymbuddy/common/models/nutrition_info.dart';
import 'meal_period.dart';

class MealDetail {
  MealDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.heroImageAsset,
    required this.period,
    required this.prepMinutes,
    required this.nutrition,
    required this.ingredients,
    required this.instructions,
  });

  final int id;
  final LocalizedText name;
  final LocalizedText description;
  final String imageAsset;
  final String heroImageAsset;
  final MealPeriod period;
  final int prepMinutes;
  final List<NutritionInfo> nutrition;
  final List<Ingredient> ingredients;
  final List<InstructionStep> instructions;

  String localizedName(AppLanguage language) => name.resolve(language);

  String localizedDescription(AppLanguage language) =>
      description.resolve(language);
}
