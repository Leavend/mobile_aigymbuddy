// lib/view/meal_planner/food_info_details_view.dart

import 'dart:async';

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/ingredient.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common/models/nutrition_info.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

import '../../app/dependencies.dart';
import '../../common_widget/food_step_detail_row.dart';
import '../shared/models/meal/meal_detail.dart';
import 'controllers/food_info_details_controller.dart';

class FoodInfoDetailsView extends StatefulWidget {
  const FoodInfoDetailsView({super.key, required this.args});

  final FoodInfoArgs args;

  @override
  State<FoodInfoDetailsView> createState() => _FoodInfoDetailsViewState();
}

class _FoodInfoDetailsViewState extends State<FoodInfoDetailsView> {
  late final FoodInfoDetailsController _controller;
  bool _dependenciesResolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesResolved) return;
    final repository = AppDependencies.of(context).mealPlannerRepository;
    _controller = FoodInfoDetailsController(repository, widget.args.mealId);
    _dependenciesResolved = true;
    unawaited(_controller.initialise());
  }

  @override
  void dispose() {
    if (_dependenciesResolved) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_dependenciesResolved) {
      return const SizedBox.shrink();
    }

    final media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final detail = _controller.detail;
          final isLoading = _controller.isLoading && detail == null;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (detail == null) {
            return _ErrorView(onRetry: () => unawaited(_controller.reload()));
          }

          final language = context.appLanguage;
          final title = detail.localizedName(language);
          final description = detail.localizedDescription(language);

          return NestedScrollView(
            headerSliverBuilder: (_, __) => [
              _TopAppBar(onBack: () => context.pop()),
              _HeroAppBar(media: media, imageAsset: detail.heroImageAsset),
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
                    _FoodDetailContent(
                      media: media,
                      detail: detail,
                      title: title,
                      description: description,
                    ),
                    _BottomAction(detail: detail),
                    if (_controller.isLoading)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FoodDetailContent extends StatelessWidget {
  const _FoodDetailContent({
    required this.media,
    required this.detail,
    required this.title,
    required this.description,
  });

  final Size media;
  final MealDetail detail;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final author = context.localize(_FoodInfoStrings.byAuthor);

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
          Padding(
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
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/img/fav.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: media.width * 0.05),
          _NutritionSection(items: detail.nutrition),
          SizedBox(height: media.width * 0.05),
          _DescriptionSection(description: description),
          const SizedBox(height: 15),
          _IngredientsSection(ingredients: detail.ingredients, media: media),
          _StepsSection(steps: detail.instructions),
          SizedBox(height: media.width * 0.25),
        ],
      ),
    );
  }
}

class _NutritionSection extends StatelessWidget {
  const _NutritionSection({required this.items});

  final List<NutritionInfo> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          context.localize(_FoodInfoStrings.noNutritionData),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

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
          height: 60,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, index) {
              final nutrition = items[index];
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
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
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
}

class _IngredientsSection extends StatelessWidget {
  const _IngredientsSection({required this.ingredients, required this.media});

  final List<Ingredient> ingredients;
  final Size media;

  @override
  Widget build(BuildContext context) {
    final language = context.appLanguage;
    final totalLabel =
        _FoodInfoStrings.ingredientsCount(language, ingredients.length);

    if (ingredients.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          context.localize(_FoodInfoStrings.noIngredients),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        ingredient.image,
                        width: media.width * 0.15,
                        height: media.width * 0.15,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ingredient.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
}

class _StepsSection extends StatelessWidget {
  const _StepsSection({required this.steps});

  final List<InstructionStep> steps;

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          context.localize(_FoodInfoStrings.noSteps),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            context.localize(_FoodInfoStrings.stepsTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: steps.length,
          itemBuilder: (_, index) {
            final step = steps[index];
            return FoodStepDetailRow(step: step);
          },
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.detail});

  final MealDetail detail;

  @override
  Widget build(BuildContext context) {
    final language = context.appLanguage;
    final buttonLabel =
        _FoodInfoStrings.addToMeal(language, detail.localizedName(language));

    return Positioned(
      left: 20,
      right: 20,
      bottom: 30,
      child: RoundButton(
        title: buttonLabel,
        type: RoundButtonType.bgGradient,
        onPressed: () {},
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leading: InkWell(
        onTap: onBack,
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
}

class _HeroAppBar extends StatelessWidget {
  const _HeroAppBar({required this.media, required this.imageAsset});

  final Size media;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
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
                  imageAsset,
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
}

class _MoreButton extends StatelessWidget {
  const _MoreButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.localize(_FoodInfoStrings.failedToLoad),
            style: TextStyle(color: TColor.gray, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _FoodInfoStrings {
  static const byAuthor = LocalizedText(
    english: 'By AI Gym Buddy',
    indonesian: 'Oleh AI Gym Buddy',
  );

  static const nutritionTitle = LocalizedText(
    english: 'Nutrition',
    indonesian: 'Nutrisi',
  );

  static const descriptionTitle = LocalizedText(
    english: 'Description',
    indonesian: 'Deskripsi',
  );

  static const readMoreLabel = LocalizedText(
    english: 'Read more',
    indonesian: 'Selengkapnya',
  );

  static const readLessLabel = LocalizedText(
    english: 'Read less',
    indonesian: 'Lebih sedikit',
  );

  static const ingredientsTitle = LocalizedText(
    english: 'Ingredients',
    indonesian: 'Bahan',
  );

  static const stepsTitle = LocalizedText(
    english: 'Steps',
    indonesian: 'Langkah',
  );

  static const failedToLoad = LocalizedText(
    english: 'Unable to load meal details.',
    indonesian: 'Tidak dapat memuat detail menu.',
  );

  static const noNutritionData = LocalizedText(
    english: 'Nutrition data not available.',
    indonesian: 'Data nutrisi belum tersedia.',
  );

  static const noIngredients = LocalizedText(
    english: 'Ingredients not available yet.',
    indonesian: 'Bahan belum tersedia.',
  );

  static const noSteps = LocalizedText(
    english: 'Preparation steps not available.',
    indonesian: 'Langkah persiapan belum tersedia.',
  );

  static String ingredientsCount(AppLanguage language, int total) {
    final suffix = language == AppLanguage.indonesian ? 'Bahan' : 'Ingredients';
    return '$total $suffix';
  }

  static String addToMeal(AppLanguage language, String mealName) {
    if (language == AppLanguage.indonesian) {
      return 'Tambahkan ke $mealName';
    }
    return 'Add to $mealName';
  }
}
