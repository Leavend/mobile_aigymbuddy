import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/complete_profile_controller.dart';
import 'models/onboarding_draft.dart';
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
}

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({
    super.key,
    ProfileFormArguments? args,
  }) : args = args ?? const ProfileFormArguments(draft: OnboardingDraft());

  final ProfileFormArguments args;

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  late final CompleteProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CompleteProfileController(draft: widget.args.draft);
  }

  @override
  void didUpdateWidget(covariant CompleteProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.args.draft != widget.args.draft) {
      _controller.updateDraft(widget.args.draft);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return AuthPageLayout(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = constraints.maxWidth * 0.65;
                return Form(
                  key: _controller.formKey,
                  autovalidateMode: _controller.autovalidateMode,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Image.asset(
                          'assets/img/complete_profile.png',
                          width: imageWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _Header(
                        title: context.localize(_CompleteProfileTexts.title),
                        subtitle: context.localize(_CompleteProfileTexts.subtitle),
                      ),
                      const SizedBox(height: 24),
                      _buildGenderField(),
                      const SizedBox(height: 16),
                      _buildDobField(),
                      const SizedBox(height: 16),
                      _buildMeasurementField(
                        controller: _controller.weightController,
                        hint: _CompleteProfileTexts.weightHint,
                        iconAsset: 'assets/img/weight.png',
                        unit: 'KG',
                        validator: (value) => _validateMeasurement(
                          value: value,
                          min: CompleteProfileController.minWeightKg,
                          max: CompleteProfileController.maxWeightKg,
                          outOfRangeError: _CompleteProfileTexts.weightOutOfRange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMeasurementField(
                        controller: _controller.heightController,
                        hint: _CompleteProfileTexts.heightHint,
                        iconAsset: 'assets/img/hight.png',
                        unit: 'CM',
                        validator: (value) => _validateMeasurement(
                          value: value,
                          min: CompleteProfileController.minHeightCm,
                          max: CompleteProfileController.maxHeightCm,
                          outOfRangeError: _CompleteProfileTexts.heightOutOfRange,
                        ),
                      ),
                      const SizedBox(height: 28),
                      RoundButton(
                        title: context.localize(_CompleteProfileTexts.nextButton),
                        onPressed: _onNextPressed,
                        isEnabled: _controller.isFormComplete,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderField() {
    return FormField<UiGender>(
      autovalidateMode: _controller.autovalidateMode,
      initialValue: _controller.selectedGender,
      validator: (value) => value == null
          ? context.localize(_CompleteProfileTexts.genderRequired)
          : null,
      builder: (state) {
        if (state.value != _controller.selectedGender) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(_controller.selectedGender);
            }
          });
        }
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
                      child: DropdownButton<UiGender>(
                        isExpanded: true,
                        value: _controller.selectedGender,
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
                        items: UiGender.values
                            .map(
                              (gender) => DropdownMenuItem<UiGender>(
                                value: gender,
                                child: Text(
                                  context.localize(gender.label),
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
                          _controller.updateGender(value);
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

  Widget _buildDobField() {
    return FormField<String>(
      autovalidateMode: _controller.autovalidateMode,
      initialValue: _controller.dobController.text,
      validator: _validateDob,
      builder: (state) {
        final controllerValue = _controller.dobController.text;
        if (state.value != controllerValue) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(controllerValue);
            }
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickDob(state),
              behavior: HitTestBehavior.opaque,
              child: AbsorbPointer(
                child: RoundTextField(
                  controller: _controller.dobController,
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
  }) {
    return FormField<String>(
      autovalidateMode: _controller.autovalidateMode,
      initialValue: controller.text,
      validator: validator,
      builder: (state) {
        if (state.value != controller.text) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(controller.text);
            }
          });
        }
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
                    keyboardType: CompleteProfileController.decimalKeyboard,
                    inputFormatters:
                        CompleteProfileController.numericInputFormatters,
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
      final formatted = CompleteProfileController.formatDate(picked);
      state.didChange(formatted);
      _controller.updateDob(picked);
    }
  }

  Future<void> _onNextPressed() async {
    FocusScope.of(context).unfocus();
    _controller.enableAutovalidate();
    final draft = _controller.buildNextDraft();
    if (draft == null) {
      return;
    }

    final args = widget.args.copyWith(draft: draft);
    if (!mounted) return;
    context.push(AppRoute.goal, extra: args);
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

    final ageThreshold = DateTime(
      now.year - CompleteProfileController.minAgeYears,
      now.month,
      now.day,
    );
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
