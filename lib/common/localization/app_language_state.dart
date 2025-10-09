import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/widgets.dart';

/// Mixin that stores the currently selected [AppLanguage] and exposes helpers
/// to update the language while triggering a rebuild.
mixin AppLanguageState<T extends StatefulWidget> on State<T> {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  /// Updates the language if the new value differs from the current one.
  void updateLanguage(AppLanguage newLanguage) {
    if (newLanguage == _language) return;

    setState(() {
      _language = newLanguage;
    });
    onLanguageChanged(newLanguage);
  }

  /// Hook for subclasses that want to react to language changes.
  @protected
  void onLanguageChanged(AppLanguage language) {}

  /// Resolves the given [LocalizedText] using the current [language].
  String localized(LocalizedText text) => text.resolve(_language);
}
