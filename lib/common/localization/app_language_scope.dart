import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:flutter/widgets.dart';

/// Controller that stores the currently selected [AppLanguage].
class AppLanguageController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  void select(AppLanguage language) {
    if (language == _language) return;
    _language = language;
    notifyListeners();
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
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    assert(scope != null, 'No AppLanguageScope found in context');
    return scope!.notifier!;
  }

  static AppLanguage languageOf(BuildContext context) => of(context).language;

  static String localizedText(BuildContext context, LocalizedText text) {
    return text.resolve(languageOf(context));
  }
}

extension AppLanguageContextX on BuildContext {
  AppLanguage get appLanguage => AppLanguageScope.languageOf(this);

  String localize(LocalizedText text) => text.resolve(appLanguage);
}
