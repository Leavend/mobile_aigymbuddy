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
  final bool isWelcome;
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key, required this.content});

  final OnBoardingContent content;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    if (content.isWelcome) {
      return Container(
        width: media.width,
        height: media.height,
        color: content.backgroundColor ?? TColor.white,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                content.title,
                textAlign: content.textAlign ?? TextAlign.center,
                style: TextStyle(
                  color: content.titleColor ?? TColor.primaryColor1,
                  fontSize: 32,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Image.asset(
                  content.image,
                  width: media.width,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    }

    return Container(
      width: media.width,
      height: media.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: content.gradientColors ?? TColor.primaryG,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Image.asset(
                    content.image,
                    fit: BoxFit.contain,
                    width: media.width * 0.8,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    content.title,
                    textAlign: content.textAlign ?? TextAlign.left,
                    style: TextStyle(
                      color: content.titleColor ?? TColor.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content.subtitle,
                    textAlign: content.textAlign ?? TextAlign.left,
                    style: TextStyle(
                      color: content.subtitleColor ?? TColor.gray,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
