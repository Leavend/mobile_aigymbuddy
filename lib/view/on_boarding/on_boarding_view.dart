import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/app_language_toggle.dart';
import 'package:aigymbuddy/common_widget/on_boarding_page.dart';
import 'package:aigymbuddy/view/on_boarding/on_boarding_controller.dart';
import 'package:aigymbuddy/view/on_boarding/on_boarding_repository.dart';
import 'package:aigymbuddy/view/on_boarding/on_boarding_state.dart';
import 'package:aigymbuddy/view/on_boarding/widgets/on_boarding_progress_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late final OnBoardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnBoardingController(
      repository: const StaticOnBoardingContentRepository(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (!_controller.state.isLastPage) {
      await _controller.goToNextPage();
      return;
    }

    if (!mounted) return;
    context.go(AppRoute.signUp);
  }

  @override
  Widget build(BuildContext context) {
    final languageController = context.appLanguageController;
    return Scaffold(
      backgroundColor: TColor.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final state = _controller.state;
          final language = context.appLanguage;

          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildPageView(language, state),
              if (state.showProgressButton)
                OnBoardingProgressButton(
                  progress: state.progressValue,
                  gradient: state.progressGradient,
                  onPressed: _handleNext,
                  isLastPage: state.isLastPage,
                ),
              Positioned(
                top: 16,
                right: 16,
                child: SafeArea(
                  child: AppLanguageToggle(
                    selectedLanguage: language,
                    onSelected: languageController.select,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageView(AppLanguage language, OnBoardingState state) {
    return PageView.builder(
      controller: _controller.pageController,
      itemCount: state.pages.length,
      onPageChanged: _controller.handlePageChanged,
      itemBuilder: (context, index) {
        return OnBoardingPage(
          content: state.pages[index],
          language: language,
          onNext: _handleNext,
        );
      },
    );
  }
}
