import 'dart:collection';

import 'package:aigymbuddy/common_widget/on_boarding_page.dart';
import 'package:flutter/material.dart';

/// Immutable view state for the onboarding flow.
@immutable
class OnBoardingState {
  OnBoardingState({
    required this.currentPageIndex,
    required List<OnBoardingContent> pages,
  })  : assert(pages.isNotEmpty, 'Onboarding pages cannot be empty.'),
        assert(
          currentPageIndex >= 0 && currentPageIndex < pages.length,
          'Current page index must be within range.',
        ),
        _pages = UnmodifiableListView(pages);

  final int currentPageIndex;
  final UnmodifiableListView<OnBoardingContent> _pages;

  UnmodifiableListView<OnBoardingContent> get pages => _pages;

  OnBoardingContent get currentPage => _pages[currentPageIndex];

  bool get isLastPage => currentPageIndex == _pages.length - 1;

  bool get showProgressButton => !_pages[currentPageIndex].isWelcome;

  double get progressValue {
    if (_pages.isEmpty) {
      return 0;
    }
    return (currentPageIndex + 1) / _pages.length;
  }

  List<Color> get progressGradient => currentPage.gradientOrDefault();

  OnBoardingState copyWith({int? currentPageIndex}) {
    final nextIndex = currentPageIndex ?? this.currentPageIndex;
    assert(
      nextIndex >= 0 && nextIndex < _pages.length,
      'Current page index must be within range.',
    );
    return OnBoardingState(currentPageIndex: nextIndex, pages: _pages);
  }
}
