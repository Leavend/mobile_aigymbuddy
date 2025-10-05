// lib/view/login/complete_profile_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  _Gender? _selectedGender;

  static const _title = LocalizedText(
    english: 'Let’s complete your profile',
    indonesian: 'Lengkapi profil Anda',
  );
  static const _subtitle = LocalizedText(
    english: 'It will help us to know more about you!',
    indonesian: 'Ini membantu kami mengenal Anda lebih baik!',
  );
  static const _genderHint = LocalizedText(
    english: 'Choose Gender',
    indonesian: 'Pilih Jenis Kelamin',
  );
  static const _dobHint = LocalizedText(
    english: 'Date of Birth',
    indonesian: 'Tanggal Lahir',
  );
  static const _weightHint = LocalizedText(
    english: 'Your Weight',
    indonesian: 'Berat Badan',
  );
  static const _heightHint = LocalizedText(
    english: 'Your Height',
    indonesian: 'Tinggi Badan',
  );
  static const _nextText = LocalizedText(
    english: 'Next >',
    indonesian: 'Berikutnya >',
  );
  static const _dobHelpText = LocalizedText(
    english: 'Select Date of Birth',
    indonesian: 'Pilih Tanggal Lahir',
  );

  @override
  void dispose() {
    dobCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 90),
      lastDate: now,
      helpText: context.localize(_dobHelpText),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primaryColor1,
              onPrimary: TColor.white,
              onSurface: TColor.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobCtrl.text =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/img/complete_profile.png',
                    width: media.width * 0.7,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.localize(_title),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.localize(_subtitle),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/img/gender.png',
                          width: 20,
                          height: 20,
                          color: TColor.gray,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<_Gender>(
                              isExpanded: true,
                              value: _selectedGender,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: TColor.gray,
                              ),
                              items: _Gender.values
                                  .map(
                                    (gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(
                                        context.localize(gender.label),
                                        style: TextStyle(
                                          color: TColor.gray,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              hint: Text(
                                context.localize(_genderHint),
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 12,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickDob,
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      child: RoundTextField(
                        controller: dobCtrl,
                        hitText: context.localize(_dobHint),
                        icon: 'assets/img/date.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RoundTextField(
                          controller: weightCtrl,
                          hitText: context.localize(_weightHint),
                          icon: 'assets/img/weight.png',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _UnitTag(text: 'KG'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RoundTextField(
                          controller: heightCtrl,
                          hitText: context.localize(_heightHint),
                          icon: 'assets/img/hight.png',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _UnitTag(text: 'CM'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  RoundButton(
                    title: context.localize(_nextText),
                    onPressed: () {
                      context.push(AppRoute.goal);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitTag extends StatelessWidget {
  const _UnitTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.secondaryG),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(text, style: TextStyle(color: TColor.white, fontSize: 12)),
    );
  }
}

enum _Gender { male, female }

extension on _Gender {
  LocalizedText get label => switch (this) {
    _Gender.male => const LocalizedText(english: 'Male', indonesian: 'Pria'),
    _Gender.female => const LocalizedText(
      english: 'Female',
      indonesian: 'Wanita',
    ),
  };
}
