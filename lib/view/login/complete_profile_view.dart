import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _genderError;
  String? _dobError;
  String? _weightError;
  String? _heightError;
  static const _decimalKeyboard = TextInputType.numberWithOptions(
    decimal: true,
  );
  static const double _minWeightKg = 20;
  static const double _maxWeightKg = 500;
  static const double _minHeightCm = 50;
  static const double _maxHeightCm = 300;
  static const int _minAgeYears = 13;
  static final List<TextInputFormatter> _numericInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,3}(?:\.[0-9]{0,2})?$')),
    LengthLimitingTextInputFormatter(6),
  ];
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
  static const _genderRequiredError = LocalizedText(
    english: 'Please select your gender.',
    indonesian: 'Silakan pilih jenis kelamin Anda.',
  );
  static const _dobRequiredError = LocalizedText(
    english: 'Please select your date of birth.',
    indonesian: 'Silakan pilih tanggal lahir Anda.',
  );
  static const _dobInvalidError = LocalizedText(
    english: 'Please choose a valid date of birth.',
    indonesian: 'Silakan pilih tanggal lahir yang valid.',
  );
  static const _dobAgeRestrictionError = LocalizedText(
    english: 'You must be at least 13 years old.',
    indonesian: 'Anda harus berusia minimal 13 tahun.',
  );
  static const _measurementRequiredError = LocalizedText(
    english: 'This field is required.',
    indonesian: 'Kolom ini wajib diisi.',
  );
  static const _measurementInvalidError = LocalizedText(
    english: 'Enter a valid number.',
    indonesian: 'Masukkan angka yang valid.',
  );
  static const _weightOutOfRangeError = LocalizedText(
    english: 'Weight must be between 20 and 500 KG.',
    indonesian: 'Berat badan harus antara 20 dan 500 KG.',
  );
  static const _heightOutOfRangeError = LocalizedText(
    english: 'Height must be between 50 and 300 CM.',
    indonesian: 'Tinggi badan harus antara 50 dan 300 CM.',
  );

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_handleWeightChanged);
    _heightController.addListener(_handleHeightChanged);
  }

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
      setState(() {
        _dobController.text =
            '${picked.year.toString().padLeft(4, '0')}-'
            '${picked.month.toString().padLeft(2, '0')}-'
            '${picked.day.toString().padLeft(2, '0')}';
        _dobError = null;
      });
    }
  }

  void _onGenderChanged(_Gender? gender) {
    setState(() {
      _selectedGender = gender;
      _genderError = null;
    });
  }

  void _handleWeightChanged() {
    if (_weightError != null) {
      setState(() {
        _weightError = _validateWeight(context, _weightController.text);
      });
    }
  }

  void _handleHeightChanged() {
    if (_heightError != null) {
      setState(() {
        _heightError = _validateHeight(context, _heightController.text);
      });
    }
  }

  void _onNextPressed() {
    final genderError = _selectedGender == null
        ? context.localize(_genderRequiredError)
        : null;
    final dobError = _validateDob(context, _dobController.text);
    final weightError = _validateWeight(context, _weightController.text);
    final heightError = _validateHeight(context, _heightController.text);
    setState(() {
      _genderError = genderError;
      _dobError = dobError;
      _weightError = weightError;
      _heightError = heightError;
    });
    if ([
      genderError,
      dobError,
      weightError,
      heightError,
    ].every((e) => e == null)) {
      context.push(AppRoute.goal);
    }
  }

  String? _validateDob(BuildContext context, String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return context.localize(_dobRequiredError);
    }
    final parsed = DateTime.tryParse(text);
    if (parsed == null) {
      return context.localize(_dobInvalidError);
    }
    final now = DateTime.now();
    if (parsed.isAfter(now)) {
      return context.localize(_dobInvalidError);
    }
    final ageThreshold = DateTime(now.year - _minAgeYears, now.month, now.day);
    if (parsed.isAfter(ageThreshold)) {
      return context.localize(_dobAgeRestrictionError);
    }
    return null;
  }

  String? _validateWeight(BuildContext context, String raw) {
    return _validateMeasurement(
      context: context,
      raw: raw,
      min: _minWeightKg,
      max: _maxWeightKg,
      outOfRangeError: _weightOutOfRangeError,
    );
  }

  String? _validateHeight(BuildContext context, String raw) {
    return _validateMeasurement(
      context: context,
      raw: raw,
      min: _minHeightCm,
      max: _maxHeightCm,
      outOfRangeError: _heightOutOfRangeError,
    );
  }

  String? _validateMeasurement({
    required BuildContext context,
    required String raw,
    required double min,
    required double max,
    required LocalizedText outOfRangeError,
  }) {
    final text = raw.trim();
    if (text.isEmpty) {
      return context.localize(_measurementRequiredError);
    }
    final value = double.tryParse(text);
    if (value == null) {
      return context.localize(_measurementInvalidError);
    }
    if (value < min || value > max) {
      return context.localize(outOfRangeError);
    }
    return null;
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      _buildDobField(context),
                      const SizedBox(height: 16),
                      _buildMeasurementField(
                        context,
                        controller: _weightController,
                        hint: _weightHint,
                        iconAsset: 'assets/img/weight.png',
                        unit: 'KG',
                        errorText: _weightError,
                      ),
                      const SizedBox(height: 16),
                      _buildMeasurementField(
                        context,
                        controller: _heightController,
                        hint: _heightHint,
                        iconAsset: 'assets/img/hight.png',
                        unit: 'CM',
                        errorText: _heightError,
                      ),
                      const SizedBox(height: 28),
                      RoundButton(
                        title: localize(_nextText),
                        onPressed: _onNextPressed,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    hint: Text(
                      context.localize(_genderHint),
                      style: TextStyle(color: TColor.gray, fontSize: 12),
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
        ),
        if (_genderError != null) ...[
          const SizedBox(height: 6),
          _ErrorText(text: _genderError!),
        ],
      ],
    );
  }

  Widget _buildDobField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (_dobError != null) ...[
          const SizedBox(height: 6),
          _ErrorText(text: _dobError!),
        ],
      ],
    );
  }

  Widget _buildMeasurementField(
    BuildContext context, {
    required TextEditingController controller,
    required LocalizedText hint,
    required String iconAsset,
    required String unit,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RoundTextField(
                controller: controller,
                hitText: context.localize(hint),
                icon: iconAsset,
                keyboardType: _decimalKeyboard,
                inputFormatters: _numericInputFormatters,
              ),
            ),
            const SizedBox(width: 8),
            _UnitTag(text: unit),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          _ErrorText(text: errorText),
        ],
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
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
    _Gender.male => const LocalizedText(english: 'Male', indonesian: 'Pria'),
    _Gender.female => const LocalizedText(
      english: 'Female',
      indonesian: 'Wanita',
    ),
  };
}
