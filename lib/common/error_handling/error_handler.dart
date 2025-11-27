import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/exceptions/app_exceptions.dart';
import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:flutter/material.dart';

/// Centralized error handling utility for consistent error management across the app.
///
/// This class provides:
/// - Consistent error logging
/// - User-friendly error messages
/// - Retry functionality
/// - Different error display methods (dialog, snackbar, inline)
///
/// Example:
/// ```dart
/// try {
///   await someOperation();
/// } catch (error, stackTrace) {
///   if (!mounted) return;
///   ErrorHandler.handleError(
///     context,
///     error: error,
///     stackTrace: stackTrace,
///     userMessage: 'Failed to complete operation',
///     onRetry: () => someOperation(),
///   );
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  static final LoggingService _logger = LoggingService.instance;

  /// Handle an error with appropriate logging and user feedback.
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing dialogs/snackbars
  /// - [error]: The error object
  /// - [stackTrace]: Optional stack trace for debugging
  /// - [userMessage]: Optional user-friendly message (auto-generated if null)
  /// - [onRetry]: Optional retry callback
  /// - [displayType]: How to display the error (dialog, snackbar, inline)
  static void handleError(
    BuildContext context, {
    required Object error,
    StackTrace? stackTrace,
    String? userMessage,
    VoidCallback? onRetry,
    ErrorDisplayType displayType = ErrorDisplayType.dialog,
  }) {
    // Log the error for debugging
    _logger.error(
      userMessage ?? 'An error occurred',
      error: error,
      stackTrace: stackTrace,
    );

    // Generate user-friendly message
    final message = userMessage ?? _getUserFriendlyMessage(error);

    // Display error to user
    switch (displayType) {
      case ErrorDisplayType.dialog:
        _showErrorDialog(context, message, onRetry);
      case ErrorDisplayType.snackbar:
        _showErrorSnackbar(context, message, onRetry);
      case ErrorDisplayType.inline:
        // Inline errors are handled by the widget itself
        break;
    }
  }

  /// Get a user-friendly error message based on the error type.
  static String _getUserFriendlyMessage(Object error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is NetworkException) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else if (error is AppException) {
      return error.message;
    } else {
      return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
    }
  }

  /// Show an error dialog with optional retry button.
  static void _showErrorDialog(
    BuildContext context,
    String message,
    VoidCallback? onRetry,
  ) {
    unawaited(showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: TColor.secondaryColor1, size: 28),
            SizedBox(width: 12),
            Text('Oops!', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: TColor.gray, fontSize: 14),
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: TColor.primaryColor1),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Tutup',
              style: TextStyle(
                color: onRetry != null ? TColor.gray : TColor.primaryColor1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show an error snackbar with optional retry action.
  static void _showErrorSnackbar(
    BuildContext context,
    String message,
    VoidCallback? onRetry,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: TColor.secondaryColor1,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: onRetry != null
              ? SnackBarAction(
                  label: 'Coba Lagi',
                  textColor: Colors.white,
                  onPressed: onRetry,
                )
              : null,
        ),
      );
  }

  /// Show a success message to the user.
  static void showSuccess(
    BuildContext context,
    String message, {
    ErrorDisplayType displayType = ErrorDisplayType.snackbar,
  }) {
    switch (displayType) {
      case ErrorDisplayType.dialog:
        _showSuccessDialog(context, message);
      case ErrorDisplayType.snackbar:
        _showSuccessSnackbar(context, message);
      case ErrorDisplayType.inline:
        break;
    }
  }

  /// Show a success dialog.
  static void _showSuccessDialog(BuildContext context, String message) {
    unawaited(showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: TColor.primaryColor1,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Berhasil!',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: TColor.gray, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: TColor.primaryColor1)),
          ),
        ],
      ),
    );
  }

  /// Show a success snackbar.
  static void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: TColor.primaryColor1,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

/// Enum for different ways to display errors.
enum ErrorDisplayType {
  /// Show error in a dialog (blocking)
  dialog,

  /// Show error in a snackbar (non-blocking)
  snackbar,

  /// Show error inline in the widget (custom handling)
  inline,
}
