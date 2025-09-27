import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/on_boarding_page.dart';
import '../login/signup_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late final PageController controller = PageController();
  int selectPage = 0;

  final List<Map<String, String>> pageArr = [
    {
      'title': 'Track Your Goal',
      'subtitle':
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      'image': 'assets/img/on_1.png',
    },
    {
      'title': 'Get Burn',
      'subtitle':
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      'image': 'assets/img/on_2.png',
    },
    {
      'title': 'Eat Well',
      'subtitle':
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      'image': 'assets/img/on_3.png',
    },
    {
      'title': 'Improve Sleep\nQuality',
      'subtitle':
          'Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning',
      'image': 'assets/img/on_4.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      final currentPage = controller.page?.round() ?? 0;
      if (currentPage != selectPage) {
        setState(() {
          selectPage = currentPage;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (selectPage < pageArr.length - 1) {
      final nextPage = selectPage + 1;
      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() {
        selectPage = nextPage;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              final pObj = pageArr[index];
              return OnBoardingPage(pObj: pObj);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, bottom: 32),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      color: TColor.primaryColor1,
                      value: (selectPage + 1) / pageArr.length,
                      strokeWidth: 2,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TColor.primaryColor1,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: IconButton(
                      icon: Icon(
                        selectPage == pageArr.length - 1
                            ? Icons.check
                            : Icons.navigate_next,
                        color: TColor.white,
                      ),
                      onPressed: _handleNext,
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
