import 'package:flutter/material.dart';

/// Supported application languages for localized UI text.
enum AppLanguage { english, indonesian }

extension AppLanguageX on AppLanguage {
  String get code => switch (this) {
    AppLanguage.english => 'en',
    AppLanguage.indonesian => 'id',
  };

  /// Friendly label optimised for toggle buttons and menus.
  String get buttonLabel => switch (this) {
        AppLanguage.english => 'EN',
        AppLanguage.indonesian => 'ID',
      };

  /// Human friendly language name for selection controls.
  String get displayName => switch (this) {
    AppLanguage.english => 'English',
    AppLanguage.indonesian => 'Bahasa Indonesia',
  };
}

/// Wraps a pair of localized strings for easy language resolution.
class LocalizedText {
  const LocalizedText({required this.english, required this.indonesian});

  final String english;
  final String indonesian;

  String resolve(AppLanguage language) => switch (language) {
    AppLanguage.english => english,
    AppLanguage.indonesian => indonesian,
  };
}

/// Converts an [AppLanguage] code into a [Locale].
Locale localeFromLanguage(AppLanguage language) => Locale(language.code);
