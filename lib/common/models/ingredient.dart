import 'package:flutter/foundation.dart';

@immutable
class Ingredient {
  const Ingredient({
    required this.image,
    required this.name,
    required this.amount,
  });

  final String image;
  final String name;
  final String amount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ingredient &&
        other.image == image &&
        other.name == name &&
        other.amount == amount;
  }

  @override
  int get hashCode => Object.hash(image, name, amount);

  @override
  String toString() => 'Ingredient(image: $image, name: $name, amount: $amount)';
}
