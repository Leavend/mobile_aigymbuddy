import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isTermsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isRegisterEnabled = false;
  bool _autoValidate = false;
  bool _showTermsError = false;

  static const _greetingText = LocalizedText(
    english: 'Hey there,',
    indonesian: 'Hai,',
  );
  static const _createAccountText = LocalizedText(
    english: 'Create an Account',
    indonesian: 'Buat Akun',
  );
  static const _firstNameHint = LocalizedText(
    english: 'First Name',
    indonesian: 'Nama Depan',
  );
  static const _lastNameHint = LocalizedText(
    english: 'Last Name',
    indonesian: 'Nama Belakang',
  );
  static const _emailHint = LocalizedText(
    english: 'Email',
    indonesian: 'Email',
  );
  static const _passwordHint = LocalizedText(
    english: 'Password',
    indonesian: 'Kata Sandi',
  );
  static const _termsText = LocalizedText(
    english: 'By continuing you accept our Privacy Policy and\nTerm of Use',
    indonesian:
        'Dengan melanjutkan kamu menyetujui Kebijakan Privasi dan\nSyarat Penggunaan kami',
  );
  static const _registerText = LocalizedText(
    english: 'Register',
    indonesian: 'Daftar',
  );
  static const _dividerText = LocalizedText(english: 'Or', indonesian: 'Atau');
  static const _footerQuestionText = LocalizedText(
    english: 'Already have an account? ',
    indonesian: 'Sudah punya akun? ',
  );
  static const _footerActionText = LocalizedText(
    english: 'Login',
    indonesian: 'Masuk',
  );

  static const _firstNameRequiredError = LocalizedText(
    english: 'First name is required',
    indonesian: 'Nama depan wajib diisi',
  );
  static const _lastNameRequiredError = LocalizedText(
    english: 'Last name is required',
    indonesian: 'Nama belakang wajib diisi',
  );
  static const _emailRequiredError = LocalizedText(
    english: 'Email is required',
    indonesian: 'Email wajib diisi',
  );
  static const _emailInvalidError = LocalizedText(
    english: 'Enter a valid email address',
    indonesian: 'Masukkan alamat email yang valid',
  );
  static const _passwordRequiredError = LocalizedText(
    english: 'Password is required',
    indonesian: 'Kata sandi wajib diisi',
  );
  static const _passwordLengthError = LocalizedText(
    english: 'Password must be at least 8 characters',
    indonesian: 'Kata sandi minimal 8 karakter',
  );
  static const _termsRequiredError = LocalizedText(
    english: 'Please accept the terms to continue',
    indonesian: 'Silakan setujui syarat dan ketentuan terlebih dahulu',
  );

  static final RegExp _emailRegExp = RegExp(
    '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: _buildContent(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final autovalidateMode =
        _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Text(
          context.localize(_greetingText),
          textAlign: TextAlign.center,
          style: TextStyle(color: TColor.gray, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          context.localize(_createAccountText),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: TColor.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 28),
        Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundTextField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                hintText: context.localize(_firstNameHint),
                icon: 'assets/img/user_text.png',
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autovalidateMode: autovalidateMode,
                validator: _validateFirstName,
                onChanged: _onFieldChanged,
                onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
              ),
              const SizedBox(height: 16),
              RoundTextField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                hintText: context.localize(_lastNameHint),
                icon: 'assets/img/user_text.png',
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autovalidateMode: autovalidateMode,
                validator: _validateLastName,
                onChanged: _onFieldChanged,
                onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
              ),
              const SizedBox(height: 16),
              RoundTextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                hintText: context.localize(_emailHint),
                icon: 'assets/img/email.png',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autovalidateMode: autovalidateMode,
                validator: _validateEmail,
                onChanged: _onFieldChanged,
                onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
              ),
              const SizedBox(height: 16),
              RoundTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                hintText: context.localize(_passwordHint),
                icon: 'assets/img/lock.png',
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                autovalidateMode: autovalidateMode,
                validator: _validatePassword,
                onChanged: _onFieldChanged,
                onFieldSubmitted: (_) => _onRegisterPressed(),
                rightIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Image.asset(
                    _isPasswordVisible
                        ? 'assets/img/hide_password.png'
                        : 'assets/img/show_password.png',
                    width: 20,
                    height: 20,
                    color: TColor.gray,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildTermsRow(context),
        if (_showTermsError && !_isTermsAccepted) ...[
          const SizedBox(height: 4),
          Text(
            context.localize(_termsRequiredError),
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 24),
        RoundButton(
          title: context.localize(_registerText),
          onPressed: _onRegisterPressed,
          isEnabled: _isRegisterEnabled && _isTermsAccepted,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: TColor.gray.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              context.localize(_dividerText),
              style: TextStyle(color: TColor.black, fontSize: 12),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 1,
                color: TColor.gray.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SocialAuthButton(assetPath: 'assets/img/google.png'),
            SizedBox(width: 16),
            SocialAuthButton(
              assetPath: 'assets/img/facebook.png',
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            context.push(AppRoute.login);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localize(_footerQuestionText),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                ),
              ),
              Text(
                context.localize(_footerActionText),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTermsRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _isTermsAccepted,
          onChanged: (value) {
            setState(() {
              _isTermsAccepted = value ?? false;
              if (_isTermsAccepted) {
                _showTermsError = false;
              }
            });
            _onFieldChanged('');
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            context.localize(_termsText),
            style: TextStyle(
              color: TColor.gray,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _onFieldChanged(String _) {
    final isValid = _canSubmitForm();
    if (isValid != _isRegisterEnabled) {
      setState(() {
        _isRegisterEnabled = isValid;
      });
    }
  }

  void _onRegisterPressed() {
    final form = _formKey.currentState;
    if (form == null) {
      return;
    }

    setState(() {
      _autoValidate = true;
      _showTermsError = !_isTermsAccepted;
    });

    if (!form.validate() || !_isTermsAccepted) {
      _onFieldChanged('');
      return;
    }

    context.push(AppRoute.completeProfile);
  }

  String? _validateFirstName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return context.localize(_firstNameRequiredError);
    }
    return null;
  }

  String? _validateLastName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return context.localize(_lastNameRequiredError);
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return context.localize(_emailRequiredError);
    }
    if (!_emailRegExp.hasMatch(text)) {
      return context.localize(_emailInvalidError);
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return context.localize(_passwordRequiredError);
    }
    if (text.length < 8) {
      return context.localize(_passwordLengthError);
    }
    return null;
  }

  bool _canSubmitForm() {
    return _validateFirstName(_firstNameController.text) == null &&
        _validateLastName(_lastNameController.text) == null &&
        _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null;
  }
}
