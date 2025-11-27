import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';

class FoodStepDetailRow extends StatelessWidget {
  const FoodStepDetailRow({required this.step, super.key, this.isLast = false});

  final InstructionStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: TColor.secondaryColor1,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: TColor.white, width: 3),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            if (!isLast)
              const DottedDashedLine(
                height: 50,
                width: 0,
                dashColor: TColor.secondaryColor1,
                axis: Axis.vertical,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title ?? 'Step ${step.number}',
                style: const TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                step.description,
                style: const TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
