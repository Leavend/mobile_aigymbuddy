import 'package:flutter/foundation.dart';

@immutable
class NutritionInfo {
  const NutritionInfo({
    required this.image,
    required this.title,
    required this.value,
  });

  final String image;
  final String title;
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NutritionInfo &&
        other.image == image &&
        other.title == title &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(image, title, value);

  @override
  String toString() => 'NutritionInfo(title: $title, value: $value)';
}
