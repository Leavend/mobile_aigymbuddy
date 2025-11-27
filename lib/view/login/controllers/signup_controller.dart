import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/view/login/widgets/auth_validators.dart';
import 'package:flutter/material.dart';

class SignupController extends ChangeNotifier {
  SignupController() {
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isTermsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isRegisterEnabled = false;
  bool _autoValidate = false;
  bool _showTermsError = false;

  bool get isTermsAccepted => _isTermsAccepted;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isRegisterEnabled => _isRegisterEnabled;
  bool get autoValidate => _autoValidate;
  bool get showTermsError => _showTermsError;

  void toggleTermsAccepted(bool? value) {
    _isTermsAccepted = value ?? false;
    if (_isTermsAccepted) _showTermsError = false;
    notifyListeners();
    _validateForm();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void _validateForm() {
    final isValid =
        firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        AuthValidators.isValidEmail(emailController.text) &&
        passwordController.text.length >= 8 &&
        _isTermsAccepted;

    if (isValid != _isRegisterEnabled) {
      _isRegisterEnabled = isValid;
      notifyListeners();
    }
  }

  SignUpData? submit() {
    _autoValidate = true;
    _showTermsError = !_isTermsAccepted;
    notifyListeners();

    if (_isRegisterEnabled) {
      return SignUpData(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text,
      );
    }
    return null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
