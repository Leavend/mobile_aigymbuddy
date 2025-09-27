import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';
import '../common/models/instruction_step.dart';

class StepDetailRow extends StatelessWidget {
  const StepDetailRow({super.key, required this.step, this.isLast = false});

  final InstructionStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25,
          child: Text(
            step.number,
            style: TextStyle(color: TColor.secondaryColor1, fontSize: 14),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              DottedDashedLine(
                height: 80,
                width: 0,
                dashColor: TColor.secondaryColor1,
                axis: Axis.vertical,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title ?? 'Step ${step.number}',
                style: TextStyle(color: TColor.black, fontSize: 14),
              ),
              Text(
                step.description,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
