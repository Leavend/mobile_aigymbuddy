import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/view/login/widgets/auth_validators.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  LoginController(this._authController) {
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  final AuthController _authController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isObscurePassword = true;
  bool _isLoginEnabled = false;
  bool _autoValidate = false;

  bool get isObscurePassword => _isObscurePassword;
  bool get isLoginEnabled => _isLoginEnabled;
  bool get autoValidate => _autoValidate;
  bool get isLoading => _authController.isLoading;

  void togglePasswordVisibility() {
    _isObscurePassword = !_isObscurePassword;
    notifyListeners();
  }

  void _validateForm() {
    final isValid =
        AuthValidators.isValidEmail(emailController.text) &&
        passwordController.text.length >= 8;
    if (isValid != _isLoginEnabled) {
      _isLoginEnabled = isValid;
      notifyListeners();
    }
  }

  Future<void> login() async {
    _autoValidate = true;
    notifyListeners();

    if (!_isLoginEnabled) return;

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;

    await _authController.login(email: email, password: password);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
