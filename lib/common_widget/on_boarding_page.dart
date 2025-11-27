import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/material.dart';

class OnBoardingContent {
  const OnBoardingContent({
    required this.title,
    required this.subtitle,
    required this.image,
    this.gradientColors,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
    this.textAlign,
    this.buttonText,
    this.isWelcome = false,
  });

  final LocalizedText title;
  final LocalizedText subtitle;
  final String image;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final TextAlign? textAlign;
  final LocalizedText? buttonText;
  final bool isWelcome;

  String titleFor(AppLanguage language) => title.resolve(language);

  String subtitleFor(AppLanguage language) => subtitle.resolve(language);

  String? buttonTextFor(AppLanguage language) => buttonText?.resolve(language);

  List<Color> gradientOrDefault() {
    final colors = gradientColors;
    if (colors == null || colors.isEmpty) {
      return TColor.primaryG;
    }
    return colors;
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    required this.content, required this.language, super.key,
    this.onNext,
  });

  final OnBoardingContent content;
  final AppLanguage language;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    if (content.isWelcome) {
      final buttonText = content.buttonTextFor(language);
      return Container(
        width: media.width,
        height: media.height,
        color: content.backgroundColor ?? TColor.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  content.titleFor(language),
                  textAlign: content.textAlign ?? TextAlign.center,
                  style: TextStyle(
                    color: content.titleColor ?? TColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.subtitleFor(language),
                  textAlign: content.textAlign ?? TextAlign.center,
                  style: TextStyle(
                    color: content.subtitleColor ?? TColor.gray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                if (buttonText != null)
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: onNext,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: content.gradientOrDefault(),
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primaryColor1.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: TColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: media.width,
      height: media.height,
      color: TColor.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              content.image,
              width: media.width,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: media.width * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                content.titleFor(language),
                style: TextStyle(
                  color: content.titleColor ?? TColor.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                content.subtitleFor(language),
                style: TextStyle(
                  color: content.subtitleColor ?? TColor.gray,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
