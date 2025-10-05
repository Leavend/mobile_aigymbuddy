import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/widgets.dart';

/// Mixin that stores the currently selected [AppLanguage] and exposes helpers
/// to update the language while triggering a rebuild.
mixin AppLanguageState<T extends StatefulWidget> on State<T> {
  AppLanguage language = AppLanguage.english;

  /// Updates the language if the new value differs from the current one.
  void updateLanguage(AppLanguage newLanguage) {
    if (newLanguage == language) return;

    setState(() {
      language = newLanguage;
    });
  }

  /// Resolves the given [LocalizedText] using the current [language].
  String localized(LocalizedText text) => text.resolve(language);
}
