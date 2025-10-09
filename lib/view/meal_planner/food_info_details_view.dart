import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/ingredient.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:aigymbuddy/common/models/nutrition_info.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

import '../../common_widget/food_step_detail_row.dart';

class FoodInfoDetailsView extends StatelessWidget {
  const FoodInfoDetailsView({
    super.key,
    required this.detail,
    required this.meal,
  });

  final Map<String, dynamic> meal;
  final Map<String, dynamic> detail;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;
    final localize = context.localize;

    final nutritionItems = _FoodInfoContent.nutrition(language);
    final ingredients = _FoodInfoContent.ingredients(language);
    final steps = _FoodInfoContent.steps(language);
    final description = localize(_FoodInfoStrings.description);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (_, _) => [
          _buildTopAppBar(context),
          _buildHeroAppBar(media, language),
        ],
        body: Container(
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                _buildContent(
                  context,
                  media,
                  language,
                  nutritionItems,
                  ingredients,
                  steps,
                  description,
                ),
                _buildBottomAction(context, language),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leading: InkWell(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            'assets/img/black_btn.png',
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 8), child: _MoreButton()),
      ],
    );
  }

  Widget _buildHeroAppBar(Size media, AppLanguage language) {
    final heroImage = _resolveLocalized(
      detail['b_image'],
      language,
      fallback: detail['image']?.toString(),
    );

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      expandedHeight: media.width * 0.5,
      flexibleSpace: ClipRect(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Transform.scale(
              scale: 1.25,
              child: Container(
                width: media.width * 0.55,
                height: media.width * 0.55,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(media.width * 0.275),
                ),
              ),
            ),
            Transform.scale(
              scale: 1.25,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  heroImage,
                  width: media.width * 0.5,
                  height: media.width * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Size media,
    AppLanguage language,
    List<NutritionInfo> nutritionItems,
    List<Ingredient> ingredients,
    List<InstructionStep> steps,
    String description,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: TColor.gray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          SizedBox(height: media.width * 0.05),
          _buildTitleSection(context, language),
          SizedBox(height: media.width * 0.05),
          _buildNutritionSection(context, nutritionItems),
          SizedBox(height: media.width * 0.05),
          _buildDescriptionSection(context, description),
          const SizedBox(height: 15),
          _buildIngredientSection(context, media, ingredients, language),
          _buildStepsSection(context, steps, language),
          SizedBox(height: media.width * 0.25),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, AppLanguage language) {
    final title = _resolveLocalized(detail['name'], language);
    final author = context.localize(_FoodInfoStrings.byAuthor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/img/fav.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection(
    BuildContext context,
    List<NutritionInfo> nutritionItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            context.localize(_FoodInfoStrings.nutritionTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: nutritionItems.length,
            itemBuilder: (_, index) {
              final nutrition = nutritionItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColor.primaryColor2.withValues(alpha: 0.4),
                      TColor.primaryColor1.withValues(alpha: 0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      nutrition.image,
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nutrition.title,
                            style: TextStyle(color: TColor.black, fontSize: 12),
                          ),
                          Text(
                            nutrition.value,
                            style: TextStyle(color: TColor.gray, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, String description) {
    final moreLabel = context.localize(_FoodInfoStrings.readMoreLabel);
    final lessLabel = context.localize(_FoodInfoStrings.readLessLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            context.localize(_FoodInfoStrings.descriptionTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ReadMoreText(
            description,
            trimLines: 4,
            colorClickableText: TColor.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' $moreLabel',
            trimExpandedText: ' $lessLabel',
            style: TextStyle(color: TColor.gray, fontSize: 12),
            moreStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientSection(
    BuildContext context,
    Size media,
    List<Ingredient> ingredients,
    AppLanguage language,
  ) {
    final totalLabel = _FoodInfoStrings.ingredientsCount(
      language,
      ingredients.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localize(_FoodInfoStrings.ingredientsTitle),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  totalLabel,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: (media.width * 0.25) + 40,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (_, index) {
              final ingredient = ingredients[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: media.width * 0.23,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: media.width * 0.23,
                      height: media.width * 0.23,
                      decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        ingredient.image,
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ingredient.name,
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Text(
                      ingredient.amount,
                      style: TextStyle(color: TColor.gray, fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStepsSection(
    BuildContext context,
    List<InstructionStep> steps,
    AppLanguage language,
  ) {
    final totalLabel = _FoodInfoStrings.stepsCount(language, steps.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localize(_FoodInfoStrings.stepsTitle),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  totalLabel,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          itemCount: steps.length,
          itemBuilder: (_, index) => FoodStepDetailRow(
            step: steps[index],
            isLast: index == steps.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, AppLanguage language) {
    final mealName = _resolveLocalized(meal['name'], language);
    final buttonLabel = _FoodInfoStrings.addToMeal(language, mealName);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RoundButton(title: buttonLabel, onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          'assets/img/more_btn.png',
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _FoodInfoContent {
  static List<NutritionInfo> nutrition(AppLanguage language) {
    final calorieUnit = language == AppLanguage.indonesian ? 'kKal' : 'kCal';

    return [
      NutritionInfo(
        image: 'assets/img/burn.png',
        title: _FoodInfoStrings.caloriesTitle.resolve(language),
        value: '180 $calorieUnit',
      ),
      NutritionInfo(
        image: 'assets/img/egg.png',
        title: _FoodInfoStrings.fatsTitle.resolve(language),
        value: '30 g',
      ),
      NutritionInfo(
        image: 'assets/img/proteins.png',
        title: _FoodInfoStrings.proteinsTitle.resolve(language),
        value: '20 g',
      ),
      NutritionInfo(
        image: 'assets/img/carbo.png',
        title: _FoodInfoStrings.carboTitle.resolve(language),
        value: '50 g',
      ),
    ];
  }

  static List<Ingredient> ingredients(AppLanguage language) {
    return [
      Ingredient(
        image: 'assets/img/flour.png',
        name: _FoodInfoStrings.flourName.resolve(language),
        amount: '100 gr',
      ),
      Ingredient(
        image: 'assets/img/sugar.png',
        name: _FoodInfoStrings.sugarName.resolve(language),
        amount: language == AppLanguage.indonesian ? '3 sdm' : '3 tbsp',
      ),
      Ingredient(
        image: 'assets/img/baking_soda.png',
        name: _FoodInfoStrings.bakingSodaName.resolve(language),
        amount: language == AppLanguage.indonesian ? '2 sdt' : '2 tsp',
      ),
      Ingredient(
        image: 'assets/img/eggs.png',
        name: _FoodInfoStrings.eggsName.resolve(language),
        amount: language == AppLanguage.indonesian ? '2 butir' : '2 items',
      ),
    ];
  }

  static List<InstructionStep> steps(AppLanguage language) {
    return [
      InstructionStep(
        number: '1',
        title: _FoodInfoStrings.stepTitle(1).resolve(language),
        description: _FoodInfoStrings.stepDescription1.resolve(language),
      ),
      InstructionStep(
        number: '2',
        title: _FoodInfoStrings.stepTitle(2).resolve(language),
        description: _FoodInfoStrings.stepDescription2.resolve(language),
      ),
      InstructionStep(
        number: '3',
        title: _FoodInfoStrings.stepTitle(3).resolve(language),
        description: _FoodInfoStrings.stepDescription3.resolve(language),
      ),
      InstructionStep(
        number: '4',
        title: _FoodInfoStrings.stepTitle(4).resolve(language),
        description: _FoodInfoStrings.stepDescription4.resolve(language),
      ),
      InstructionStep(
        number: '5',
        title: _FoodInfoStrings.stepTitle(5).resolve(language),
        description: _FoodInfoStrings.stepDescription5.resolve(language),
      ),
    ];
  }
}

class _FoodInfoStrings {
  static const description = LocalizedText(
    english:
        "Pancakes are some people's favorite breakfast, who doesn't like pancakes? "
        "Especially with the real honey splash on top of the pancakes, of course everyone loves that! "
        "Besides being delicious, pancakes can be a quick treat for a busy morning.",
    indonesian:
        'Pancake adalah sarapan favorit banyak orang. Siapa sih yang tidak suka? '
        'Apalagi dengan siraman madu asli di atasnya, pasti semua orang suka! '
        'Selain lezat, pancake juga bisa menjadi hidangan cepat di pagi hari yang sibuk.',
  );

  static const byAuthor = LocalizedText(
    english: 'by James Ruth',
    indonesian: 'oleh James Ruth',
  );

  static const nutritionTitle = LocalizedText(
    english: 'Nutrition',
    indonesian: 'Nutrisi',
  );

  static const descriptionTitle = LocalizedText(
    english: 'Descriptions',
    indonesian: 'Deskripsi',
  );

  static const readMoreLabel = LocalizedText(
    english: 'Read More ...',
    indonesian: 'Baca Selengkapnya ...',
  );

  static const readLessLabel = LocalizedText(
    english: 'Read Less',
    indonesian: 'Sembunyikan',
  );

  static const ingredientsTitle = LocalizedText(
    english: 'Ingredients That You\nWill Need',
    indonesian: 'Bahan yang Kamu\nButuhkan',
  );

  static const stepsTitle = LocalizedText(
    english: 'Step by Step',
    indonesian: 'Langkah demi Langkah',
  );

  static const caloriesTitle = LocalizedText(
    english: 'Calories',
    indonesian: 'Kalori',
  );

  static const fatsTitle = LocalizedText(english: 'Fats', indonesian: 'Lemak');

  static const proteinsTitle = LocalizedText(
    english: 'Proteins',
    indonesian: 'Protein',
  );

  static const carboTitle = LocalizedText(
    english: 'Carbo',
    indonesian: 'Karbo',
  );

  static const flourName = LocalizedText(
    english: 'Wheat Flour',
    indonesian: 'Tepung Terigu',
  );

  static const sugarName = LocalizedText(english: 'Sugar', indonesian: 'Gula');

  static const bakingSodaName = LocalizedText(
    english: 'Baking Soda',
    indonesian: 'Soda Kue',
  );

  static const eggsName = LocalizedText(english: 'Eggs', indonesian: 'Telur');

  static LocalizedText stepTitle(int number) {
    return LocalizedText(
      english: 'Step $number',
      indonesian: 'Langkah $number',
    );
  }

  static const stepDescription1 = LocalizedText(
    english: 'Prepare all of the ingredients that are needed.',
    indonesian: 'Siapkan semua bahan yang diperlukan.',
  );

  static const stepDescription2 = LocalizedText(
    english: 'Mix flour, sugar, salt, and baking powder.',
    indonesian: 'Campurkan tepung, gula, garam, dan baking powder.',
  );

  static const stepDescription3 = LocalizedText(
    english: 'Mix the eggs and milk until blended in a separate bowl.',
    indonesian: 'Kocok telur dan susu hingga tercampur rata dalam wadah lain.',
  );

  static const stepDescription4 = LocalizedText(
    english: 'Combine the wet mixture with the dry ingredients and stir well.',
    indonesian:
        'Masukkan campuran telur dan susu ke bahan kering lalu aduk rata.',
  );

  static const stepDescription5 = LocalizedText(
    english: 'Cook until golden brown and serve while warm.',
    indonesian: 'Masak hingga berwarna keemasan dan sajikan selagi hangat.',
  );

  static String ingredientsCount(AppLanguage language, int count) {
    if (language == AppLanguage.indonesian) {
      return '$count Bahan';
    }
    return '$count Items';
  }

  static String stepsCount(AppLanguage language, int count) {
    if (language == AppLanguage.indonesian) {
      return '$count Langkah';
    }
    return '$count Steps';
  }

  static String addToMeal(AppLanguage language, String mealName) {
    if (language == AppLanguage.indonesian) {
      return 'Tambahkan ke Menu $mealName';
    }
    return 'Add to $mealName Meal';
  }
}

String _resolveLocalized(
  Object? value,
  AppLanguage language, {
  String? fallback,
}) {
  if (value is LocalizedText) {
    return value.resolve(language);
  }
  if (value == null) {
    return fallback ?? '';
  }
  return value.toString();
}
