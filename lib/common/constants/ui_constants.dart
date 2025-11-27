import 'package:flutter/material.dart';

class UIConstants {
  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 100.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeHeading = 24.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Common Paddings
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(spacingLarge);

  static const EdgeInsets paddingHMedium = EdgeInsets.symmetric(
    horizontal: spacingMedium,
  );
  static const EdgeInsets paddingVMedium = EdgeInsets.symmetric(
    vertical: spacingMedium,
  );
}
