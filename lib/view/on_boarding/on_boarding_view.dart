import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController controller = PageController();
  int selectPage = 0;

  late final List<OnBoardingContent> pageArr = [
    OnBoardingContent(
      title: 'AI GYM BUDDY',
      subtitle: 'Everybody Can Train',
      image: 'assets/img/welcome.png',
      backgroundColor: TColor.white,
      titleColor: TColor.black,
      subtitleColor: TColor.gray,
      textAlign: TextAlign.center,
      buttonText: 'Get Started',
      isWelcome: true,
    ),
    OnBoardingContent(
      title: 'Track Your Goal',
      subtitle:
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      image: 'assets/img/on_1.png',
      gradientColors: TColor.primaryG,
    ),
    OnBoardingContent(
      title: 'Get Burn',
      subtitle:
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      image: 'assets/img/on_2.png',
      gradientColors: TColor.secondaryG,
    ),
    OnBoardingContent(
      title: 'Eat Well',
      subtitle:
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      image: 'assets/img/on_3.png',
      gradientColors: const [Color(0xff9DCEFF), Color(0xff92A3FD)],
    ),
    OnBoardingContent(
      title: 'Improve Sleep\nQuality',
      subtitle:
          'Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning',
      image: 'assets/img/on_4.png',
      gradientColors: const [Color(0xff92A3FD), Color(0xff9DCEFF)],
    ),
    OnBoardingContent(
      title: 'Smart AI Coach',
      subtitle:
          'Personalized programs backed with custom AI recommendations help you stay consistent on your fitness journey.',
      image: 'assets/img/on_5.png',
      gradientColors: const [Color(0xffC58BF2), Color(0xffEEA4CE)],
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (selectPage < pageArr.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go(AppRoute.signUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = pageArr.length;
    final progress = (selectPage + 1) / totalPages;

    final isWelcome = pageArr[selectPage].isWelcome;

    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: totalPages,
            onPageChanged: (index) {
              setState(() {
                selectPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnBoardingPage(
                content: pageArr[index],
                onNext: _handleNext,
              );
            },
          ),
          if (!isWelcome)
            Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 40),
              child: SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        color: TColor.primaryColor1,
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: TColor.lightGray,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              pageArr[selectPage].gradientColors ??
                              TColor.primaryG,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                (pageArr[selectPage].gradientColors ??
                                        TColor.primaryG)
                                    .last
                                    .withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: IconButton(
                          onPressed: _handleNext,
                          icon: Icon(
                            selectPage == totalPages - 1
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                            color: TColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
