import 'package:flutter/widgets.dart';

import 'bootstrap.dart';

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.dependencies, required super.child});

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) {
    return oldWidget.dependencies != dependencies;
  }
}
