import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/models/instruction_step.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/step_detail_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

class ExercisesStepDetails extends StatelessWidget {
  const ExercisesStepDetails({required this.exercise, super.key});

  final Map<String, dynamic> exercise;

  static const _description = LocalizedText(
    english:
        'A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide. A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide.',
    indonesian:
        'Jumping jack, atau dikenal juga sebagai star jump, adalah gerakan melompat dengan kedua kaki terbuka lebar. Gerakan ini sering digunakan di militer Amerika sebagai pemanasan. Jumping jack membantu menggerakkan seluruh tubuh dan meningkatkan detak jantung.',
  );

  static const _descriptionsLabel = LocalizedText(
    english: 'Descriptions',
    indonesian: 'Deskripsi',
  );

  static const _readMoreLabel = LocalizedText(
    english: ' Read More ...',
    indonesian: ' Baca Selengkapnya ...',
  );

  static const _readLessLabel = LocalizedText(
    english: ' Read Less',
    indonesian: ' Sembunyikan',
  );

  static const _howToDoLabel = LocalizedText(
    english: 'How To Do It',
    indonesian: 'Cara Melakukannya',
  );

  static const _setsLabel = LocalizedText(
    english: '{count} Steps',
    indonesian: '{count} Langkah',
  );

  static const _customRepetitionsLabel = LocalizedText(
    english: 'Custom Repetitions',
    indonesian: 'Repetisi Khusus',
  );

  static const _saveLabel = LocalizedText(
    english: 'Save',
    indonesian: 'Simpan',
  );

  static const _saveSnack = LocalizedText(
    english: 'Exercise saved.',
    indonesian: 'Latihan disimpan.',
  );

  static const _videoPreviewSnack = LocalizedText(
    english: 'Video preview will be available soon.',
    indonesian: 'Pratinjau video akan tersedia segera.',
  );

  static const _actionsComingSoon = LocalizedText(
    english: 'Additional actions coming soon.',
    indonesian: 'Aksi tambahan segera hadir.',
  );

  static const _stepSummaryTitle = LocalizedText(
    english: 'Step Summary',
    indonesian: 'Ringkasan Langkah',
  );

  static const _untitledStep = LocalizedText(
    english: 'Untitled Step',
    indonesian: 'Langkah Tanpa Judul',
  );

  static const _steps = <_InstructionStepConfig>[
    _InstructionStepConfig(
      number: '01',
      title: LocalizedText(
        english: 'Spread Your Arms',
        indonesian: 'Rentangkan Lengan',
      ),
      description: LocalizedText(
        english:
            'To make the gestures feel more relaxed, stretch your arms as you start this movement. Do not bend your hands.',
        indonesian:
            'Untuk membuat gerakan terasa lebih rileks, rentangkan kedua lengan saat memulai gerakan. Jangan menekuk tangan.',
      ),
    ),
    _InstructionStepConfig(
      number: '02',
      title: LocalizedText(
        english: 'Rest at The Toe',
        indonesian: 'Bertumpu di Ujung Kaki',
      ),
      description: LocalizedText(
        english:
            'The basis of this movement is jumping. Focus on landing softly using the tips of your feet.',
        indonesian:
            'Dasar gerakan ini adalah melompat. Fokuskan pendaratan secara lembut menggunakan ujung kaki.',
      ),
    ),
    _InstructionStepConfig(
      number: '03',
      title: LocalizedText(
        english: 'Adjust Foot Movement',
        indonesian: 'Atur Gerakan Kaki',
      ),
      description: LocalizedText(
        english:
            'Jumping Jack is not just an ordinary jump. You also have to pay close attention to leg movements.',
        indonesian:
            'Jumping jack bukan sekadar melompat. Kamu juga perlu memperhatikan gerakan kaki.',
      ),
    ),
    _InstructionStepConfig(
      number: '04',
      title: LocalizedText(
        english: 'Clapping Both Hands',
        indonesian: 'Tepuk Kedua Tangan',
      ),
      description: LocalizedText(
        english:
            'Without realizing it, clapping your hands helps you keep your rhythm while doing the Jumping Jack.',
        indonesian:
            'Tanpa disadari, menepuk tangan membantu menjaga ritme saat melakukan jumping jack.',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final language = context.appLanguage;
    final exerciseTitle =
        exercise['title'] as String? ??
        (language == AppLanguage.english ? 'Exercise' : 'Latihan');
    final difficulty = (exercise['level'] ?? exercise['difficulty']) as String?;
    final rawCalories = exercise['calories'];
    final calories = rawCalories is num
        ? rawCalories.round().toString()
        : (rawCalories?.toString().replaceAll(RegExp('[^0-9]'), '') ?? '');
    final metadataParts = <String>[];
    if (difficulty != null && difficulty.isNotEmpty) {
      metadataParts.add(difficulty);
    }
    if (calories.isNotEmpty) {
      metadataParts.add(
        language == AppLanguage.english
            ? '$calories Calories Burn'
            : '$calories Kalori Terbakar',
      );
    }
    final metadataText = metadataParts.isEmpty
        ? (language == AppLanguage.english
              ? 'Easy | 390 Calories Burn'
              : 'Mudah | 390 Kalori Terbakar')
        : metadataParts.join(' | ');
    final steps = _buildSteps(language);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
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
              'assets/img/closed_btn.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              final message = _actionsComingSoon.resolve(language);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
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
                'assets/img/more_btn.png',
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoPreview(context, media, language),
            const SizedBox(height: 15),
            Text(
              exerciseTitle,
              style: const TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              metadataText,
              style: const TextStyle(color: TColor.gray, fontSize: 12),
            ),
            const SizedBox(height: 15),
            Text(
              _descriptionsLabel.resolve(language),
              style: const TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            ReadMoreText(
              _description.resolve(language),
              trimLines: 4,
              colorClickableText: TColor.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: _readMoreLabel.resolve(language),
              trimExpandedText: _readLessLabel.resolve(language),
              style: const TextStyle(color: TColor.gray, fontSize: 12),
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
                  _howToDoLabel.resolve(language),
                  style: const TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () => _showStepsSummary(context, steps),
                  child: Text(
                    _setsLabel
                        .resolve(language)
                        .replaceFirst('{count}', steps.length.toString()),
                    style: const TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                return StepDetailRow(
                  step: step,
                  isLast: index == steps.length - 1,
                );
              },
            ),
            Text(
              _customRepetitionsLabel.resolve(language),
              style: const TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _buildRepetitionPicker(language),
            RoundButton(
              title: _saveLabel.resolve(language),
              elevation: 0,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_saveSnack.resolve(language))),
                );
                context.pop();
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview(
    BuildContext context,
    Size media,
    AppLanguage language,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: media.width,
          height: media.width * 0.43,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: TColor.primaryG),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            'assets/img/video_temp.png',
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
              SnackBar(content: Text(_videoPreviewSnack.resolve(language))),
            );
          },
          icon: Image.asset('assets/img/Play.png', width: 30, height: 30),
        ),
      ],
    );
  }

  Widget _buildRepetitionPicker(AppLanguage language) {
    return SizedBox(
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
              ),
              bottom: BorderSide(
                color: TColor.gray.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
        onSelectedItemChanged: (_) {},
        childCount: 60,
        itemBuilder: (context, index) {
          final caloriesText = language == AppLanguage.english
              ? '${(index + 1) * 15} Calories Burn'
              : '${(index + 1) * 15} Kalori Terbakar';
          final timesText = language == AppLanguage.english
              ? ' times'
              : ' kali';
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/burn.png',
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
              Text(
                ' $caloriesText',
                style: const TextStyle(color: TColor.gray, fontSize: 10),
              ),
              Text(
                ' ${index + 1} ',
                style: const TextStyle(
                  color: TColor.gray,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                timesText,
                style: const TextStyle(color: TColor.gray, fontSize: 16),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStepsSummary(BuildContext context, List<InstructionStep> steps) {
    final language = context.appLanguage;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
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
                  _stepSummaryTitle.resolve(language),
                  style: const TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...steps.map(
                  (step) => ListTile(
                    title: Text(step.title ?? _untitledStep.resolve(language)),
                    subtitle: Text(step.description),
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: TColor.primaryColor2.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        step.number,
                        style: const TextStyle(
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

  List<InstructionStep> _buildSteps(AppLanguage language) {
    return _steps
        .map(
          (step) => InstructionStep(
            number: step.number,
            title: step.title?.resolve(language),
            description: step.description.resolve(language),
          ),
        )
        .toList(growable: false);
  }
}

class _InstructionStepConfig {
  const _InstructionStepConfig({
    required this.number,
    required this.description,
    this.title,
  });

  final String number;
  final LocalizedText description;
  final LocalizedText? title;
}
