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

class MealFoodDetailsView extends StatefulWidget {
  const MealFoodDetailsView({super.key, required this.eObj});

  final Map<String, dynamic> eObj;

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  static const List<_MealCategoryData> _categoryItems = [
    _MealCategoryData(
      name: LocalizedText(english: 'Salad', indonesian: 'Salad'),
      image: 'assets/img/c_1.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Cake', indonesian: 'Kue'),
      image: 'assets/img/c_2.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Pie', indonesian: 'Pai'),
      image: 'assets/img/c_3.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Smoothies', indonesian: 'Smoothies'),
      image: 'assets/img/c_4.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Salad', indonesian: 'Salad'),
      image: 'assets/img/c_1.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Cake', indonesian: 'Kue'),
      image: 'assets/img/c_2.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Pie', indonesian: 'Pai'),
      image: 'assets/img/c_3.png',
    ),
    _MealCategoryData(
      name: LocalizedText(english: 'Smoothies', indonesian: 'Smoothies'),
      image: 'assets/img/c_4.png',
    ),
  ];

  static const List<_PopularMealData> _popularItems = [
    _PopularMealData(
      name: LocalizedText(
        english: 'Blueberry Pancake',
        indonesian: 'Pancake Blueberry',
      ),
      image: 'assets/img/f_1.png',
      heroImage: 'assets/img/pancake_1.png',
      size: LocalizedText(english: 'Medium', indonesian: 'Sedang'),
      time: LocalizedText(english: '30 mins', indonesian: '30 menit'),
      kcal: LocalizedText(english: '230 kCal', indonesian: '230 kKal'),
    ),
    _PopularMealData(
      name: LocalizedText(
        english: 'Salmon Nigiri',
        indonesian: 'Salmon Nigiri',
      ),
      image: 'assets/img/f_2.png',
      heroImage: 'assets/img/nigiri.png',
      size: LocalizedText(english: 'Medium', indonesian: 'Sedang'),
      time: LocalizedText(english: '20 mins', indonesian: '20 menit'),
      kcal: LocalizedText(english: '120 kCal', indonesian: '120 kKal'),
    ),
  ];

  static const List<_RecommendationData> _recommendations = [
    _RecommendationData(
      name: LocalizedText(
        english: 'Honey Pancake',
        indonesian: 'Pancake Madu',
      ),
      image: 'assets/img/rd_1.png',
      heroImage: 'assets/img/pancake_1.png',
      size: LocalizedText(english: 'Easy', indonesian: 'Mudah'),
      time: LocalizedText(english: '30 mins', indonesian: '30 menit'),
      kcal: LocalizedText(english: '180 kCal', indonesian: '180 kKal'),
    ),
    _RecommendationData(
      name: LocalizedText(
        english: 'Canai Bread',
        indonesian: 'Roti Canai',
      ),
      image: 'assets/img/m_4.png',
      heroImage: 'assets/img/m_4.png',
      size: LocalizedText(english: 'Easy', indonesian: 'Mudah'),
      time: LocalizedText(english: '20 mins', indonesian: '20 menit'),
      kcal: LocalizedText(english: '230 kCal', indonesian: '230 kKal'),
    ),
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;

    return Scaffold(
      appBar: _buildAppBar(context, language),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context.localize(_MealFoodDetailsStrings.searchHint)),
            SizedBox(height: media.width * 0.05),
            _buildCategorySection(context, language),
            SizedBox(height: media.width * 0.05),
            _buildRecommendationSection(context, media, language),
            SizedBox(height: media.width * 0.05),
            _buildPopularSection(context, language),
            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLanguage language) {
    final title = _resolveLocalized(widget.eObj['name'], language);

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
      title: Text(
        title,
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
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
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                prefixIcon: Image.asset(
                  'assets/img/search.png',
                  width: 25,
                  height: 25,
                ),
                hintText: hintText,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 1,
            height: 25,
            color: TColor.gray.withValues(alpha: 0.3),
          ),
          InkWell(
            onTap: () {},
            child: Image.asset('assets/img/Filter.png', width: 25, height: 25),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, LocalizedText title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        context.localize(title),
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, _MealFoodDetailsStrings.categoryTitle),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: _categoryItems.length,
            itemBuilder: (context, index) => MealCategoryCell.fromMap(
              _categoryItems[index].toLocalizedMap(language),
              index: index,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationSection(
    BuildContext context,
    Size media,
    AppLanguage language,
  ) {
    final buttonLabel = context.localize(_MealFoodDetailsStrings.viewButton);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, _MealFoodDetailsStrings.recommendationTitle),
        SizedBox(
          height: media.width * 0.6,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = _recommendations[index];
              return MealRecommendCell.fromMap(
                recommendation.toLocalizedMap(language),
                index: index,
                buttonLabel: buttonLabel,
                onViewPressed: () => context.push(
                  AppRoute.foodInfo,
                  extra: FoodInfoArgs(
                    food: recommendation.toArgsMap(),
                    meal: Map<String, dynamic>.from(widget.eObj),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, _MealFoodDetailsStrings.popularTitle),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _popularItems.length,
          itemBuilder: (context, index) {
            final food = _popularItems[index];
            return PopularMealRow.fromMap(
              food.toLocalizedMap(language),
              onTap: () => context.push(
                AppRoute.foodInfo,
                extra: FoodInfoArgs(
                  food: food.toArgsMap(),
                  meal: Map<String, dynamic>.from(widget.eObj),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AppBarAction extends StatelessWidget {
  const _AppBarAction();

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

class _MealCategoryData {
  const _MealCategoryData({required this.name, required this.image});

  final LocalizedText name;
  final String image;

  Map<String, dynamic> toLocalizedMap(AppLanguage language) {
    return {
      'name': name.resolve(language),
      'image': image,
    };
  }
}

class _RecommendationData {
  const _RecommendationData({
    required this.name,
    required this.image,
    required this.heroImage,
    required this.size,
    required this.time,
    required this.kcal,
  });

  final LocalizedText name;
  final String image;
  final String heroImage;
  final LocalizedText size;
  final LocalizedText time;
  final LocalizedText kcal;

  Map<String, dynamic> toLocalizedMap(AppLanguage language) {
    return {
      'name': name.resolve(language),
      'image': image,
      'size': size.resolve(language),
      'time': time.resolve(language),
      'kcal': kcal.resolve(language),
    };
  }

  Map<String, dynamic> toArgsMap() {
    return {
      'name': name,
      'image': image,
      'b_image': heroImage,
      'size': size,
      'time': time,
      'kcal': kcal,
    };
  }
}

class _PopularMealData {
  const _PopularMealData({
    required this.name,
    required this.image,
    required this.heroImage,
    required this.size,
    required this.time,
    required this.kcal,
  });

  final LocalizedText name;
  final String image;
  final String heroImage;
  final LocalizedText size;
  final LocalizedText time;
  final LocalizedText kcal;

  Map<String, dynamic> toLocalizedMap(AppLanguage language) {
    return {
      'name': name.resolve(language),
      'image': image,
      'size': size.resolve(language),
      'time': time.resolve(language),
      'kcal': kcal.resolve(language),
    };
  }

  Map<String, dynamic> toArgsMap() {
    return {
      'name': name,
      'image': image,
      'b_image': heroImage,
      'size': size,
      'time': time,
      'kcal': kcal,
    };
  }
}

class _MealFoodDetailsStrings {
  static const categoryTitle = LocalizedText(
    english: 'Category',
    indonesian: 'Kategori',
  );

  static const recommendationTitle = LocalizedText(
    english: 'Recommendation\nfor Diet',
    indonesian: 'Rekomendasi\nUntuk Diet',
  );

  static const popularTitle = LocalizedText(
    english: 'Popular',
    indonesian: 'Populer',
  );

  static const viewButton = LocalizedText(
    english: 'View',
    indonesian: 'Lihat',
  );

  static const searchHint = LocalizedText(
    english: 'Search Pancake',
    indonesian: 'Cari Pancake',
  );
}

String _resolveLocalized(Object? value, AppLanguage language) {
  if (value is LocalizedText) {
    return value.resolve(language);
  }
  if (value == null) {
    return '';
  }
  return value.toString();
}
