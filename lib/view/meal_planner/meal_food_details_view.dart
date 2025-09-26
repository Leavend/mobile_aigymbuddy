// lib/view/meal_planner/meal_food_details_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common_widget/meal_recommend_cell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/meal_category_cell.dart';
import '../../common_widget/popular_meal_row.dart';

class MealFoodDetailsView extends StatefulWidget {
  final Map<String, dynamic> eObj;
  const MealFoodDetailsView({super.key, required this.eObj});

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  final TextEditingController txtSearch = TextEditingController();

  final List<Map<String, dynamic>> categoryArr = [
    {"name": "Salad", "image": "assets/img/c_1.png"},
    {"name": "Cake", "image": "assets/img/c_2.png"},
    {"name": "Pie", "image": "assets/img/c_3.png"},
    {"name": "Smoothies", "image": "assets/img/c_4.png"},
    {"name": "Salad", "image": "assets/img/c_1.png"},
    {"name": "Cake", "image": "assets/img/c_2.png"},
    {"name": "Pie", "image": "assets/img/c_3.png"},
    {"name": "Smoothies", "image": "assets/img/c_4.png"},
  ];

  final List<Map<String, dynamic>> popularArr = [
    {
      "name": "Blueberry Pancake",
      "image": "assets/img/f_1.png",
      "b_image": "assets/img/pancake_1.png",
      "size": "Medium",
      "time": "30mins",
      "kcal": "230kCal",
    },
    {
      "name": "Salmon Nigiri",
      "image": "assets/img/f_2.png",
      "b_image": "assets/img/nigiri.png",
      "size": "Medium",
      "time": "20mins",
      "kcal": "120kCal",
    },
  ];

  final List<Map<String, dynamic>> recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/rd_1.png",
      "size": "Easy",
      "time": "30mins",
      "kcal": "180kCal",
    },
    {
      "name": "Canai Bread",
      "image": "assets/img/m_4.png",
      "size": "Easy",
      "time": "20mins",
      "kcal": "230kCal",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
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
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
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
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtSearch,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: Image.asset(
                          "assets/img/search.png",
                          width: 25,
                          height: 25,
                        ),
                        hintText: "Search Pancake",
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
                    child: Image.asset(
                      "assets/img/Filter.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: categoryArr.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> cObj = categoryArr[index];
                  return MealCategoryCell(
                    cObj: cObj,
                    index: index,
                  );
                },
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Recommendation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Recommendation\nfor Diet",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: recommendArr.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> fObj = recommendArr[index];
                  return MealRecommendCell(
                    fObj: fObj,
                    index: index,
                  );
                },
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Popular
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Popular",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: popularArr.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> fObj = popularArr[index];
                return InkWell(
                  onTap: () {
                    context.push(
                      AppRoute.foodInfo,
                      extra: {
                        'food': Map<String, dynamic>.from(fObj),
                        'meal': Map<String, dynamic>.from(widget.eObj),
                      },
                    );
                  },
                  child: PopularMealRow(mObj: fObj),
                );
              },
            ),

            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
    );
  }
}
