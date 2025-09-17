import 'package:flutter/material.dart';

class TColor {
  // Primary Colors - Blue Theme (Better balanced)
  static Color get primaryColor1 => const Color(0xff0096D6);
  static Color get primaryColor2 => const Color(0xff004C6D);
  
  // Secondary Colors - Complementary Orange Theme
  static Color get secondaryColor1 => const Color(0xff76B900);
  static Color get secondaryColor2 => const Color(0xffFF8C42);
  
  // Gradients
  static List<Color> get primaryG => [primaryColor1, primaryColor2];
  static List<Color> get secondaryG => [secondaryColor1, secondaryColor2];
  
  // Supporting Colors
  static Color get black => const Color(0xff1D1617);
  static Color get yellow => const Color(0xffFFC72C);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
}
