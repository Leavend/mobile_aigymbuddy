// lib/view/main_tab/main_tab_view.dart

import 'dart:math' as math;
import 'dart:ui';

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/tab_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _fabDiameter = 64;

  static const List<_NavigationItem> _items = [
    _NavigationItem(
      icon: 'assets/img/home_tab.png',
      selectedIcon: 'assets/img/home_tab_select.png',
      label: LocalizedText(english: 'Home', indonesian: 'Beranda'),
    ),
    _NavigationItem(
      icon: 'assets/img/activity_tab.png',
      selectedIcon: 'assets/img/activity_tab_select.png',
      label: LocalizedText(english: 'Activities', indonesian: 'Aktivitas'),
    ),
    _NavigationItem(
      icon: 'assets/img/camera_tab.png',
      selectedIcon: 'assets/img/camera_tab_select.png',
      label: LocalizedText(english: 'Progress', indonesian: 'Progres'),
    ),
    _NavigationItem(
      icon: 'assets/img/profile_tab.png',
      selectedIcon: 'assets/img/profile_tab_select.png',
      label: LocalizedText(english: 'Profile', indonesian: 'Profil'),
    ),
  ];

  static const LocalizedText _assistantLabel = LocalizedText(
    english: 'AI Assistant',
    indonesian: 'Asisten AI',
  );

  void _handleTabSelected(int index) {
    if (index == navigationShell.currentIndex) {
      navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const _AssistantButton(
        diameter: _fabDiameter,
        label: _assistantLabel,
      ),
      bottomNavigationBar: _NavigationBar(
        navigationShell: navigationShell,
        items: _items,
        fabDiameter: _fabDiameter,
        onItemSelected: _handleTabSelected,
      ),
    );
  }
}

class _AssistantButton extends StatelessWidget {
  const _AssistantButton({required this.diameter, required this.label});

  final double diameter;
  final LocalizedText label;

  void _handleTap(BuildContext context) {
    Feedback.forTap(context);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final semanticsLabel = context.localize(label);

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: SizedBox(
        width: diameter,
        height: diameter,
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
                onTap: () => _handleTap(context),
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
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.navigationShell,
    required this.items,
    required this.fabDiameter,
    required this.onItemSelected,
  });

  final StatefulNavigationShell navigationShell;
  final List<_NavigationItem> items;
  final double fabDiameter;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    assert(
      navigationShell.route.branches.length == items.length,
      'Navigation branches (${navigationShell.route.branches.length}) must match tab '
      'configuration (${items.length}).',
    );

    final midpoint = (items.length / 2).ceil();
    final leadingItems = items.sublist(0, midpoint);
    final trailingItems = items.sublist(midpoint);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context);
        final textScale = scaler.scale(1.0);
        final metrics = _NavigationMetrics.resolve(
          availableWidth: constraints.maxWidth,
          fabDiameter: fabDiameter,
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
                    borderRadius: BorderRadius.circular(
                      metrics.containerRadius,
                    ),
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
                              child: _TabCluster(
                                items: leadingItems,
                                startIndex: 0,
                                metrics: metrics,
                                navigationShell: navigationShell,
                                onItemSelected: onItemSelected,
                              ),
                            ),
                          ),
                          SizedBox(width: metrics.centerGap),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _TabCluster(
                                items: trailingItems,
                                startIndex: leadingItems.length,
                                metrics: metrics,
                                navigationShell: navigationShell,
                                onItemSelected: onItemSelected,
                              ),
                            ),
                          ),
                        ],
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
}

class _TabCluster extends StatelessWidget {
  const _TabCluster({
    required this.items,
    required this.startIndex,
    required this.metrics,
    required this.navigationShell,
    required this.onItemSelected,
  });

  final List<_NavigationItem> items;
  final int startIndex;
  final _NavigationMetrics metrics;
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: metrics.tabSpacing),
          TabButton(
            icon: items[i].icon,
            selectIcon: items[i].selectedIcon,
            semanticsLabel: localize(items[i].label),
            isActive: navigationShell.currentIndex == startIndex + i,
            width: metrics.buttonWidth,
            onTap: () => onItemSelected(startIndex + i),
          ),
        ],
      ],
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
    final interpolationFactor =
        (clampedWidth - _minWidth) / (_maxWidth - _minWidth);

    final baseHeight = lerpDouble(56, 72, interpolationFactor)!;
    final textScale = textScaleFactor.clamp(1.0, 1.3);
    final heightBoost = (textScale - 1.0) * 12;

    final metrics = _DimensionSnapshot(
      buttonWidth: lerpDouble(48, 64, interpolationFactor)!,
      tabSpacing: lerpDouble(12, 28, interpolationFactor)!,
      centerGap: fabDiameter + lerpDouble(12, 28, interpolationFactor)!,
      outerPadding: lerpDouble(16, 32, interpolationFactor)!,
      innerPadding: lerpDouble(16, 28, interpolationFactor)!,
    );

    final totalButtons = leadingCount + trailingCount;
    final totalSpacing =
        _spacingCount(leadingCount) + _spacingCount(trailingCount);

    final constraints = _DimensionConstraints(
      availableWidth: availableWidth,
      fabDiameter: fabDiameter,
      totalButtons: totalButtons,
      totalSpacing: totalSpacing,
      leadingCount: leadingCount,
      trailingCount: trailingCount,
    );

    final resolved = _shrinkToFit(metrics, constraints);

    return _NavigationMetrics(
      buttonWidth: resolved.buttonWidth,
      tabSpacing: resolved.tabSpacing,
      centerGap: resolved.centerGap,
      containerHeight: baseHeight + heightBoost,
      containerRadius: lerpDouble(22, 30, interpolationFactor)!,
      horizontalPadding: resolved.innerPadding,
      outerHorizontalPadding: resolved.outerPadding,
      bottomMargin: lerpDouble(8, 16, interpolationFactor)!,
      safeAreaPadding: lerpDouble(8, 14, interpolationFactor)!,
    );
  }

  static _DimensionSnapshot _shrinkToFit(
    _DimensionSnapshot snapshot,
    _DimensionConstraints constraints,
  ) {
    if (snapshot.innerPadding <= 0 ||
        constraints.totalButtons <= 0 ||
        constraints.availableWidth <= 0) {
      return snapshot;
    }

    final availableContentWidth = math.max(
      constraints.availableWidth - (snapshot.outerPadding * 2),
      0,
    );
    final availableInnerWidth = math.max(
      availableContentWidth - (snapshot.innerPadding * 2),
      0,
    );

    if (availableInnerWidth == 0) {
      return snapshot;
    }

    var buttonWidth = snapshot.buttonWidth;
    var tabSpacing = snapshot.tabSpacing;
    var centerGap = snapshot.centerGap;
    final requiredWidth =
        _clusterWidth(constraints.leadingCount, buttonWidth, tabSpacing) +
        centerGap +
        _clusterWidth(constraints.trailingCount, buttonWidth, tabSpacing);

    var overflow = requiredWidth - availableInnerWidth;
    if (overflow <= 0) {
      return snapshot;
    }

    const minTabSpacing = 8.0;
    const minButtonWidth = 36.0;
    final minCenterGap = constraints.fabDiameter + 8;

    void reduceGap(double amount) {
      if (amount <= 0) return;
      centerGap -= amount;
      overflow -= amount;
    }

    void reduceSpacing(double amountPerSpacing) {
      if (amountPerSpacing <= 0) return;
      tabSpacing -= amountPerSpacing;
      overflow -= amountPerSpacing * constraints.totalSpacing;
    }

    void reduceButtonWidth(double amountPerButton) {
      if (amountPerButton <= 0) return;
      buttonWidth -= amountPerButton;
      overflow -= amountPerButton * constraints.totalButtons;
    }

    final maxGapReduction = centerGap - minCenterGap;
    if (maxGapReduction > 0) {
      reduceGap(math.min(overflow, maxGapReduction));
    }

    if (overflow > 0 && constraints.totalSpacing > 0) {
      final maxSpacingReduction =
          (tabSpacing - minTabSpacing) * constraints.totalSpacing;
      if (maxSpacingReduction > 0) {
        final reduction = math.min(overflow, maxSpacingReduction);
        reduceSpacing(reduction / constraints.totalSpacing);
      }
    }

    if (overflow > 0) {
      final maxButtonReduction =
          (buttonWidth - minButtonWidth) * constraints.totalButtons;
      if (maxButtonReduction > 0) {
        final reduction = math.min(overflow, maxButtonReduction);
        reduceButtonWidth(reduction / constraints.totalButtons);
      }
    }

    if (overflow > 0) {
      final shrinkDenominator =
          constraints.totalButtons + constraints.totalSpacing + 1;
      if (shrinkDenominator > 0) {
        final shrinkStep = overflow / shrinkDenominator;
        buttonWidth = math.max(buttonWidth - shrinkStep, 28.0);
        if (constraints.totalSpacing > 0) {
          tabSpacing = math.max(tabSpacing - shrinkStep, 4.0);
        }
        final minGap = constraints.fabDiameter + 4;
        centerGap = math.max(centerGap - shrinkStep, minGap);
      }
    }

    return snapshot.copyWith(
      buttonWidth: buttonWidth,
      tabSpacing: tabSpacing,
      centerGap: centerGap,
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
    required this.label,
  });

  final String icon;
  final String selectedIcon;
  final LocalizedText label;
}

class _DimensionSnapshot {
  const _DimensionSnapshot({
    required this.buttonWidth,
    required this.tabSpacing,
    required this.centerGap,
    required this.outerPadding,
    required this.innerPadding,
  });

  final double buttonWidth;
  final double tabSpacing;
  final double centerGap;
  final double outerPadding;
  final double innerPadding;

  _DimensionSnapshot copyWith({
    double? buttonWidth,
    double? tabSpacing,
    double? centerGap,
  }) {
    return _DimensionSnapshot(
      buttonWidth: buttonWidth ?? this.buttonWidth,
      tabSpacing: tabSpacing ?? this.tabSpacing,
      centerGap: centerGap ?? this.centerGap,
      outerPadding: outerPadding,
      innerPadding: innerPadding,
    );
  }
}

class _DimensionConstraints {
  const _DimensionConstraints({
    required this.availableWidth,
    required this.fabDiameter,
    required this.totalButtons,
    required this.totalSpacing,
    required this.leadingCount,
    required this.trailingCount,
  });

  final double availableWidth;
  final double fabDiameter;
  final int totalButtons;
  final int totalSpacing;
  final int leadingCount;
  final int trailingCount;
}
