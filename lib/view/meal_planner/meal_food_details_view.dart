// lib/view/meal_planner/meal_food_details_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/models/navigation_args.dart';
import 'package:aigymbuddy/common_widget/meal_recommend_cell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/meal_category_cell.dart';
import '../../common_widget/popular_meal_row.dart';

class MealFoodDetailsView extends StatefulWidget {
  const MealFoodDetailsView({super.key, required this.eObj});

  final Map<String, dynamic> eObj;

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  static const List<Map<String, String>> _categoryItems = [
    {'name': 'Salad', 'image': 'assets/img/c_1.png'},
    {'name': 'Cake', 'image': 'assets/img/c_2.png'},
    {'name': 'Pie', 'image': 'assets/img/c_3.png'},
    {'name': 'Smoothies', 'image': 'assets/img/c_4.png'},
    {'name': 'Salad', 'image': 'assets/img/c_1.png'},
    {'name': 'Cake', 'image': 'assets/img/c_2.png'},
    {'name': 'Pie', 'image': 'assets/img/c_3.png'},
    {'name': 'Smoothies', 'image': 'assets/img/c_4.png'},
  ];

  static const List<Map<String, String>> _popularItems = [
    {
      'name': 'Blueberry Pancake',
      'image': 'assets/img/f_1.png',
      'b_image': 'assets/img/pancake_1.png',
      'size': 'Medium',
      'time': '30mins',
      'kcal': '230kCal',
    },
    {
      'name': 'Salmon Nigiri',
      'image': 'assets/img/f_2.png',
      'b_image': 'assets/img/nigiri.png',
      'size': 'Medium',
      'time': '20mins',
      'kcal': '120kCal',
    },
  ];

  static const List<Map<String, String>> _recommendations = [
    {
      'name': 'Honey Pancake',
      'image': 'assets/img/rd_1.png',
      'size': 'Easy',
      'time': '30mins',
      'kcal': '180kCal',
    },
    {
      'name': 'Canai Bread',
      'image': 'assets/img/m_4.png',
      'size': 'Easy',
      'time': '20mins',
      'kcal': '230kCal',
    },
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

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: media.width * 0.05),
            _buildCategorySection(),
            SizedBox(height: media.width * 0.05),
            _buildRecommendationSection(media),
            SizedBox(height: media.width * 0.05),
            _buildPopularSection(),
            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
        widget.eObj['name'].toString(),
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

  Widget _buildSearchBar() {
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
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                prefixIcon: Image.asset(
                  'assets/img/search.png',
                  width: 25,
                  height: 25,
                ),
                hintText: 'Search Pancake',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Category'),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: _categoryItems.length,
            itemBuilder: (context, index) => MealCategoryCell.fromMap(
              Map<String, dynamic>.from(_categoryItems[index]),
              index: index,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationSection(Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Recommendation\nfor Diet'),
        SizedBox(
          height: media.width * 0.6,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final recommendation =
                  Map<String, dynamic>.from(_recommendations[index]);
              return MealRecommendCell.fromMap(
                recommendation,
                index: index,
                onViewPressed: () => context.push(
                  AppRoute.foodInfo,
                  extra: FoodInfoArgs(
                    food: Map<String, dynamic>.from(recommendation),
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

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Popular'),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _popularItems.length,
          itemBuilder: (context, index) {
            final food = Map<String, dynamic>.from(_popularItems[index]);
            return PopularMealRow.fromMap(
              food,
              onTap: () => context.push(
                AppRoute.foodInfo,
                extra: FoodInfoArgs(
                  food: Map<String, dynamic>.from(food),
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
