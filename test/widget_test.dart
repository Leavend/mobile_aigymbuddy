// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/view/sleep_tracker/sleep_schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SleepScheduleView builds and displays title',
      (WidgetTester tester) async {
    // Create an instance of the language controller for the test.
    final appLanguageController = AppLanguageController();

    // Build the SleepScheduleView widget wrapped in necessary providers.
    await tester.pumpWidget(
      MaterialApp(
        home: AppLanguageScope(
          controller:
              appLanguageController, // Set a default language controller for testing
          child: const SleepScheduleView(),
        ),
      ),
    );

    // Allow the widget to settle.
    await tester.pumpAndSettle();

    // Verify that the title is displayed.
    expect(find.text('Sleep Schedule'), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
