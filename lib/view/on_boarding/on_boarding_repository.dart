import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common_widget/on_boarding_page.dart';
import 'package:flutter/material.dart';

/// Abstraction describing a source for onboarding pages.
abstract class OnBoardingContentRepository {
  const OnBoardingContentRepository();

  List<OnBoardingContent> load();
}

/// Default repository backed by static in-memory configuration.
class StaticOnBoardingContentRepository extends OnBoardingContentRepository {
  const StaticOnBoardingContentRepository();

  static const _welcomeContent = OnBoardingContent(
    title: LocalizedText(
      english: 'AI GYM BUDDY',
      indonesian: 'AI GYM BUDDY',
    ),
    subtitle: LocalizedText(
      english: 'Everybody Can Train',
      indonesian: 'Semua Bisa Latihan',
    ),
    image: 'assets/img/welcome.png',
    backgroundColor: TColor.white,
    titleColor: TColor.black,
    subtitleColor: TColor.gray,
    textAlign: TextAlign.center,
    buttonText: LocalizedText(
      english: 'Get Started',
      indonesian: 'Mulai',
    ),
    isWelcome: true,
  );

  static const _pageOne = OnBoardingContent(
    title: LocalizedText(
      english: 'Track Your Goal',
      indonesian: 'Lacak Tujuanmu',
    ),
    subtitle: LocalizedText(
      english:
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      indonesian:
          'Jangan khawatir jika kamu kesulitan menentukan tujuan. Kami membantu menentukan dan melacak progresmu.',
    ),
    image: 'assets/img/on_1.png',
    gradientColors: TColor.primaryG,
  );

  static const _pageTwo = OnBoardingContent(
    title: LocalizedText(
      english: 'Get Burn',
      indonesian: 'Terus Bakar Kalori',
    ),
    subtitle: LocalizedText(
      english:
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      indonesian:
          'Tetap semangat membakar kalori demi tujuanmu. Rasa sakitnya hanya sementara, menyerah justru membuatmu menyesal selamanya.',
    ),
    image: 'assets/img/on_2.png',
    gradientColors: TColor.secondaryG,
  );

  static const _pageThree = OnBoardingContent(
    title: LocalizedText(
      english: 'Eat Well',
      indonesian: 'Makan Sehat',
    ),
    subtitle: LocalizedText(
      english: "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      indonesian: 'Mulai gaya hidup sehat bersama kami. Kami bantu atur menu harianmu karena makan sehat itu menyenangkan.',
    ),
    image: 'assets/img/on_3.png',
    gradientColors: [Color(0xff9DCEFF), Color(0xff92A3FD)],
  );

  static const _pageFour = OnBoardingContent(
    title: LocalizedText(
      english: 'Improve Sleep\nQuality',
      indonesian: 'Tingkatkan Kualitas\nTidur',
    ),
    subtitle: LocalizedText(
      english:
          'Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning',
      indonesian: 'Tingkatkan kualitas tidurmu bersama kami. Tidur yang cukup menghadirkan energi positif di pagi hari.',
    ),
    image: 'assets/img/on_4.png',
    gradientColors: [Color(0xff92A3FD), Color(0xff9DCEFF)],
  );

  static const _pageFive = OnBoardingContent(
    title: LocalizedText(
      english: 'Smart AI Coach',
      indonesian: 'Pelatih AI Pintar',
    ),
    subtitle: LocalizedText(
      english:
          'Personalized programs backed with custom AI recommendations help you stay consistent on your fitness journey.',
      indonesian: 'Program personal disertai rekomendasi AI membantumu tetap konsisten dalam perjalanan kebugaranmu.',
    ),
    image: 'assets/img/on_5.png',
    gradientColors: [Color(0xffC58BF2), Color(0xffEEA4CE)],
  );

  static const List<OnBoardingContent> _contents = [
    _welcomeContent,
    _pageOne,
    _pageTwo,
    _pageThree,
    _pageFour,
    _pageFive,
  ];

  @override
  List<OnBoardingContent> load() => _contents;
}
