class InstructionStep {
  const InstructionStep({
    required this.number,
    required this.description,
    this.title,
  });

  final String number;
  final String description;
  final String? title;
}
