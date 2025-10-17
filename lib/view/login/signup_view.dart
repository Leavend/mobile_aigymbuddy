import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/onboarding_draft.dart';
import 'widgets/auth_page_layout.dart';
import 'widgets/auth_validators.dart';

abstract final class _SignUpTexts {
  static const greeting = LocalizedText(
    english: 'Hey there,',
    indonesian: 'Hai,',
  );
  static const createAccount = LocalizedText(
    english: 'Create an Account',
    indonesian: 'Buat Akun',
  );
  static const firstNameHint = LocalizedText(
    english: 'First Name',
    indonesian: 'Nama Depan',
  );
  static const lastNameHint = LocalizedText(
    english: 'Last Name',
    indonesian: 'Nama Belakang',
  );
  static const emailHint = LocalizedText(english: 'Email', indonesian: 'Email');
  static const passwordHint = LocalizedText(
    english: 'Password',
    indonesian: 'Kata Sandi',
  );
  static const termsText = LocalizedText(
    english: 'By continuing you accept our Privacy Policy and\nTerm of Use',
    indonesian:
        'Dengan melanjutkan kamu menyetujui Kebijakan Privasi dan\nSyarat Penggunaan kami',
  );
  static const registerButton = LocalizedText(
    english: 'Register',
    indonesian: 'Daftar',
  );
  static const divider = LocalizedText(english: 'Or', indonesian: 'Atau');
  static const footerQuestion = LocalizedText(
    english: 'Already have an account? ',
    indonesian: 'Sudah punya akun? ',
  );
  static const footerAction = LocalizedText(
    english: 'Login',
    indonesian: 'Masuk',
  );

  static const socialProviders = [
    'assets/img/google.png',
    'assets/img/facebook.png',
  ];

  static const firstNameRequired = LocalizedText(
    english: 'First name is required',
    indonesian: 'Nama depan wajib diisi',
  );
  static const lastNameRequired = LocalizedText(
    english: 'Last name is required',
    indonesian: 'Nama belakang wajib diisi',
  );
  static const emailRequired = LocalizedText(
    english: 'Email is required',
    indonesian: 'Email wajib diisi',
  );
  static const emailInvalid = LocalizedText(
    english: 'Enter a valid email address',
    indonesian: 'Masukkan alamat email yang valid',
  );
  static const passwordRequired = LocalizedText(
    english: 'Password is required',
    indonesian: 'Kata sandi wajib diisi',
  );
  static const passwordLength = LocalizedText(
    english: 'Password must be at least 8 characters',
    indonesian: 'Kata sandi minimal 8 karakter',
  );
  static const termsRequired = LocalizedText(
    english: 'Please accept the terms to continue',
    indonesian: 'Silakan setujui syarat dan ketentuan terlebih dahulu',
  );
}

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

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

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

  void _validateForm() {
    final isValid = _canSubmitForm();
    if (isValid != _isRegisterEnabled) {
      setState(() => _isRegisterEnabled = isValid);
    }
  }

  bool _canSubmitForm() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        AuthValidators.isValidEmail(_emailController.text) &&
        _passwordController.text.length >= 8 &&
        _isTermsAccepted;
  }

  void _onRegisterPressed() {
    FocusScope.of(context).unfocus();

    setState(() {
      _autoValidate = true;
      _showTermsError = !_isTermsAccepted;
    });

    if ((_formKey.currentState?.validate() ?? false) && _isTermsAccepted) {
      final draft = OnboardingDraft(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
      );
      final args = ProfileFormArguments(draft: draft);
      context.push(AppRoute.completeProfile, extra: args);
    }
  }

  String? _validateFirstName(String? value) {
    return AuthValidators.validateRequired(
      context: context,
      value: value,
      emptyMessage: _SignUpTexts.firstNameRequired,
    );
  }

  String? _validateLastName(String? value) {
    return AuthValidators.validateRequired(
      context: context,
      value: value,
      emptyMessage: _SignUpTexts.lastNameRequired,
    );
  }

  String? _validateEmail(String? value) {
    return AuthValidators.validateEmail(
      context: context,
      value: value,
      emptyMessage: _SignUpTexts.emailRequired,
      invalidMessage: _SignUpTexts.emailInvalid,
    );
  }

  String? _validatePassword(String? value) {
    return AuthValidators.validatePassword(
      context: context,
      value: value,
      emptyMessage: _SignUpTexts.passwordRequired,
      lengthMessage: _SignUpTexts.passwordLength,
    );
  }

  @override
  Widget build(BuildContext context) {
    final autovalidateMode = _autoValidate
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return AuthPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(context),
          const SizedBox(height: 28),
          _buildForm(context, autovalidateMode),
          const SizedBox(height: 12),
          _buildTermsRow(context),
          if (_showTermsError && !_isTermsAccepted) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                context.localize(_SignUpTexts.termsRequired),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          RoundButton(
            title: context.localize(_SignUpTexts.registerButton),
            onPressed: _onRegisterPressed,
            isEnabled: _isRegisterEnabled,
          ),
          const SizedBox(height: 16),
          _buildDivider(context),
          const SizedBox(height: 16),
          _buildSocialRow(),
          const SizedBox(height: 20),
          _buildLoginPrompt(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          context.localize(_SignUpTexts.greeting),
          textAlign: TextAlign.center,
          style: const TextStyle(color: TColor.gray, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          context.localize(_SignUpTexts.createAccount),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: TColor.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, AutovalidateMode autovalidateMode) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundTextField(
            controller: _firstNameController,
            focusNode: _firstNameFocusNode,
            hintText: context.localize(_SignUpTexts.firstNameHint),
            icon: 'assets/img/user_text.png',
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: _validateFirstName,
            onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
          ),
          const SizedBox(height: 16),
          RoundTextField(
            controller: _lastNameController,
            focusNode: _lastNameFocusNode,
            hintText: context.localize(_SignUpTexts.lastNameHint),
            icon: 'assets/img/user_text.png',
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: _validateLastName,
            onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
          ),
          const SizedBox(height: 16),
          RoundTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            hintText: context.localize(_SignUpTexts.emailHint),
            icon: 'assets/img/email.png',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 16),
          RoundTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hintText: context.localize(_SignUpTexts.passwordHint),
            icon: 'assets/img/lock.png',
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            onFieldSubmitted: (_) => _onRegisterPressed(),
            rightIcon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
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
    );
  }

  Widget _buildTermsRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            _validateForm();
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            context.localize(_SignUpTexts.termsText),
            style: const TextStyle(color: TColor.gray, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: TColor.gray.withValues(alpha: 0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.localize(_SignUpTexts.divider),
            style: const TextStyle(color: TColor.black, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: TColor.gray.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _SignUpTexts.socialProviders.length; i++) ...[
          SocialAuthButton(assetPath: _SignUpTexts.socialProviders[i]),
          if (i < _SignUpTexts.socialProviders.length - 1)
            const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(AppRoute.login),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.localize(_SignUpTexts.footerQuestion),
            style: const TextStyle(color: TColor.black, fontSize: 14),
          ),
          Text(
            context.localize(_SignUpTexts.footerAction),
            style: const TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
