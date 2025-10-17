import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/view/login/widgets/auth_validators.dart';
import 'package:aigymbuddy/view/shared/repositories/profile_repository.dart';
import 'package:flutter/material.dart';

enum LoginStatus {
  success,
  validationError,
  missingProfile,
  failure,
  inProgress,
}

class LoginResult {
  const LoginResult(this.status, {this.error});

  const LoginResult.success() : this(LoginStatus.success);
  const LoginResult.validationError() : this(LoginStatus.validationError);
  const LoginResult.missingProfile() : this(LoginStatus.missingProfile);
  const LoginResult.inProgress() : this(LoginStatus.inProgress);

  final LoginStatus status;
  final Object? error;
}

class LoginFormController extends ChangeNotifier {
  LoginFormController({
    required ProfileRepository profileRepository,
    required AuthService authService,
  })  : _profileRepository = profileRepository,
        _authService = authService {
    emailController.addListener(_onFormChanged);
    passwordController.addListener(_onFormChanged);
  }

  final ProfileRepository _profileRepository;
  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool _autoValidate = false;
  bool _isPasswordVisible = false;
  bool _isSubmitting = false;
  bool _canSubmit = false;

  AutovalidateMode get autovalidateMode =>
      _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isSubmitting => _isSubmitting;

  bool get isLoginEnabled => _canSubmit && !_isSubmitting;

  @override
  void dispose() {
    emailController.removeListener(_onFormChanged);
    passwordController.removeListener(_onFormChanged);
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void enableAutovalidate() {
    if (_autoValidate) return;
    _autoValidate = true;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<LoginResult> submit() async {
    enableAutovalidate();

    if (_isSubmitting) {
      return const LoginResult.inProgress();
    }

    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return const LoginResult.validationError();
    }

    _setSubmitting(true);
    try {
      final profile = await _profileRepository.loadProfile();
      if (profile == null) {
        return const LoginResult.missingProfile();
      }

      await _authService.setHasCredentials(true);
      return const LoginResult.success();
    } catch (error) {
      return LoginResult(LoginStatus.failure, error: error);
    } finally {
      _setSubmitting(false);
    }
  }

  void _onFormChanged() {
    final isValid = AuthValidators.isValidEmail(emailController.text) &&
        passwordController.text.length >= 8;
    if (isValid == _canSubmit) return;
    _canSubmit = isValid;
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  }
}
