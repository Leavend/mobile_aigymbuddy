import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Global application state shared with the router for launch decisions.
class AppStateController extends ChangeNotifier {
  AppStateController({bool hasProfile = false}) : _hasProfile = hasProfile;

  bool _hasProfile;

  bool get hasProfile => _hasProfile;

  void updateHasProfile(bool value) {
    if (_hasProfile == value) {
      return;
    }
    _hasProfile = value;
    notifyListeners();
  }
}

/// Provides [AppStateController] down the widget tree.
class AppStateScope extends InheritedNotifier<AppStateController> {
  const AppStateScope({
    super.key,
    required AppStateController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppStateController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
