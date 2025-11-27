import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Test helpers and utilities for widget and integration tests.
///
/// This file provides common testing utilities including:
/// - Mock implementations
/// - Widget wrapper helpers
/// - Test data builders
/// - Common test assertions

// Manual Mock classes for testing (avoiding mockito dependency)

/// Mock implementation of AuthRepositoryInterface for testing.
class MockAuthRepository implements AuthRepositoryInterface {
  AuthUser? mockUser;
  Exception? throwOnLogin;
  Exception? throwOnRegister;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (throwOnLogin != null) throw throwOnLogin!;
    return mockUser ??
        AuthUser(id: 'test-id', email: email, displayName: email);
  }

  @override
  Future<AuthUser> register(SignUpData data) async {
    if (throwOnRegister != null) throw throwOnRegister!;
    return mockUser ??
        AuthUser(id: 'test-id', email: data.email, displayName: data.email);
  }
}

/// Mock implementation of AuthUseCase for testing.
class MockAuthUseCase implements AuthUseCase {
  AuthUser? mockUser;
  bool mockIsLoggedIn = false;
  Exception? throwOnLogin;
  Exception? throwOnRegister;
  Exception? throwOnLogout;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (throwOnLogin != null) throw throwOnLogin!;
    return mockUser ??
        AuthUser(id: 'test-id', email: email, displayName: email);
  }

  @override
  Future<AuthUser> register(SignUpData data) async {
    if (throwOnRegister != null) throw throwOnRegister!;
    return mockUser ??
        AuthUser(id: 'test-id', email: data.email, displayName: data.email);
  }

  @override
  Future<void> logout() async {
    if (throwOnLogout != null) throw throwOnLogout!;
  }

  @override
  Future<bool> isLoggedIn() async {
    return mockIsLoggedIn;
  }
}

/// Helper class to create test widgets with providers.
class WidgetTestHelper {
  /// Wrap a widget with MaterialApp and necessary providers for testing.
  ///
  /// Example:
  /// ```dart
  /// testWidgets('login view test', (tester) async {
  ///   await tester.pumpWidget(
  ///     WidgetTestHelper.wrapWithMaterialApp(
  ///       const LoginView(),
  ///       providers: [
  ///         ChangeNotifierProvider<AuthController>.value(
  ///           value: mockAuthController,
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// });
  /// ```
  static Widget wrapWithMaterialApp(
    Widget child, {
    List<SingleChildWidget>? providers,
    ThemeData? theme,
  }) {
    final app = MaterialApp(home: child, theme: theme);

    if (providers == null || providers.isEmpty) {
      return app;
    }

    return MultiProvider(providers: providers, child: app);
  }

  /// Wrap a widget with necessary providers and routing support.
  ///
  /// Use this when testing widgets that use GoRouter.
  static Widget wrapWithRouting(
    Widget child, {
    required Widget Function(BuildContext, Widget?) builder, List<SingleChildWidget>? providers,
  }) {
    final app = MaterialApp(
      home: Builder(builder: (context) => builder(context, child)),
    );

    if (providers == null || providers.isEmpty) {
      return app;
    }

    return MultiProvider(providers: providers, child: app);
  }
}

/// Factory class for creating mock objects with common behavior.
class MockFactory {
  /// Create a mock AuthUseCase with common default behavior.
  static MockAuthUseCase createAuthUseCase({
    AuthUser? mockUser,
    bool isLoggedIn = false,
  }) {
    return MockAuthUseCase()
      ..mockUser = mockUser
      ..mockIsLoggedIn = isLoggedIn;
  }

  /// Create a mock AuthRepository with common default behavior.
  static MockAuthRepository createAuthRepository({AuthUser? mockUser}) {
    return MockAuthRepository()..mockUser = mockUser;
  }
}

/// Test data builders for creating test data objects.
class TestDataBuilders {
  /// Build a test user with default or custom values.
  ///
  /// Example:
  /// ```dart
  /// final user = TestDataBuilders.buildUser(
  ///   email: 'test@example.com',
  ///   firstName: 'John',
  /// );
  /// ```
  static AuthUser buildUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String firstName = 'Test',
    String lastName = 'User',
    String? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? goal,
  }) {
    return AuthUser(id: id, email: email, displayName: '$firstName $lastName');
  }

  /// Build test workout data.
  static Map<String, dynamic> buildWorkout({
    String id = 'test-workout-id',
    String name = 'Test Workout',
    String type = 'cardio',
    int durationMinutes = 30,
    int caloriesBurned = 200,
    DateTime? startTime,
    String status = 'completed',
  }) {
    return {
      'id': id,
      'name': name,
      'type': type,
      'duration': durationMinutes,
      'calories_burned': caloriesBurned,
      'start_time': (startTime ?? DateTime.now()).toIso8601String(),
      'status': status,
    };
  }

  /// Build test meal data.
  static Map<String, dynamic> buildMeal({
    String id = 'test-meal-id',
    String name = 'Test Meal',
    String type = 'breakfast',
    int calories = 500,
    DateTime? scheduledTime,
  }) {
    return {
      'id': id,
      'name': name,
      'type': type,
      'calories': calories,
      'scheduled_time': (scheduledTime ?? DateTime.now()).toIso8601String(),
    };
  }

  /// Build test sleep record data.
  static Map<String, dynamic> buildSleepRecord({
    String id = 'test-sleep-id',
    DateTime? startTime,
    DateTime? endTime,
    int durationHours = 8,
    String quality = 'good',
  }) {
    final start =
        startTime ?? DateTime.now().subtract(const Duration(hours: 8));
    final end = endTime ?? DateTime.now();

    return {
      'id': id,
      'start_time': start.toIso8601String(),
      'end_time': end.toIso8601String(),
      'duration_hours': durationHours,
      'quality': quality,
    };
  }
}

/// Custom test assertions for common scenarios.
class TestAssertions {
  /// Assert that a widget is visible and contains specific text.
  static void assertTextVisible(WidgetTester tester, String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Assert that a widget is not visible.
  static void assertTextNotVisible(WidgetTester tester, String text) {
    expect(find.text(text), findsNothing);
  }

  /// Assert that a button is enabled.
  static void assertButtonEnabled(WidgetTester tester, String buttonText) {
    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, buttonText),
    );
    expect(button.enabled, isTrue);
  }

  /// Assert that a button is disabled.
  static void assertButtonDisabled(WidgetTester tester, String buttonText) {
    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, buttonText),
    );
    expect(button.enabled, isFalse);
  }

  /// Assert that a loading indicator is visible.
  static void assertLoadingVisible(WidgetTester tester) {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Assert that a loading indicator is not visible.
  static void assertLoadingNotVisible(WidgetTester tester) {
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }
}
