import 'package:aigymbuddy/common/color_extension.dart';
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

  static const String _description =
      "Pancakes are some people's favorite breakfast, who doesn't like pancakes? "
      "Especially with the real honey splash on top of the pancakes, of course everyone loves that! "
      "besides being Pancakes are some people's favorite breakfast, who doesn't like pancakes? "
      "Especially with the real honey splash on top of the pancakes, of course everyone loves that! besides being";

  static const List<NutritionInfo> _nutritionItems = [
    NutritionInfo(
      image: 'assets/img/burn.png',
      title: 'Calories',
      value: '180 kCal',
    ),
    NutritionInfo(image: 'assets/img/egg.png', title: 'Fats', value: '30 g'),
    NutritionInfo(
      image: 'assets/img/proteins.png',
      title: 'Proteins',
      value: '20 g',
    ),
    NutritionInfo(image: 'assets/img/carbo.png', title: 'Carbo', value: '50 g'),
  ];

  static const List<Ingredient> _ingredients = [
    Ingredient(
      image: 'assets/img/flour.png',
      name: 'Wheat Flour',
      amount: '100 gr',
    ),
    Ingredient(image: 'assets/img/sugar.png', name: 'Sugar', amount: '3 tbsp'),
    Ingredient(
      image: 'assets/img/baking_soda.png',
      name: 'Baking Soda',
      amount: '2 tsp',
    ),
    Ingredient(image: 'assets/img/eggs.png', name: 'Eggs', amount: '2 items'),
  ];

  static const List<InstructionStep> _steps = [
    InstructionStep(
      number: '1',
      title: 'Step 1',
      description: 'Prepare all of the ingredients that are needed.',
    ),
    InstructionStep(
      number: '2',
      title: 'Step 2',
      description: 'Mix flour, sugar, salt, and baking powder.',
    ),
    InstructionStep(
      number: '3',
      title: 'Step 3',
      description:
          'In a separate place, mix the eggs and liquid milk until blended.',
    ),
    InstructionStep(
      number: '4',
      title: 'Step 4',
      description:
          'Put the egg and milk mixture into the dry ingredients. Stir until smooth.',
    ),
    InstructionStep(
      number: '5',
      title: 'Step 5',
      description: 'Cook until golden brown and serve while warm.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (_, _) => [
          _buildTopAppBar(context),
          _buildHeroAppBar(media),
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
            body: Stack(children: [_buildContent(media), _buildBottomAction()]),
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

  Widget _buildHeroAppBar(Size media) {
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
                  detail['b_image'].toString(),
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

  Widget _buildContent(Size media) {
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
          _buildTitleSection(),
          SizedBox(height: media.width * 0.05),
          _buildNutritionSection(),
          SizedBox(height: media.width * 0.05),
          _buildDescriptionSection(),
          const SizedBox(height: 15),
          _buildIngredientSection(media),
          _buildStepsSection(),
          SizedBox(height: media.width * 0.25),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
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
                  detail['name'].toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'by James Ruth',
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

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Nutrition',
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
            itemCount: _nutritionItems.length,
            itemBuilder: (_, index) {
              final nutrition = _nutritionItems[index];
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

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Descriptions',
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
            _description,
            trimLines: 4,
            colorClickableText: TColor.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' Read More ...',
            trimExpandedText: ' Read Less',
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

  Widget _buildIngredientSection(Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ingredients That You\nWill Need',
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '${_ingredients.length} Items',
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
            itemCount: _ingredients.length,
            itemBuilder: (_, index) {
              final ingredient = _ingredients[index];
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

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step by Step',
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '${_steps.length} Steps',
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
          itemCount: _steps.length,
          itemBuilder: (_, index) => FoodStepDetailRow(
            step: _steps[index],
            isLast: index == _steps.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RoundButton(
              title: 'Add to ${meal['name']} Meal',
              onPressed: () {},
            ),
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
