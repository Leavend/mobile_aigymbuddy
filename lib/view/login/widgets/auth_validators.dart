import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:flutter/widgets.dart';

/// Collection of reusable validators used across the authentication flow.
abstract final class AuthValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  static bool isValidEmail(String value) =>
      _emailRegExp.hasMatch(value.trim().toLowerCase());

  static String? validateEmail({
    required BuildContext context,
    required String? value,
    required LocalizedText emptyMessage,
    required LocalizedText invalidMessage,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return context.localize(emptyMessage);
    }
    if (!isValidEmail(text)) {
      return context.localize(invalidMessage);
    }
    return null;
  }

  static String? validateRequired({
    required BuildContext context,
    required String? value,
    required LocalizedText emptyMessage,
    bool trim = true,
  }) {
    final text = trim ? value?.trim() ?? '' : value ?? '';
    if (text.isEmpty) {
      return context.localize(emptyMessage);
    }
    return null;
  }

  static String? validatePassword({
    required BuildContext context,
    required String? value,
    required LocalizedText emptyMessage,
    required LocalizedText lengthMessage,
    int minLength = 8,
  }) {
    final text = value ?? '';
    if (text.isEmpty) {
      return context.localize(emptyMessage);
    }
    if (text.length < minLength) {
      return context.localize(lengthMessage);
    }
    return null;
  }
}
