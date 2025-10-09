import 'package:flutter/material.dart';

/// Centralized color palette for the application.
///
/// Using `static const` fields avoids creating new [Color] instances every
/// time a value is accessed and enables const expressions in widgets.
abstract final class TColor {
  // Primary Colors - Blue Theme (better balanced)
  static const Color primaryColor1 = Color(0xff92A3FD);
  static const Color primaryColor2 = Color(0xff9DCEFF);

  // Secondary Colors
  static const Color secondaryColor1 = Color(0xffC58BF2);
  static const Color secondaryColor2 = Color(0xffEEA4CE);

  // Gradients
  static const List<Color> primaryG = [primaryColor1, primaryColor2];
  static const List<Color> secondaryG = [secondaryColor1, secondaryColor2];
  static const LinearGradient primaryGradient = LinearGradient(
    colors: primaryG,
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: secondaryG,
  );

  // Supporting Colors
  static const Color black = Color(0xff1D1617);
  static const Color yellow = Color(0xffFFC72C);
  static const Color white = Colors.white;
  static const Color lightGray = Color(0xffF7F8F8);
  static const Color gray = Color.fromARGB(172, 94, 111, 111);

  /// Builds a [ColorScheme] seeded from the primary palette for consistent
  /// Material 3 styling across the app.
  static ColorScheme colorScheme(Brightness brightness) {
    final seed = brightness == Brightness.dark ? primaryColor2 : primaryColor1;
    return ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  }
}
