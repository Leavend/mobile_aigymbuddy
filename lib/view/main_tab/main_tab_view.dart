// lib/view/main_tab/main_tab_view.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/assistant_button.dart';
import 'widgets/main_tab_item.dart';
import 'widgets/main_tab_navigation_bar.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _fabDiameter = 64;

  static const List<MainTabItem> _items = [
    MainTabItem(
      icon: 'assets/img/home_tab.png',
      selectedIcon: 'assets/img/home_tab_select.png',
      label: LocalizedText(english: 'Home', indonesian: 'Beranda'),
    ),
    MainTabItem(
      icon: 'assets/img/activity_tab.png',
      selectedIcon: 'assets/img/activity_tab_select.png',
      label: LocalizedText(english: 'Activities', indonesian: 'Aktivitas'),
    ),
    MainTabItem(
      icon: 'assets/img/camera_tab.png',
      selectedIcon: 'assets/img/camera_tab_select.png',
      label: LocalizedText(english: 'Progress', indonesian: 'Progres'),
    ),
    MainTabItem(
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
      floatingActionButton: const AssistantButton(
        diameter: _fabDiameter,
        label: _assistantLabel,
      ),
      bottomNavigationBar: MainTabNavigationBar(
        navigationShell: navigationShell,
        items: _items,
        fabDiameter: _fabDiameter,
        onItemSelected: _handleTabSelected,
      ),
    );
  }
}
