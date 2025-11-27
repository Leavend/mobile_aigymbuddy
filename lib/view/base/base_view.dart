import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Abstract base class for views that use Provider for state management.
///
/// This enforces a consistent pattern where views consume a controller
/// and delegate UI building to [buildContent].
///
/// Example:
/// ```dart
/// class HomeView extends BaseView<HomeController> {
///   const HomeView({super.key});
///
///   @override
///   Widget buildContent(BuildContext context, HomeController controller) {
///     return Scaffold(
///       body: Text(controller.someData),
///     );
///   }
/// }
/// ```
abstract class BaseView<T extends ChangeNotifier> extends StatelessWidget {
  const BaseView({super.key});

  /// Build the view content with access to the controller.
  ///
  /// The controller is automatically provided via [Consumer].
  Widget buildContent(BuildContext context, T controller);

  /// Optional: Provide a loading widget while controller initializes.
  ///
  /// Override this if your controller has an async initialization.
  Widget buildLoading(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  /// Optional: Provide an error widget if controller has errors.
  ///
  /// Override this if you want custom error UI.
  Widget buildError(BuildContext context, String error) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  /// Check if the controller has an error state.
  ///
  /// Override this if your controller has a different error state mechanism.
  bool hasError(T controller) => false;

  /// Get the error message from the controller.
  ///
  /// Override this if your controller has a different error state mechanism.
  String? getErrorMessage(T controller) => null;

  /// Check if the controller is in a loading state.
  ///
  /// Override this if your controller has a different loading state mechanism.
  bool isLoading(T controller) => false;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, controller, _) {
        // Check for error state
        if (hasError(controller)) {
          final error = getErrorMessage(controller);
          return buildError(context, error ?? 'An error occurred');
        }

        // Check for loading state
        if (isLoading(controller)) {
          return buildLoading(context);
        }

        // Build normal content
        return buildContent(context, controller);
      },
    );
  }
}
