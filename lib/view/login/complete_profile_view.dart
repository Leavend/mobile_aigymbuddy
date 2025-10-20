import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/di/app_scope.dart';
import 'package:aigymbuddy/common/domain/enums.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/features/auth/application/models/sign_up_flow_state.dart';
import 'package:aigymbuddy/features/auth/domain/errors/auth_failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'widgets/auth_page_layout.dart';

abstract final class _CompleteProfileTexts {
  static const title = LocalizedText(
    english: 'Let’s complete your profile',
    indonesian: 'Lengkapi profil Anda',
  );
  static const subtitle = LocalizedText(
    english: 'It will help us to know more about you!',
    indonesian: 'Ini membantu kami mengenal Anda lebih baik!',
  );
  static const genderHint = LocalizedText(
    english: 'Choose Gender',
    indonesian: 'Pilih Jenis Kelamin',
  );
  static const dobHint = LocalizedText(
    english: 'Date of Birth',
    indonesian: 'Tanggal Lahir',
  );
  static const dobHelpText = LocalizedText(
    english: 'Select Date of Birth',
    indonesian: 'Pilih Tanggal Lahir',
  );
  static const weightHint = LocalizedText(
    english: 'Your Weight',
    indonesian: 'Berat Badan',
  );
  static const heightHint = LocalizedText(
    english: 'Your Height',
    indonesian: 'Tinggi Badan',
  );
  static const nextButton = LocalizedText(
    english: 'Next >',
    indonesian: 'Berikutnya >',
  );
  static const genderRequired = LocalizedText(
    english: 'Please select your gender.',
    indonesian: 'Silakan pilih jenis kelamin Anda.',
  );
  static const dobRequired = LocalizedText(
    english: 'Please select your date of birth.',
    indonesian: 'Silakan pilih tanggal lahir Anda.',
  );
  static const dobInvalid = LocalizedText(
    english: 'Please choose a valid date of birth.',
    indonesian: 'Silakan pilih tanggal lahir yang valid.',
  );
  static const dobAgeRestriction = LocalizedText(
    english: 'You must be at least 13 years old.',
    indonesian: 'Anda harus berusia minimal 13 tahun.',
  );
  static const measurementRequired = LocalizedText(
    english: 'This field is required.',
    indonesian: 'Kolom ini wajib diisi.',
  );
  static const measurementInvalid = LocalizedText(
    english: 'Enter a valid number.',
    indonesian: 'Masukkan angka yang valid.',
  );
  static const weightOutOfRange = LocalizedText(
    english: 'Weight must be between 20 and 500 KG.',
    indonesian: 'Berat badan harus antara 20 dan 500 KG.',
  );
  static const heightOutOfRange = LocalizedText(
    english: 'Height must be between 50 and 300 CM.',
    indonesian: 'Tinggi badan harus antara 50 dan 300 CM.',
  );
  static const submitError = LocalizedText(
    english: 'We could not save your profile. Please try again.',
    indonesian: 'Profil Anda belum tersimpan. Silakan coba lagi.',
  );
}

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key, required this.flow});

  final SignUpFlowState flow;

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Gender? _selectedGender;
  bool _autoValidate = false;
  bool _isSubmitting = false;

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

  @override
  void initState() {
    super.initState();
    _dobController.addListener(_onFormDataChanged);
    _weightController.addListener(_onFormDataChanged);
    _heightController.addListener(_onFormDataChanged);
  }

  @override
  void dispose() {
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onFormDataChanged() {
    setState(() {});
  }

  Future<void> _onNextPressed() async {
    FocusScope.of(context).unfocus();
    setState(() => _autoValidate = true);

    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedGender == null) {
      return;
    }

    final dobText = _dobController.text.trim();
    final dob = dobText.isEmpty ? null : DateTime.tryParse(dobText);
    final weight = double.parse(_weightController.text.trim());
    final height = double.parse(_heightController.text.trim());

    setState(() => _isSubmitting = true);

    try {
      await context.authController.saveProfile(
        flow: widget.flow,
        gender: _selectedGender!,
        dob: dob,
        heightCm: height,
        weightKg: weight,
      );
      if (!mounted) return;
      context.push(AppRoute.goal, extra: widget.flow);
    } on AuthFailure {
      _showError(context.localize(_CompleteProfileTexts.submitError));
    } catch (_) {
      _showError(context.localize(_CompleteProfileTexts.submitError));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDob(FormFieldState<String> state) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 90),
      lastDate: now,
      helpText: context.localize(_CompleteProfileTexts.dobHelpText),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
      _dobController.text = formatted;
      state.didChange(formatted);
    }
  }

  String? _validateDob(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return context.localize(_CompleteProfileTexts.dobRequired);
    }

    final parsed = DateTime.tryParse(text);
    if (parsed == null) {
      return context.localize(_CompleteProfileTexts.dobInvalid);
    }

    final now = DateTime.now();
    if (parsed.isAfter(now)) {
      return context.localize(_CompleteProfileTexts.dobInvalid);
    }

    final ageThreshold = DateTime(now.year - _minAgeYears, now.month, now.day);
    if (parsed.isAfter(ageThreshold)) {
      return context.localize(_CompleteProfileTexts.dobAgeRestriction);
    }

    return null;
  }

  String? _validateMeasurement({
    required String? value,
    required double min,
    required double max,
    required LocalizedText outOfRangeError,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return context.localize(_CompleteProfileTexts.measurementRequired);
    }

    final parsed = double.tryParse(text);
    if (parsed == null) {
      return context.localize(_CompleteProfileTexts.measurementInvalid);
    }

    if (parsed < min || parsed > max) {
      return context.localize(outOfRangeError);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final autovalidateMode = _autoValidate
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return AuthPageLayout(
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
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
            _Header(
              title: context.localize(_CompleteProfileTexts.title),
              subtitle: context.localize(_CompleteProfileTexts.subtitle),
            ),
            const SizedBox(height: 24),
            _buildGenderField(autovalidateMode),
            const SizedBox(height: 16),
            _buildDobField(autovalidateMode),
            const SizedBox(height: 16),
            _buildMeasurementField(
              controller: _weightController,
              hint: _CompleteProfileTexts.weightHint,
              iconAsset: 'assets/img/weight.png',
              unit: 'KG',
              autovalidateMode: autovalidateMode,
              validator: (value) => _validateMeasurement(
                value: value,
                min: _minWeightKg,
                max: _maxWeightKg,
                outOfRangeError: _CompleteProfileTexts.weightOutOfRange,
              ),
            ),
            const SizedBox(height: 16),
            _buildMeasurementField(
              controller: _heightController,
              hint: _CompleteProfileTexts.heightHint,
              iconAsset: 'assets/img/hight.png',
              unit: 'CM',
              autovalidateMode: autovalidateMode,
              validator: (value) => _validateMeasurement(
                value: value,
                min: _minHeightCm,
                max: _maxHeightCm,
                outOfRangeError: _CompleteProfileTexts.heightOutOfRange,
              ),
            ),
            const SizedBox(height: 28),
            RoundButton(
              title: context.localize(_CompleteProfileTexts.nextButton),
              onPressed: _onNextPressed,
              isEnabled: _isFormComplete,
            ),
            if (_isSubmitting) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  bool get _isFormComplete {
    return _selectedGender != null &&
        _dobController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        !_isSubmitting;
  }

  Widget _buildGenderField(AutovalidateMode autovalidateMode) {
    return FormField<Gender>(
      autovalidateMode: autovalidateMode,
      initialValue: _selectedGender,
      validator: (value) => value == null
          ? context.localize(_CompleteProfileTexts.genderRequired)
          : null,
      builder: (state) {
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
                      child: DropdownButton<Gender>(
                        isExpanded: true,
                        value: state.value,
                        hint: Text(
                          context.localize(_CompleteProfileTexts.genderHint),
                          style: const TextStyle(
                            color: TColor.gray,
                            fontSize: 12,
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: TColor.gray,
                        ),
                        items: Gender.values
                            .map(
                              (gender) => DropdownMenuItem<Gender>(
                                value: gender,
                                child: Text(
                                  context.localize(gender.localizedLabel),
                                  style: const TextStyle(
                                    color: TColor.gray,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          state.didChange(value);
                          setState(() => _selectedGender = value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              _ErrorText(text: state.errorText!),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDobField(AutovalidateMode autovalidateMode) {
    return FormField<String>(
      autovalidateMode: autovalidateMode,
      initialValue: _dobController.text,
      validator: _validateDob,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickDob(state),
              behavior: HitTestBehavior.opaque,
              child: AbsorbPointer(
                child: RoundTextField(
                  controller: _dobController,
                  hintText: context.localize(_CompleteProfileTexts.dobHint),
                  icon: 'assets/img/date.png',
                ),
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              _ErrorText(text: state.errorText!),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMeasurementField({
    required TextEditingController controller,
    required LocalizedText hint,
    required String iconAsset,
    required String unit,
    required FormFieldValidator<String> validator,
    required AutovalidateMode autovalidateMode,
  }) {
    return FormField<String>(
      autovalidateMode: autovalidateMode,
      initialValue: controller.text,
      validator: validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RoundTextField(
                    controller: controller,
                    hintText: context.localize(hint),
                    icon: iconAsset,
                    keyboardType: _decimalKeyboard,
                    inputFormatters: _numericInputFormatters,
                    onChanged: state.didChange,
                  ),
                ),
                const SizedBox(width: 8),
                _UnitTag(text: unit),
              ],
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              _ErrorText(text: state.errorText!),
            ],
          ],
        );
      },
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
      child: Text(
        text,
        style: const TextStyle(color: TColor.white, fontSize: 12),
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
          style: const TextStyle(
            color: TColor.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: TColor.gray, fontSize: 12),
        ),
      ],
    );
  }
}

extension GenderLocalization on Gender {
  LocalizedText get localizedLabel => switch (this) {
        Gender.male =>
          const LocalizedText(english: 'Male', indonesian: 'Pria'),
        Gender.female =>
          const LocalizedText(english: 'Female', indonesian: 'Wanita'),
        Gender.other =>
          const LocalizedText(english: 'Other', indonesian: 'Lainnya'),
      };
}
