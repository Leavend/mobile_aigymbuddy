import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

import '../../common/color_extension.dart';
import '../../common/models/instruction_step.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/step_detail_row.dart';

class ExercisesStepDetails extends StatelessWidget {
  const ExercisesStepDetails({super.key, required this.exercise});

  final Map<String, dynamic> exercise;

  static const _description =
      'A jumping jack, also known as a star jump and called a side-straddle hop in the US military, '
      'is a physical jumping exercise performed by jumping to a position with the legs spread wide. '
      'A jumping jack, also known as a star jump and called a side-straddle hop in the US military, '
      'is a physical jumping exercise performed by jumping to a position with the legs spread wide.';

  static const List<InstructionStep> _steps = [
    InstructionStep(
      number: '01',
      title: 'Spread Your Arms',
      description:
          'To make the gestures feel more relaxed, stretch your arms as you start this movement. Do not bend your hands.',
    ),
    InstructionStep(
      number: '02',
      title: 'Rest at The Toe',
      description:
          'The basis of this movement is jumping. Focus on landing softly using the tips of your feet.',
    ),
    InstructionStep(
      number: '03',
      title: 'Adjust Foot Movement',
      description:
          'Jumping Jack is not just an ordinary jump. You also have to pay close attention to leg movements.',
    ),
    InstructionStep(
      number: '04',
      title: 'Clapping Both Hands',
      description:
          'Without realizing it, clapping your hands helps you keep your rhythm while doing the Jumping Jack.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final exerciseTitle = exercise['title'] as String? ?? 'Exercise';
    final difficulty = (exercise['level'] ?? exercise['difficulty']) as String?;
    final rawCalories = exercise['calories'];
    final calories = rawCalories is num
        ? rawCalories.round().toString()
        : (rawCalories?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '');
    final metadataParts = <String>[];
    if (difficulty != null && difficulty.isNotEmpty) {
      metadataParts.add(difficulty);
    }
    if (calories.isNotEmpty) {
      metadataParts.add('$calories Calories Burn');
    }
    final metadataText = metadataParts.isEmpty
        ? 'Easy | 390 Calories Burn'
        : metadataParts.join(' | ');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/img/video_temp.png",
                      width: media.width,
                      height: media.width * 0.43,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                      color: TColor.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Video preview will be available soon.',
                          ),
                        ),
                      );
                    },
                    icon: Image.asset(
                      "assets/img/Play.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                exerciseTitle,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metadataText,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
              const SizedBox(height: 15),
              Text(
                "Descriptions",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              ReadMoreText(
                _description,
                trimLines: 4,
                colorClickableText: TColor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More ...',
                trimExpandedText: ' Read Less',
                style: TextStyle(color: TColor.gray, fontSize: 12),
                moreStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How To Do It",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showStepsSummary(context),
                    child: Text(
                      "${_steps.length} Sets",
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return StepDetailRow(
                    step: step,
                    isLast: index == _steps.length - 1,
                  );
                },
              ),
              Text(
                "Custom Repetitions",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker.builder(
                  itemExtent: 40,
                  selectionOverlay: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: TColor.gray.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: TColor.gray.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {},
                  childCount: 60,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/burn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          " ${(index + 1) * 15} Calories Burn",
                          style: TextStyle(color: TColor.gray, fontSize: 10),
                        ),
                        Text(
                          " ${index + 1} ",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " times",
                          style: TextStyle(color: TColor.gray, fontSize: 16),
                        ),
                      ],
                    );
                  },
                ),
              ),
              RoundButton(
                title: "Save",
                elevation: 0,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exercise saved.')),
                  );
                  context.pop();
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

void _showStepsSummary(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TColor.gray.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Step Summary',
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...ExercisesStepDetails._steps.map(
                (step) => ListTile(
                  title: Text(step.title ?? 'Untitled Step'),
                  subtitle: Text(step.description),
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: TColor.primaryColor2.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      step.number,
                      style: TextStyle(
                        color: TColor.primaryColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
