import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/material.dart';

/// Shared language toggle widget used across the onboarding and auth flows.
class AppLanguageToggle extends StatelessWidget {
  const AppLanguageToggle({
    super.key,
    required this.selectedLanguage,
    required this.onSelected,
  });

  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    final selections = AppLanguage.values
        .map((language) => language == selectedLanguage)
        .toList(growable: false);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryColor1.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ToggleButtons(
        isSelected: selections,
        onPressed: (index) {
          final language = AppLanguage.values[index];
          if (language != selectedLanguage) {
            onSelected(language);
          }
        },
        borderRadius: BorderRadius.circular(24),
        borderColor: TColor.primaryColor1,
        selectedBorderColor: TColor.primaryColor1,
        color: TColor.primaryColor1,
        selectedColor: TColor.white,
        fillColor: TColor.primaryColor1,
        splashColor: TColor.primaryColor2,
        renderBorder: true,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 52),
        children: AppLanguage.values
            .map(
              (language) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.translate, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      language.buttonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
