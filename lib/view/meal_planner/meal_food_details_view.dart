import 'dart:async';

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common_widget/meal_category_cell.dart';
import 'package:aigymbuddy/common_widget/meal_recommend_cell.dart';
import 'package:aigymbuddy/common_widget/popular_meal_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../shared/models/meal/meal_category.dart';
import '../shared/models/meal/meal_summary.dart';
import 'controllers/meal_food_details_controller.dart';

class MealFoodDetailsView extends StatefulWidget {
  const MealFoodDetailsView({super.key, required this.args});

  final MealFoodDetailsArgs args;

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  final TextEditingController _searchController = TextEditingController();

  late final MealFoodDetailsController _controller;
  bool _dependenciesResolved = false;

  @override
  void dispose() {
    _searchController.dispose();
    if (_dependenciesResolved) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesResolved) return;
    final repository = AppDependencies.of(context).mealPlannerRepository;
    _controller = MealFoodDetailsController(repository);
    _dependenciesResolved = true;
    unawaited(
      _controller.initialise(initialCategoryId: widget.args.categoryId),
    );
  }

  void _onSearchSubmitted(String query) {
    unawaited(_controller.search(query));
  }

  void _changeCategory(int categoryId) {
    unawaited(_controller.selectCategory(categoryId));
  }

  void _openMealDetail(int mealId) {
    context.push(AppRoute.foodInfo, extra: FoodInfoArgs(mealId: mealId));
  }

  @override
  Widget build(BuildContext context) {
    if (!_dependenciesResolved) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final media = MediaQuery.of(context).size;
        final language = context.appLanguage;
        final overview = _controller.overview;
        final isLoading = _controller.isLoading && overview == null;

        Widget body;
        if (isLoading) {
          body = const Center(child: CircularProgressIndicator());
        } else if (overview == null) {
          body = _ErrorMessage(
            onRetry: () => unawaited(_controller.refresh()),
          );
        } else {
          final categories = overview.categories;
          final recommendations = overview.recommendations;
          final popular = overview.popularMeals;
          final selectedCategoryId =
              _controller.selectedCategoryId ?? overview.categories.first.id;
          final selectedCategory = categories.firstWhere(
            (category) => category.id == selectedCategoryId,
            orElse: () => categories.first,
          );

          body = Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(
                      context.localize(_MealFoodDetailsStrings.searchHint),
                    ),
                    SizedBox(height: media.width * 0.05),
                    _buildCategorySection(
                      context,
                      categories,
                      selectedCategoryId,
                    ),
                    SizedBox(height: media.width * 0.05),
                    _buildSearchResults(language),
                    SizedBox(height: media.width * 0.02),
                    _buildRecommendationSection(
                      context,
                      media,
                      language,
                      recommendations,
                    ),
                    SizedBox(height: media.width * 0.05),
                    _buildCategoryMealsSection(
                      context,
                      language,
                      selectedCategory,
                    ),
                    SizedBox(height: media.width * 0.05),
                    _buildPopularSection(context, language, popular),
                    SizedBox(height: media.width * 0.05),
                  ],
                ),
              ),
              if (_controller.isLoading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: TColor.white,
          body: body,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final language = context.appLanguage;
    return AppBar(
      backgroundColor: TColor.white,
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
      title: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final categories = _controller.overview?.categories;
          if (categories == null || categories.isEmpty) {
            return Text(
              context.localize(_MealFoodDetailsStrings.titleFallback),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          final selectedId =
              _controller.selectedCategoryId ?? categories.first.id;
          final category = categories.firstWhere(
            (c) => c.id == selectedId,
            orElse: () => categories.first,
          );
          return Text(
            category.localizedTitle(language),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          );
        },
      ),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 8), child: _AppBarAction()),
      ],
    );
  }

  Widget _buildSearchBar(String hintText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: hintText,
                prefixIcon: Image.asset(
                  'assets/img/search.png',
                  width: 25,
                  height: 25,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Image.asset(
            'assets/img/Filter.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    List<MealCategorySummary> categories,
    int selectedId,
  ) {
    final language = context.appLanguage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            context.localize(_MealFoodDetailsStrings.categoryTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category.id == selectedId;
              return Opacity(
                opacity: isSelected ? 1 : 0.6,
                child: MealCategoryCell(
                  index: index,
                  category: MealCategoryItem(
                    name: category.localizedTitle(language),
                    imageAsset: category.imageAsset,
                  ),
                  onTap: () => _changeCategory(category.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryMealsSection(
    BuildContext context,
    AppLanguage language,
    MealCategorySummary category,
  ) {
    final meals = _controller.categoryMeals;
    final isLoading = _controller.isLoadingCategoryMeals && meals.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (meals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          context.localize(_MealFoodDetailsStrings.noMealsForCategory),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    final buttonLabel = context.localize(_MealFoodDetailsStrings.viewButton);

    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return MealRecommendCell(
            index: index,
            meal: MealRecommendationItem(
              name: meal.localizedName(language),
              size: meal.sizeLabel ?? 'Medium',
              time: meal.localizedTime(language),
              kcal: meal.localizedCalories(language),
              imageAsset: meal.imageAsset,
            ),
            buttonLabel: buttonLabel,
            onViewPressed: () => _openMealDetail(meal.id),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationSection(
    BuildContext context,
    Size media,
    AppLanguage language,
    List<MealSummary> recommendations,
  ) {
    if (recommendations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          context.localize(_MealFoodDetailsStrings.noRecommendations),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    final buttonLabel = context.localize(_MealFoodDetailsStrings.viewButton);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            context.localize(_MealFoodDetailsStrings.recommendationTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: media.width * 0.55,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final meal = recommendations[index];
              return MealRecommendCell(
                index: index,
                meal: MealRecommendationItem(
                  name: meal.localizedName(language),
                  size: meal.sizeLabel ?? 'Easy',
                  time: meal.localizedTime(language),
                  kcal: meal.localizedCalories(language),
                  imageAsset: meal.imageAsset,
                ),
                buttonLabel: buttonLabel,
                onViewPressed: () => _openMealDetail(meal.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection(
    BuildContext context,
    AppLanguage language,
    List<MealSummary> popular,
  ) {
    if (popular.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          context.localize(_MealFoodDetailsStrings.noPopularMeals),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            context.localize(_MealFoodDetailsStrings.popularTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: popular.length,
          itemBuilder: (context, index) {
            final meal = popular[index];
            return PopularMealRow(
              meal: PopularMealItem(
                name: meal.localizedName(language),
                image: meal.imageAsset,
                heroImage: meal.heroImageAsset,
                size: meal.sizeLabel ?? 'Medium',
                time: meal.localizedTime(language),
                kcal: meal.localizedCalories(language),
              ),
              onTap: () => _openMealDetail(meal.id),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults(AppLanguage language) {
    final results = _controller.searchResults;
    final isSearching = _controller.isSearching;
    final query = _searchController.text.trim();

    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (query.isEmpty) {
      return const SizedBox.shrink();
    }

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          context.localize(_MealFoodDetailsStrings.emptySearchResult),
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final meal = results[index];
        return PopularMealRow(
          meal: PopularMealItem(
            name: meal.localizedName(language),
            image: meal.imageAsset,
            heroImage: meal.heroImageAsset,
            size: meal.sizeLabel ?? 'Medium',
            time: meal.localizedTime(language),
            kcal: meal.localizedCalories(language),
          ),
          onTap: () => _openMealDetail(meal.id),
        );
      },
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.localize(_MealFoodDetailsStrings.failedToLoad),
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

class _AppBarAction extends StatelessWidget {
  const _AppBarAction();

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

class _MealFoodDetailsStrings {
  static const searchHint = LocalizedText(
    english: 'Search meal, category, or recipe',
    indonesian: 'Cari makanan, kategori, atau resep',
  );

  static const titleFallback = LocalizedText(
    english: 'Meal Details',
    indonesian: 'Detail Menu',
  );

  static const categoryTitle = LocalizedText(
    english: 'Categories',
    indonesian: 'Kategori',
  );

  static const recommendationTitle = LocalizedText(
    english: 'Recommendation',
    indonesian: 'Rekomendasi',
  );

  static const viewButton = LocalizedText(
    english: 'View',
    indonesian: 'Lihat',
  );

  static const popularTitle = LocalizedText(
    english: 'Popular',
    indonesian: 'Populer',
  );

  static const noRecommendations = LocalizedText(
    english: 'No recommendations yet.',
    indonesian: 'Belum ada rekomendasi.',
  );

  static const noMealsForCategory = LocalizedText(
    english: 'No meals available for this category.',
    indonesian: 'Belum ada menu untuk kategori ini.',
  );

  static const noPopularMeals = LocalizedText(
    english: 'No popular meals yet.',
    indonesian: 'Belum ada menu populer.',
  );

  static const emptySearchResult = LocalizedText(
    english: 'No meals found for your search.',
    indonesian: 'Menu tidak ditemukan.',
  );

  static const failedToLoad = LocalizedText(
    english: 'Unable to load meal options.',
    indonesian: 'Tidak dapat memuat pilihan menu.',
  );
}
