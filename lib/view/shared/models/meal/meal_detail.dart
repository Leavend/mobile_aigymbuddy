// lib/view/shared/models/meal/meal_detail.dart

import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/models/ingredient.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:aigymbuddy/common/models/nutrition_info.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'meal_period.dart';

/// Rich representation of a meal, including instructions and nutrition facts.
@immutable
class MealDetail {
  MealDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.heroImageAsset,
    required this.period,
    required this.prepMinutes,
    required List<NutritionInfo> nutrition,
    required List<Ingredient> ingredients,
    required List<InstructionStep> instructions,
  })  : nutrition = List.unmodifiable(nutrition),
        ingredients = List.unmodifiable(ingredients),
        instructions = List.unmodifiable(instructions);

  static const _nutritionEquality = ListEquality<NutritionInfo>();
  static const _ingredientEquality = ListEquality<Ingredient>();
  static const _instructionEquality = ListEquality<InstructionStep>();

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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MealDetail &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            imageAsset == other.imageAsset &&
            heroImageAsset == other.heroImageAsset &&
            period == other.period &&
            prepMinutes == other.prepMinutes &&
            _nutritionEquality.equals(nutrition, other.nutrition) &&
            _ingredientEquality.equals(ingredients, other.ingredients) &&
            _instructionEquality.equals(instructions, other.instructions);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        imageAsset,
        heroImageAsset,
        period,
        prepMinutes,
        _nutritionEquality.hash(nutrition),
        _ingredientEquality.hash(ingredients),
        _instructionEquality.hash(instructions),
      );
}
