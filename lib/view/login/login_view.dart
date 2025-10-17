// lib/view/login/login_view.dart

import 'package:aigymbuddy/app/app_state.dart';
import 'package:aigymbuddy/app/dependencies.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/login_form_controller.dart';
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
  static const missingProfile = LocalizedText(
    english: 'Profile not found. Please sign up first.',
    indonesian: 'Profil belum tersedia. Silakan daftar terlebih dahulu.',
  );
  static const genericError = LocalizedText(
    english: 'Failed to login. Please try again.',
    indonesian: 'Gagal masuk. Silakan coba lagi.',
  );
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginFormController? _controller;

  LoginFormController get _formController => _controller!;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= LoginFormController(
      profileRepository: AppDependencies.of(context).profileRepository,
      authService: AuthService.instance,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _formController;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AuthPageLayout(child: _buildContent(context, controller));
      },
    );
  }

  Widget _buildContent(BuildContext context, LoginFormController controller) {
    return Form(
      key: controller.formKey,
      autovalidateMode: controller.autovalidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 36),
          _buildEmailField(context, controller),
          const SizedBox(height: 20),
          _buildPasswordField(context, controller),
          const SizedBox(height: 16),
          _buildForgotPasswordButton(context),
          const SizedBox(height: 28),
          RoundButton(
            title: context.localize(_LoginTexts.loginButton),
            onPressed: () => _handleLogin(controller),
            isEnabled: controller.isLoginEnabled,
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

  Widget _buildEmailField(
    BuildContext context,
    LoginFormController controller,
  ) {
    return RoundTextField(
      controller: controller.emailController,
      focusNode: controller.emailFocusNode,
      hintText: context.localize(_LoginTexts.emailHint),
      icon: 'assets/img/email.png',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: _validateEmail,
      onFieldSubmitted: (_) => controller.passwordFocusNode.requestFocus(),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    LoginFormController controller,
  ) {
    return RoundTextField(
      controller: controller.passwordController,
      focusNode: controller.passwordFocusNode,
      hintText: context.localize(_LoginTexts.passwordHint),
      icon: 'assets/img/lock.png',
      obscureText: !controller.isPasswordVisible,
      textInputAction: TextInputAction.done,
      validator: _validatePassword,
      onFieldSubmitted: (_) => _handleLogin(controller),
      rightIcon: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: controller.togglePasswordVisibility,
        icon: Image.asset(
          controller.isPasswordVisible
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

  void _onForgotPasswordPressed() {
    FocusScope.of(context).unfocus();
    context.go(AppRoute.main);
  }

  Future<void> _handleLogin(LoginFormController controller) async {
    FocusScope.of(context).unfocus();
    final result = await controller.submit();
    if (!mounted) return;

    switch (result.status) {
      case LoginStatus.success:
        AppStateScope.of(context).updateHasProfile(true);
        if (!mounted) return;
        context.go(AppRoute.main);
        break;
      case LoginStatus.validationError:
      case LoginStatus.inProgress:
        break;
      case LoginStatus.missingProfile:
        _showSnack(context.localize(_LoginTexts.missingProfile));
        break;
      case LoginStatus.failure:
        final errorText = result.error?.toString();
        final message = errorText == null || errorText.isEmpty
            ? context.localize(_LoginTexts.genericError)
            : '${context.localize(_LoginTexts.genericError)}\n$errorText';
        _showSnack(message);
        break;
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
}
