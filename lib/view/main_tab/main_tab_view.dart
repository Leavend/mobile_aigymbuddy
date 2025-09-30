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
  static const double _centerGap = _fabDiameter + 20;
  static const double _tabSpacing = 32;

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
    // TODO(assistant): Integrasikan aksi Assistant ketika fitur siap.
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
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: _tabSpacing),
          TabButton(
            icon: items[i].icon,
            selectIcon: items[i].selectedIcon,
            semanticsLabel: items[i].semanticsLabel,
            isActive: _selected == startIndex + i,
            onTap: () => _handleTabSelected(startIndex + i),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final pad = MediaQuery.of(context).padding;
    final bottomInset = pad.bottom;

    final midpoint = (_items.length / 2).ceil();
    final leadingItems = _items.sublist(0, midpoint);
    final trailingItems = _items.sublist(midpoint);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          bottomInset > 0 ? bottomInset : 12,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildTabCluster(
                        items: leadingItems,
                        startIndex: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: _centerGap),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildTabCluster(
                        items: trailingItems,
                        startIndex: leadingItems.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

class _TabCluster extends StatelessWidget {
  const _TabCluster({
    required this.children,
    required this.spacing,
  });

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
