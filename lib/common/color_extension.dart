import 'package:flutter/material.dart';

class TColor {
  // Primary Colors - Blue Theme (Better balanced)
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  // Secondary Colors
  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  // Gradients
  static List<Color> get primaryG => [primaryColor1, primaryColor2];
  static List<Color> get secondaryG => [secondaryColor1, secondaryColor2];

  // Supporting Colors
  static Color get black => const Color(0xff1D1617);
  static Color get yellow => const Color(0xffFFC72C);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
  static Color get gray => const Color.fromARGB(172, 94, 111, 111);
}
