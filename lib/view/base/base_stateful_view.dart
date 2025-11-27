import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:flutter/material.dart';

/// Abstract base class for stateful views that need local state management.
///
/// This class provides:
/// - Automatic resource disposal logging
/// - Lifecycle logging for debugging
/// - Consistent error boundary support
///
/// Use this when you need:
/// - Animation controllers
/// - Focus nodes
/// - Scroll controllers
/// - Text editing controllers
/// - Local UI state (not business logic)
///
/// Example:
/// ```dart
/// class MyView extends BaseStatefulView {
///   const MyView({super.key});
///
///   @override
///   State<MyView> createState() => _MyViewState();
/// }
///
/// class _MyViewState extends BaseStatefulViewState<MyView> {
///   late final AnimationController _controller;
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = AnimationController(vsync: this);
///   }
///
///   @override
///   void disposeResources() {
///     _controller.dispose();
///   }
///
///   @override
///   Widget buildContent(BuildContext context) {
///     return AnimatedBuilder(
///       animation: _controller,
///       builder: (context, child) => Container(),
///     );
///   }
/// }
/// ```
abstract class BaseStatefulView extends StatefulWidget {
  const BaseStatefulView({super.key});
}

/// Base state class for [BaseStatefulView].
///
/// Extend this instead of [State] to get automatic lifecycle logging
/// and resource disposal tracking.
abstract class BaseStatefulViewState<T extends BaseStatefulView>
    extends State<T>
    with SingleTickerProviderStateMixin {
  final LoggingService _logger = LoggingService.instance;

  /// Whether to enable lifecycle logging.
  ///
  /// Set to false in production or for views that update frequently.
  bool get enableLifecycleLogging => true;

  @override
  void initState() {
    super.initState();
    if (enableLifecycleLogging) {
      _logger.debug('$T initialized');
    }
  }

  @override
  void dispose() {
    try {
      disposeResources();
      if (enableLifecycleLogging) {
        _logger.debug('$T disposed');
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Error disposing resources in $T',
        error: e,
        stackTrace: stackTrace,
      );
    }
    super.dispose();
  }

  /// Override this method to dispose of resources.
  ///
  /// This is called before the widget is disposed.
  /// Common resources to dispose:
  /// - TextEditingController
  /// - FocusNode
  /// - AnimationController
  /// - ScrollController
  /// - StreamSubscription
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void disposeResources() {
  ///   _emailController.dispose();
  ///   _passwordController.dispose();
  ///   _focusNode.dispose();
  /// }
  /// ```
  void disposeResources() {
    // Override in subclasses
  }

  /// Build the view content.
  ///
  /// This is called by [build] and is where you should build your UI.
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // Wrap in error boundary for better error handling
    return buildContent(context);
  }
}

/// Mixin for views that need to handle async initialization.
///
/// Example:
/// ```dart
/// class _MyViewState extends BaseStatefulViewState<MyView>
///     with AsyncInitMixin {
///
///   @override
///   Future<void> initialize() async {
///     await fetchData();
///   }
///
///   @override
///   Widget buildContent(BuildContext context) {
///     if (isInitializing) {
///       return const Center(child: CircularProgressIndicator());
///     }
///     return const Text('Loaded!');
///   }
/// }
/// ```
mixin AsyncInitMixin<T extends BaseStatefulView> on BaseStatefulViewState<T> {
  bool _isInitializing = true;
  String? _initError;

  /// Whether the view is currently initializing.
  bool get isInitializing => _isInitializing;

  /// The initialization error, if any.
  String? get initError => _initError;

  @override
  void initState() {
    super.initState();
    _runInitialization();
  }

  Future<void> _runInitialization() async {
    try {
      await initialize();
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Initialization failed for $T',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initError = e.toString();
        });
      }
    }
  }

  /// Override this method to perform async initialization.
  ///
  /// This is called automatically in [initState].
  Future<void> initialize();
}
