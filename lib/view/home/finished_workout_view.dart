import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinishedWorkoutView extends StatelessWidget {
  const FinishedWorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final localize = context.localize;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/img/complete_workout.png',
                height: media.width * 0.8,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(height: 20),
              Text(
                localize(_FinishedWorkoutStrings.congratulations),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localize(_FinishedWorkoutStrings.quote),
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                localize(_FinishedWorkoutStrings.quoteAuthor),
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
              const Spacer(),
              RoundButton(
                title: localize(_FinishedWorkoutStrings.backToHome),
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinishedWorkoutStrings {
  static const congratulations = LocalizedText(
    english: 'Congratulations, You Have Finished Your Workout',
    indonesian: 'Selamat, Kamu Telah Menyelesaikan Latihanmu',
  );

  static const quote = LocalizedText(
    english:
        'Exercise is king and nutrition is queen. Combine the two and you will have a kingdom',
    indonesian:
        'Olahraga adalah raja dan nutrisi adalah ratu. Gabungkan keduanya dan kamu akan memiliki kerajaan',
  );

  static const quoteAuthor = LocalizedText(
    english: '-Jack Lalanne',
    indonesian: '-Jack Lalanne',
  );

  static const backToHome = LocalizedText(
    english: 'Back To Home',
    indonesian: 'Kembali ke Beranda',
  );
}
