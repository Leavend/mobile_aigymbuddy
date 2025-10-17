import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/view/login/models/onboarding_draft.dart';
import 'package:aigymbuddy/view/shared/models/user_profile.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompleteProfileController extends ChangeNotifier {
  CompleteProfileController({required OnboardingDraft draft})
      : _draft = draft,
        dobController = TextEditingController(),
        weightController = TextEditingController(),
        heightController = TextEditingController() {
    weightController.addListener(_syncMeasurements);
    heightController.addListener(_syncMeasurements);
    _applyDraft();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController dobController;
  final TextEditingController weightController;
  final TextEditingController heightController;

  OnboardingDraft _draft;
  UiGender? _selectedGender;
  bool _autoValidate = false;

  OnboardingDraft get draft => _draft;
  UiGender? get selectedGender => _selectedGender;

  AutovalidateMode get autovalidateMode =>
      _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

  bool get isFormComplete =>
      _selectedGender != null &&
      dobController.text.isNotEmpty &&
      weightController.text.isNotEmpty &&
      heightController.text.isNotEmpty;

  static const double minWeightKg = 20;
  static const double maxWeightKg = 500;
  static const double minHeightCm = 50;
  static const double maxHeightCm = 300;
  static const int minAgeYears = 13;

  static const decimalKeyboard = TextInputType.numberWithOptions(decimal: true);

  static final numericInputFormatters = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,3}(?:\.[0-9]{0,2})?$')),
    LengthLimitingTextInputFormatter(6),
  ];

  @override
  void dispose() {
    weightController.removeListener(_syncMeasurements);
    heightController.removeListener(_syncMeasurements);
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void enableAutovalidate() {
    if (_autoValidate) return;
    _autoValidate = true;
    notifyListeners();
  }

  void updateGender(UiGender? gender) {
    if (_selectedGender == gender) return;
    _selectedGender = gender;
    if (gender != null) {
      _draft = _draft.copyWith(gender: _mapUiGenderToDomain(gender));
    }
    notifyListeners();
  }

  void updateDob(DateTime dob) {
    dobController.text = formatDate(dob);
    _draft = _draft.updateWithDob(dob);
    notifyListeners();
  }

  void updateDraft(OnboardingDraft draft) {
    _draft = draft;
    _applyDraft();
    notifyListeners();
  }

  OnboardingDraft? buildNextDraft() {
    final formState = formKey.currentState;
    if (formState == null) {
      enableAutovalidate();
      return null;
    }

    enableAutovalidate();
    if (!formState.validate()) {
      return null;
    }

    final gender = _selectedGender;
    if (gender == null) {
      return null;
    }

    final parsedDob = DateTime.tryParse(dobController.text.trim());
    final height = double.tryParse(heightController.text.trim());
    final weight = double.tryParse(weightController.text.trim());

    if (parsedDob == null || height == null || weight == null) {
      return null;
    }

    final updatedDraft = _draft
        .copyWith(
          gender: _mapUiGenderToDomain(gender),
          heightCm: height,
          weightKg: weight,
        )
        .updateWithDob(parsedDob);

    _draft = updatedDraft;
    return updatedDraft;
  }

  String formatNumber(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }

  static String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void _applyDraft() {
    _selectedGender = _mapDomainGender(_draft.gender);
    final dob = _draft.dateOfBirth;
    dobController.text = dob != null ? formatDate(dob) : '';
    final weight = _draft.weightKg;
    weightController.text = weight != null ? formatNumber(weight) : '';
    final height = _draft.heightCm;
    heightController.text = height != null ? formatNumber(height) : '';
  }

  void _syncMeasurements() {
    final weight = double.tryParse(weightController.text.trim());
    final height = double.tryParse(heightController.text.trim());
    if (weight != null) {
      _draft = _draft.copyWith(weightKg: weight);
    }
    if (height != null) {
      _draft = _draft.copyWith(heightCm: height);
    }
  }
}

enum UiGender { male, female, other }

extension UiGenderLabel on UiGender {
  LocalizedText get label => switch (this) {
        UiGender.male =>
          const LocalizedText(english: 'Male', indonesian: 'Pria'),
        UiGender.female => const LocalizedText(
            english: 'Female',
            indonesian: 'Wanita',
          ),
        UiGender.other => const LocalizedText(
            english: 'Other',
            indonesian: 'Lainnya',
          ),
      };
}

UiGender? _mapDomainGender(domain.Gender? gender) {
  return switch (gender) {
    domain.Gender.male => UiGender.male,
    domain.Gender.female => UiGender.female,
    domain.Gender.other => UiGender.other,
    null => null,
  };
}

domain.Gender _mapUiGenderToDomain(UiGender gender) {
  return switch (gender) {
    UiGender.male => domain.Gender.male,
    UiGender.female => domain.Gender.female,
    UiGender.other => domain.Gender.other,
  };
}
