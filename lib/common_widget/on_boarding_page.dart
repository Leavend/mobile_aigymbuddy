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
                Text(
                  content.title,
                  textAlign: content.textAlign ?? TextAlign.center,
                  style: TextStyle(
                    color: content.titleColor ?? TColor.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content.subtitle,
                  textAlign: content.textAlign ?? TextAlign.center,
                  style: TextStyle(
                    color: content.subtitleColor ?? TColor.gray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    content.image,
                    fit: BoxFit.contain,
                    width: media.width * 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                content.title,
                textAlign: content.textAlign ?? TextAlign.center,
                style: TextStyle(
                  color: content.titleColor ?? TColor.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                content.subtitle,
                textAlign: content.textAlign ?? TextAlign.center,
                style: TextStyle(
                  color: content.subtitleColor ?? TColor.gray,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
