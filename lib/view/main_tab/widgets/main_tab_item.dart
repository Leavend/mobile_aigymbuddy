import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/foundation.dart';

@immutable
class MainTabItem {
  const MainTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String icon;
  final String selectedIcon;
  final LocalizedText label;
}
