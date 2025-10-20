// lib/common/di/app_scope.dart

import 'package:flutter/widgets.dart';

import 'package:aigymbuddy/database/app_db.dart';

import '../../features/auth/application/auth_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.database,
    required this.authController,
    required super.child,
  });

  final AppDatabase database;
  final AuthController authController;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  static AppScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>();
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}

extension AppScopeX on BuildContext {
  AuthController get authController => AppScope.of(this).authController;

  AppDatabase get database => AppScope.of(this).database;
}
