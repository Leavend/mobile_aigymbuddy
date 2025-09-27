import 'package:flutter/material.dart';
import '../common/color_extension.dart';

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

  final String title;
  final String subtitle;
  final String image;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final TextAlign? textAlign;
  final String? buttonText;
  final bool isWelcome;
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key, required this.content, this.onNext});

  final OnBoardingContent content;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    if (content.isWelcome) {
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
                Image.asset(
                  content.image,
                  width: media.width * 0.75,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: media.width * 0.1),
                Text(
                  content.title,
                  textAlign: content.textAlign ?? TextAlign.center,
                  style: TextStyle(
                    color: content.titleColor ?? TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.subtitle,
                  textAlign: content.textAlign ?? TextAlign.center,
                  style: TextStyle(
                    color: content.subtitleColor ?? TColor.gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                if (content.buttonText != null)
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: onNext,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: content.gradientColors ?? TColor.primaryG,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primaryColor1.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          content.buttonText!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            content.image,
            width: media.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              content.title,
              style: TextStyle(
                  color: content.titleColor ?? TColor.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              content.subtitle,
              style: TextStyle(
                color: content.subtitleColor ?? TColor.gray,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}