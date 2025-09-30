// lib/view/main_tab/main_tab_view.dart

import 'dart:ui';

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/tab_button.dart';
import 'package:aigymbuddy/view/main_tab/select_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/home_view.dart';
import '../photo_progress/photo_progress_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  static const double _fabDiameter = 64;

  int _selected = 0;

  late final List<_NavigationItem> _items;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _items = const [
      _NavigationItem(
        icon: 'assets/img/home_tab.png',
        selectedIcon: 'assets/img/home_tab_select.png',
        semanticsLabel: 'Home',
        child: HomeView(),
      ),
      _NavigationItem(
        icon: 'assets/img/activity_tab.png',
        selectedIcon: 'assets/img/activity_tab_select.png',
        semanticsLabel: 'Activities',
        child: SelectView(),
      ),
      _NavigationItem(
        icon: 'assets/img/camera_tab.png',
        selectedIcon: 'assets/img/camera_tab_select.png',
        semanticsLabel: 'Progress',
        child: PhotoProgressView(),
      ),
      _NavigationItem(
        icon: 'assets/img/profile_tab.png',
        selectedIcon: 'assets/img/profile_tab_select.png',
        semanticsLabel: 'Profile',
        child: ProfileView(),
      ),
    ];
    _tabs = _items.map((item) => item.child).toList(growable: false);
  }

  void _handleTabSelected(int index) {
    if (_selected == index) {
      return;
    }
    setState(() => _selected = index);
  }

  void _handleAssistantTap() {
    Feedback.forTap(context);
    HapticFeedback.mediumImpact();
  }

  Widget _buildAssistantButton() {
    return Semantics(
      button: true,
      label: 'AI Assistant',
      child: SizedBox(
        width: _fabDiameter,
        height: _fabDiameter,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
              ),
              child: InkWell(
                onTap: _handleAssistantTap,
                child: const Center(
                  child: Icon(
                    CupertinoIcons.chat_bubble_text_fill,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabCluster({
    required List<_NavigationItem> items,
    required int startIndex,
    required _NavigationMetrics metrics,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: metrics.tabSpacing),
          TabButton(
            icon: items[i].icon,
            selectIcon: items[i].selectedIcon,
            semanticsLabel: items[i].semanticsLabel,
            isActive: _selected == startIndex + i,
            width: metrics.buttonWidth,
            onTap: () => _handleTabSelected(startIndex + i),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final midpoint = (_items.length / 2).ceil();
    final leadingItems = _items.sublist(0, midpoint);
    final trailingItems = _items.sublist(midpoint);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context);
        final textScale = scaler.scale(1.0);
        final metrics = _NavigationMetrics.resolve(
          availableWidth: constraints.maxWidth,
          fabDiameter: _fabDiameter,
          textScaleFactor: textScale,
          leadingCount: leadingItems.length,
          trailingCount: trailingItems.length,
        );

        return SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: metrics.safeAreaPadding),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              metrics.outerHorizontalPadding,
              0,
              metrics.outerHorizontalPadding,
              metrics.bottomMargin,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(metrics.containerRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(metrics.containerRadius),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: metrics.containerHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: metrics.horizontalPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildTabCluster(
                                items: leadingItems,
                                startIndex: 0,
                                metrics: metrics,
                              ),
                            ),
                          ),
                          SizedBox(width: metrics.centerGap),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _buildTabCluster(
                                items: trailingItems,
                                startIndex: leadingItems.length,
                                metrics: metrics,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: metrics.centerGap),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _buildTabCluster(
                            items: trailingItems,
                            startIndex: leadingItems.length,
                            metrics: metrics,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,

      // Simpan state per tab
      body: IndexedStack(index: _selected, children: _tabs),

      // FAB tengah: bulat, gradient, shadow
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildAssistantButton(),

      // Bottom bar: pill + blur + dua cluster tab dengan gap tetap di tengah
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}

class _NavigationMetrics {
  const _NavigationMetrics({
    required this.buttonWidth,
    required this.tabSpacing,
    required this.centerGap,
    required this.containerHeight,
    required this.containerRadius,
    required this.horizontalPadding,
    required this.outerHorizontalPadding,
    required this.bottomMargin,
    required this.safeAreaPadding,
  });

  final double buttonWidth;
  final double tabSpacing;
  final double centerGap;
  final double containerHeight;
  final double containerRadius;
  final double horizontalPadding;
  final double outerHorizontalPadding;
  final double bottomMargin;
  final double safeAreaPadding;

  static const double _minWidth = 320;
  static const double _maxWidth = 840;

  static _NavigationMetrics resolve({
    required double availableWidth,
    required double fabDiameter,
    required double textScaleFactor,
    required int leadingCount,
    required int trailingCount,
  }) {
    final clampedWidth = availableWidth.clamp(_minWidth, _maxWidth);
    final t = (clampedWidth - _minWidth) / (_maxWidth - _minWidth);

    var buttonWidth = lerpDouble(48, 64, t)!;
    var tabSpacing = lerpDouble(12, 28, t)!;
    final gapOffset = lerpDouble(12, 28, t)!;
    var centerGap = fabDiameter + gapOffset;
    final baseHeight = lerpDouble(56, 72, t)!;
    final textScale = textScaleFactor.clamp(1.0, 1.3);
    final heightBoost = (textScale - 1.0) * 12;

    final outerPadding = lerpDouble(16, 32, t)!;
    final innerPadding = lerpDouble(16, 28, t)!;
    final totalButtons = leadingCount + trailingCount;
    final totalSpacing = _spacingCount(leadingCount) + _spacingCount(trailingCount);
    final minCenterGap = fabDiameter + 8;
    const minTabSpacing = 8.0;
    const minButtonWidth = 36.0;

    var availableContentWidth = availableWidth - (outerPadding * 2);
    if (availableContentWidth < 0) {
      availableContentWidth = 0;
    }

    var availableInnerWidth = availableContentWidth - (innerPadding * 2);
    if (availableInnerWidth < 0) {
      availableInnerWidth = 0;
    }

    if (availableInnerWidth > 0 && totalButtons > 0) {
      final initialRequiredWidth = _clusterWidth(leadingCount, buttonWidth, tabSpacing) +
          centerGap +
          _clusterWidth(trailingCount, buttonWidth, tabSpacing);

      var overflow = initialRequiredWidth - availableInnerWidth;

      if (overflow > 0) {
        final maxGapReduction = centerGap - minCenterGap;
        if (maxGapReduction > 0) {
          final reduction = overflow < maxGapReduction ? overflow : maxGapReduction;
          centerGap -= reduction;
          overflow -= reduction;
        }

        if (overflow > 0 && totalSpacing > 0) {
          final maxSpacingReduction = (tabSpacing - minTabSpacing) * totalSpacing;
          if (maxSpacingReduction > 0) {
            final reduction = overflow < maxSpacingReduction ? overflow : maxSpacingReduction;
            tabSpacing -= reduction / totalSpacing;
            overflow -= reduction;
          }
        }

        if (overflow > 0) {
          final maxButtonReduction = (buttonWidth - minButtonWidth) * totalButtons;
          if (maxButtonReduction > 0) {
            final reduction = overflow < maxButtonReduction ? overflow : maxButtonReduction;
            buttonWidth -= reduction / totalButtons;
            overflow -= reduction;
          }
        }

        if (overflow > 0) {
          final shrinkDenominator = totalButtons + totalSpacing + 1;
          if (shrinkDenominator > 0) {
            final shrinkStep = overflow / shrinkDenominator;
            final nextButtonWidth = buttonWidth - shrinkStep;
            buttonWidth = nextButtonWidth < 28.0 ? 28.0 : nextButtonWidth;
            if (totalSpacing > 0) {
              final nextSpacing = tabSpacing - shrinkStep;
              tabSpacing = nextSpacing < 4.0 ? 4.0 : nextSpacing;
            }
            final nextGap = centerGap - shrinkStep;
            final minGap = fabDiameter + 4;
            centerGap = nextGap < minGap ? minGap : nextGap;
          }
        }
      }
    }

    return _NavigationMetrics(
      buttonWidth: buttonWidth,
      tabSpacing: tabSpacing,
      centerGap: centerGap,
      containerHeight: baseHeight + heightBoost,
      containerRadius: lerpDouble(22, 30, t)!,
      horizontalPadding: innerPadding,
      outerHorizontalPadding: outerPadding,
      bottomMargin: lerpDouble(8, 16, t)!,
      safeAreaPadding: lerpDouble(8, 14, t)!,
    );
  }

  static int _spacingCount(int itemCount) => itemCount > 1 ? itemCount - 1 : 0;

  static double _clusterWidth(
    int itemCount,
    double buttonWidth,
    double tabSpacing,
  ) {
    if (itemCount <= 0) {
      return 0;
    }
    if (itemCount == 1) {
      return buttonWidth;
    }
    return (itemCount * buttonWidth) + ((itemCount - 1) * tabSpacing);
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.semanticsLabel,
    required this.child,
  });

  final String icon;
  final String selectedIcon;
  final String semanticsLabel;
  final Widget child;
}

// ignore: unused_element
class _TabCluster extends StatelessWidget {
  const _TabCluster({required this.children, required this.spacing});

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          children[i],
        ],
      ],
    );
  }
}
