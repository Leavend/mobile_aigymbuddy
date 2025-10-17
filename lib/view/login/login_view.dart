// lib/view/login/login_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/app/app_state.dart';
import 'package:aigymbuddy/app/dependencies.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:aigymbuddy/view/shared/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/auth_page_layout.dart';
import 'widgets/auth_validators.dart';

abstract final class _LoginTexts {
  static const socialProviders = [
    'assets/img/google.png',
    'assets/img/facebook.png',
  ];

  static const greeting = LocalizedText(
    english: 'Hey there,',
    indonesian: 'Hai,',
  );
  static const welcomeBack = LocalizedText(
    english: 'Welcome Back',
    indonesian: 'Selamat Datang Kembali',
  );
  static const emailHint = LocalizedText(english: 'Email', indonesian: 'Email');
  static const passwordHint = LocalizedText(
    english: 'Password',
    indonesian: 'Kata Sandi',
  );
  static const forgotPassword = LocalizedText(
    english: 'Forgot your password?',
    indonesian: 'Lupa kata sandi?',
  );
  static const loginButton = LocalizedText(
    english: 'Login',
    indonesian: 'Masuk',
  );
  static const divider = LocalizedText(english: 'Or', indonesian: 'Atau');
  static const noAccount = LocalizedText(
    english: 'Don’t have an account yet? ',
    indonesian: 'Belum punya akun? ',
  );
  static const register = LocalizedText(
    english: 'Register',
    indonesian: 'Daftar',
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
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoginEnabled = false;
  bool _autoValidate = false;
  bool _isSubmitting = false;
  ProfileRepository? _profileRepository;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileRepository ??= AppDependencies.of(context).profileRepository;
  }

  void _validateForm() {
    final isValid = _canSubmit();
    if (isValid != _isLoginEnabled) {
      setState(() => _isLoginEnabled = isValid);
    }
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();

    setState(() => _autoValidate = true);

    if (_isSubmitting) {
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _attemptLogin();
    }
  }

  Future<void> _attemptLogin() async {
    final repository =
        _profileRepository ?? AppDependencies.of(context).profileRepository;

    setState(() => _isSubmitting = true);
    try {
      final profile = await repository.loadProfile();
      if (!mounted) return;

      if (profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Profil belum tersedia. Silakan daftar terlebih dahulu.'),
          ),
        );
        // Also reset the submitting state here to re-enable the button
        setState(() => _isSubmitting = false);
        return;
      }

      await AuthService.instance.setHasCredentials(true);

      // FIX: Add a mounted check before using the context.
      if (!mounted) return;
      AppStateScope.of(context).updateHasProfile(true);

      if (!mounted) return;
      context.go(AppRoute.main);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal masuk: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _onForgotPasswordPressed() {
    FocusScope.of(context).unfocus();
    context.go(AppRoute.main);
  }

  String? _validateEmail(String? value) {
    return AuthValidators.validateEmail(
      context: context,
      value: value,
      emptyMessage: _LoginTexts.emailRequired,
      invalidMessage: _LoginTexts.emailInvalid,
    );
  }

  String? _validatePassword(String? value) {
    return AuthValidators.validatePassword(
      context: context,
      value: value,
      emptyMessage: _LoginTexts.passwordRequired,
      lengthMessage: _LoginTexts.passwordLength,
    );
  }

  bool _canSubmit() {
    return AuthValidators.isValidEmail(_emailController.text) &&
        _passwordController.text.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    final autovalidateMode = _autoValidate
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 36),
          _buildEmailField(context),
          const SizedBox(height: 20),
          _buildPasswordField(context),
          const SizedBox(height: 16),
          _buildForgotPasswordButton(context),
          const SizedBox(height: 28),
          RoundButton(
            title: context.localize(_LoginTexts.loginButton),
            onPressed: _onLoginPressed,
            isEnabled: _isLoginEnabled && !_isSubmitting,
          ),
          const SizedBox(height: 28),
          _buildDivider(context),
          const SizedBox(height: 24),
          _buildSocialRow(),
          const SizedBox(height: 28),
          _buildSignUpPrompt(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          context.localize(_LoginTexts.greeting),
          textAlign: TextAlign.center,
          style: const TextStyle(color: TColor.gray, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          context.localize(_LoginTexts.welcomeBack),
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

  Widget _buildEmailField(BuildContext context) {
    return RoundTextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      hintText: context.localize(_LoginTexts.emailHint),
      icon: 'assets/img/email.png',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: _validateEmail,
      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return RoundTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      hintText: context.localize(_LoginTexts.passwordHint),
      icon: 'assets/img/lock.png',
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
      validator: _validatePassword,
      onFieldSubmitted: (_) => _onLoginPressed(),
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
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _onForgotPasswordPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          context.localize(_LoginTexts.forgotPassword),
          style: const TextStyle(
            color: TColor.gray,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: TColor.gray.withValues(alpha: 0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.localize(_LoginTexts.divider),
            style: const TextStyle(color: TColor.black, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: TColor.gray.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _LoginTexts.socialProviders.length; i++) ...[
          SocialAuthButton(assetPath: _LoginTexts.socialProviders[i]),
          if (i < _LoginTexts.socialProviders.length - 1)
            const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(AppRoute.signUp),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.localize(_LoginTexts.noAccount),
            style: const TextStyle(color: TColor.black, fontSize: 14),
          ),
          Text(
            context.localize(_LoginTexts.register),
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
