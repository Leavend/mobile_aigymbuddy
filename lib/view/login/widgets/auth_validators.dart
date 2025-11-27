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
    LocalizedText? weakMessage,
    int minLength = 8,
    bool requireStrength = true,
  }) {
    final text = value ?? '';
    if (text.isEmpty) {
      return context.localize(emptyMessage);
    }
    if (text.length < minLength) {
      return context.localize(lengthMessage);
    }

    // Check password strength if required
    if (requireStrength) {
      final hasUppercase = text.contains(RegExp('[A-Z]'));
      final hasLowercase = text.contains(RegExp('[a-z]'));
      final hasDigit = text.contains(RegExp('[0-9]'));

      if (!hasUppercase || !hasLowercase || !hasDigit) {
        return weakMessage != null
            ? context.localize(weakMessage)
            : 'Password must contain uppercase, lowercase, and numbers';
      }
    }

    return null;
  }

  /// Check password strength without returning error message
  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    if (password.length < 8) return PasswordStrength.tooShort;

    final hasUppercase = password.contains(RegExp('[A-Z]'));
    final hasLowercase = password.contains(RegExp('[a-z]'));
    final hasDigit = password.contains(RegExp('[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    final criteriaCount = [
      hasUppercase,
      hasLowercase,
      hasDigit,
      hasSpecialChar,
    ].where((e) => e).length;

    if (criteriaCount >= 4 && password.length >= 12) {
      return PasswordStrength.strong;
    } else if (criteriaCount >= 3) {
      return PasswordStrength.medium;
    } else if (criteriaCount >= 2) {
      return PasswordStrength.weak;
    } else {
      return PasswordStrength.veryWeak;
    }
  }
}

/// Password strength levels
enum PasswordStrength {
  empty,
  tooShort,
  veryWeak,
  weak,
  medium,
  strong,
}
