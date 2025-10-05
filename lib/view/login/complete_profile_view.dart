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
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  _Gender? _selectedGender;
  static const _decimalKeyboard =
      TextInputType.numberWithOptions(decimal: true);

  static const _title = LocalizedText(
    english: "Let’s complete your profile",
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
  static const _dobHelpText = LocalizedText(
    english: 'Select Date of Birth',
    indonesian: 'Pilih Tanggal Lahir',
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

  @override
  void dispose() {
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
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
      _dobController.text =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }

  void _onGenderChanged(_Gender? gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final localize = context.localize;
    final title = localize(_title);
    final subtitle = localize(_subtitle);

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 420,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/img/complete_profile.png',
                        width: media.width * 0.65,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      _Header(title: title, subtitle: subtitle),
                      const SizedBox(height: 24),
                      _buildGenderField(context),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickDob,
                        behavior: HitTestBehavior.opaque,
                        child: AbsorbPointer(
                          child: RoundTextField(
                            controller: _dobController,
                            hitText: context.localize(_dobHint),
                            icon: 'assets/img/date.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMeasurementField(
                        context,
                        controller: _weightController,
                        hint: _weightHint,
                        iconAsset: 'assets/img/weight.png',
                        unit: 'KG',
                      ),
                      const SizedBox(height: 16),
                      _buildMeasurementField(
                        context,
                        controller: _heightController,
                        hint: _heightHint,
                        iconAsset: 'assets/img/hight.png',
                        unit: 'CM',
                      ),
                      const SizedBox(height: 28),
                      RoundButton(
                        title: localize(_nextText),
                        onPressed: () {
                          context.push(AppRoute.goal);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Container(
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
                hint: Text(
                  context.localize(_genderHint),
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 12,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: TColor.gray,
                ),
                items: _Gender.values
                    .map(
                      (gender) => DropdownMenuItem<_Gender>(
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
                onChanged: _onGenderChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementField(
    BuildContext context, {
    required TextEditingController controller,
    required LocalizedText hint,
    required String iconAsset,
    required String unit,
  }) {
    return Row(
      children: [
        Expanded(
          child: RoundTextField(
            controller: controller,
            hitText: context.localize(hint),
            icon: iconAsset,
            keyboardType: _decimalKeyboard,
          ),
        ),
        const SizedBox(width: 8),
        _UnitTag(text: unit),
      ],
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
      child: Text(
        text,
        style: TextStyle(color: TColor.white, fontSize: 12),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: TColor.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      ],
    );
  }
}

enum _Gender { male, female }

extension on _Gender {
  LocalizedText get label => switch (this) {
        _Gender.male => const LocalizedText(
            english: 'Male', indonesian: 'Pria'),
        _Gender.female => const LocalizedText(
            english: 'Female', indonesian: 'Wanita'),
      };
}
