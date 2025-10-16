import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/widgets.dart';

/// Controller that stores the currently selected [AppLanguage].
class AppLanguageController extends ChangeNotifier {
  AppLanguageController({AppLanguage initialLanguage = AppLanguage.english})
      : _language = initialLanguage;

  AppLanguage _language;

  AppLanguage get language => _language;

  /// Selects the given [language] and notifies listeners if the value changes.
  bool select(AppLanguage language) {
    if (language == _language) return false;
    _language = language;
    notifyListeners();
    return true;
  }

  /// Cycles to the next available language in [AppLanguage.values].
  void cycle() {
    final values = AppLanguage.values;
    final nextIndex = (values.indexOf(_language) + 1) % values.length;
    select(values[nextIndex]);
  }
}

/// Provides the [AppLanguageController] to the widget subtree.
class AppLanguageScope extends InheritedNotifier<AppLanguageController> {
  const AppLanguageScope({
    super.key,
    required AppLanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLanguageController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'No AppLanguageScope found in context');
    return controller!;
  }

  static AppLanguageController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppLanguageScope>()
        ?.notifier;
  }

  static AppLanguage languageOf(BuildContext context) => of(context).language;

  static String localizedText(BuildContext context, LocalizedText text) {
    return text.resolve(languageOf(context));
  }
}

extension AppLanguageContextX on BuildContext {
  AppLanguage get appLanguage => AppLanguageScope.languageOf(this);

  String localize(LocalizedText text) => text.resolve(appLanguage);

  AppLanguageController get appLanguageController => AppLanguageScope.of(this);
}
