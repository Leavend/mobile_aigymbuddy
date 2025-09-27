// lib/view/login_what_your_goal_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, String>> goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat and\nneed / want to build more muscle",
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Lean & Tone",
      "subtitle":
          "I’m “skinny fat”, look thin but have\nno shape. I want to add lean muscle\nin the right way",
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Lose a Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle mass",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                "What is your goal ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "It will help us to choose a best program for you",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),

              const SizedBox(height: 32),

              // Carousel di tengah
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: goalArr.length,
                  itemBuilder: (context, index, realIdx) {
                    final gObj = goalArr[index];
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            gObj["image"]!,
                            width: media.width * 0.5,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            gObj["title"]!,
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(width: 40, height: 1, color: TColor.white),
                          const SizedBox(height: 12),
                          Text(
                            gObj["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.white, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    viewportFraction: 0.75,
                    aspectRatio: 3 / 4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              RoundButton(
                title: "Confirm",
                onPressed: () {
                  context.push(AppRoute.welcome);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
