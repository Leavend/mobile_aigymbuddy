import 'package:aigymbuddy/view/login/models/onboarding_draft.dart';
import 'package:aigymbuddy/view/login/widgets/auth_validators.dart';
import 'package:flutter/material.dart';

enum SignUpStatus {
  success,
  validationError,
  termsNotAccepted,
}

class SignUpResult {
  const SignUpResult(this.status, {this.draft});

  final SignUpStatus status;
  final OnboardingDraft? draft;

  bool get isSuccess => status == SignUpStatus.success;
}

class SignUpFormController extends ChangeNotifier {
  SignUpFormController() {
    firstNameController.addListener(_onFormChanged);
    lastNameController.addListener(_onFormChanged);
    emailController.addListener(_onFormChanged);
    passwordController.addListener(_onFormChanged);
  }

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool _autoValidate = false;
  bool _isPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isRegisterEnabled = false;
  bool _showTermsError = false;

  AutovalidateMode get autovalidateMode => _autoValidate
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isRegisterEnabled => _isRegisterEnabled;

  bool get showTermsError => _showTermsError && !_isTermsAccepted;

  bool get isTermsAccepted => _isTermsAccepted;

  @override
  void dispose() {
    firstNameController.removeListener(_onFormChanged);
    lastNameController.removeListener(_onFormChanged);
    emailController.removeListener(_onFormChanged);
    passwordController.removeListener(_onFormChanged);

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void updateTerms(bool value) {
    _isTermsAccepted = value;
    if (value) {
      _showTermsError = false;
    }
    _updateRegisterEnabled();
  }

  SignUpResult submit() {
    _enableAutovalidate();

    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return const SignUpResult(SignUpStatus.validationError);
    }

    if (!_isTermsAccepted) {
      _showTermsError = true;
      notifyListeners();
      return const SignUpResult(SignUpStatus.termsNotAccepted);
    }

    final draft = OnboardingDraft(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
    );

    return SignUpResult(SignUpStatus.success, draft: draft);
  }

  void _enableAutovalidate() {
    if (_autoValidate) return;
    _autoValidate = true;
    notifyListeners();
  }

  void _onFormChanged() {
    _updateRegisterEnabled();
  }

  void _updateRegisterEnabled() {
    final canSubmit = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        AuthValidators.isValidEmail(emailController.text) &&
        passwordController.text.length >= 8 &&
        _isTermsAccepted;
    final shouldShowTermsError = _showTermsError && !_isTermsAccepted;
    if (canSubmit == _isRegisterEnabled &&
        shouldShowTermsError == _showTermsError) {
      return;
    }

    _isRegisterEnabled = canSubmit;
    _showTermsError = shouldShowTermsError;
    notifyListeners();
  }
}
