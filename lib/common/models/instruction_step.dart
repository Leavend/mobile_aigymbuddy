import 'package:flutter/foundation.dart';

@immutable
class InstructionStep {
  const InstructionStep({
    required this.number,
    required this.description,
    this.title,
  });

  final String number;
  final String description;
  final String? title;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstructionStep &&
        other.number == number &&
        other.description == description &&
        other.title == title;
  }

  @override
  int get hashCode => Object.hash(number, description, title);

  @override
  String toString() =>
      'InstructionStep(number: $number, title: $title, description: $description)';
}
