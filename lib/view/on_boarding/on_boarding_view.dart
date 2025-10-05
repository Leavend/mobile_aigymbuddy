import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common_widget/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton({
    required this.language,
    required this.onPressed,
  });

  final AppLanguage language;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: TColor.primaryColor1,
        side: BorderSide(color: TColor.primaryColor1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.language, size: 18),
      label: Text(
        language.buttonLabel,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController controller = PageController();
  int selectPage = 0;
  AppLanguage _language = AppLanguage.english;

  late final List<OnBoardingContent> pageArr = [
    OnBoardingContent(
      title: const LocalizedText(
        english: 'AI GYM BUDDY',
        indonesian: 'AI GYM BUDDY',
      ),
      subtitle: const LocalizedText(
        english: 'Everybody Can Train',
        indonesian: 'Semua Bisa Latihan',
      ),
      image: 'assets/img/welcome.png',
      backgroundColor: TColor.white,
      titleColor: TColor.black,
      subtitleColor: TColor.gray,
      textAlign: TextAlign.center,
      buttonText: const LocalizedText(
        english: 'Get Started',
        indonesian: 'Mulai',
      ),
      isWelcome: true,
    ),
    OnBoardingContent(
      title: const LocalizedText(
        english: 'Track Your Goal',
        indonesian: 'Lacak Tujuanmu',
      ),
      subtitle: const LocalizedText(
        english:
            "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
        indonesian:
            'Jangan khawatir jika kamu kesulitan menentukan tujuan. Kami membantu menentukan dan melacak progresmu.',
      ),
      image: 'assets/img/on_1.png',
      gradientColors: TColor.primaryG,
    ),
    OnBoardingContent(
      title: const LocalizedText(
        english: 'Get Burn',
        indonesian: 'Terus Bakar Kalori',
      ),
      subtitle: const LocalizedText(
        english:
            "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
        indonesian:
            'Tetap semangat membakar kalori demi tujuanmu. Rasa sakitnya hanya sementara, menyerah justru membuatmu menyesal selamanya.',
      ),
      image: 'assets/img/on_2.png',
      gradientColors: TColor.secondaryG,
    ),
    OnBoardingContent(
      title: const LocalizedText(
        english: 'Eat Well',
        indonesian: 'Makan Sehat',
      ),
      subtitle: const LocalizedText(
        english:
            "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
        indonesian:
            'Mulai gaya hidup sehat bersama kami. Kami bantu atur menu harianmu karena makan sehat itu menyenangkan.',
      ),
      image: 'assets/img/on_3.png',
      gradientColors: const [Color(0xff9DCEFF), Color(0xff92A3FD)],
    ),
    OnBoardingContent(
      title: const LocalizedText(
        english: 'Improve Sleep\nQuality',
        indonesian: 'Tingkatkan Kualitas\nTidur',
      ),
      subtitle: const LocalizedText(
        english:
            'Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning',
        indonesian:
            'Tingkatkan kualitas tidurmu bersama kami. Tidur yang cukup menghadirkan energi positif di pagi hari.',
      ),
      image: 'assets/img/on_4.png',
      gradientColors: const [Color(0xff92A3FD), Color(0xff9DCEFF)],
    ),
    OnBoardingContent(
      title: const LocalizedText(
        english: 'Smart AI Coach',
        indonesian: 'Pelatih AI Pintar',
      ),
      subtitle: const LocalizedText(
        english:
            'Personalized programs backed with custom AI recommendations help you stay consistent on your fitness journey.',
        indonesian:
            'Program personal disertai rekomendasi AI membantumu tetap konsisten dalam perjalanan kebugaranmu.',
      ),
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

  void _toggleLanguage() {
    setState(() {
      _language = _language.toggled;
    });
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
                language: _language,
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
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: _LanguageToggleButton(
                language: _language,
                onPressed: _toggleLanguage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
