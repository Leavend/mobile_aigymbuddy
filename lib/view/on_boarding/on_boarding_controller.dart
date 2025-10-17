import 'package:flutter/material.dart';

import 'on_boarding_repository.dart';
import 'on_boarding_state.dart';

class OnBoardingController extends ChangeNotifier {
  OnBoardingController({
    required OnBoardingContentRepository repository,
    Duration pageAnimationDuration = const Duration(milliseconds: 500),
    Curve pageAnimationCurve = Curves.easeOutCubic,
  })  : _repository = repository,
        _pageAnimationDuration = pageAnimationDuration,
        _pageAnimationCurve = pageAnimationCurve,
        _state = OnBoardingState(
          currentPageIndex: 0,
          pages: repository.load(),
        ),
        _pageController = PageController();

  final OnBoardingContentRepository _repository;
  final Duration _pageAnimationDuration;
  final Curve _pageAnimationCurve;

  final PageController _pageController;
  OnBoardingState _state;

  PageController get pageController => _pageController;

  OnBoardingState get state => _state;

  void reload() {
    _state = OnBoardingState(
      currentPageIndex: 0,
      pages: _repository.load(),
    );
    notifyListeners();
  }

  void handlePageChanged(int index) {
    if (index == _state.currentPageIndex) {
      return;
    }
    _state = _state.copyWith(currentPageIndex: index);
    notifyListeners();
  }

  Future<void> goToNextPage() async {
    if (_state.isLastPage) {
      return;
    }
    await _pageController.nextPage(
      duration: _pageAnimationDuration,
      curve: _pageAnimationCurve,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
