import 'dart:developer' as developer;

import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/exceptions/app_exceptions.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:aigymbuddy/view/base/base_view.dart';
import 'package:aigymbuddy/view/login/controllers/login_controller.dart';
import 'package:aigymbuddy/view/login/widgets/auth_page_layout.dart';
import 'package:aigymbuddy/view/login/widgets/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  static const invalidCredentials = LocalizedText(
    english: 'Incorrect email or password.',
    indonesian: 'Email atau kata sandi salah.',
  );
  static const loginFailed = LocalizedText(
    english: 'Unable to login. Please try again later.',
    indonesian: 'Tidak dapat masuk. Silakan coba lagi nanti.',
  );
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginController(context.read<AuthController>()),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends BaseView<LoginController> {
  const _LoginContent();

  @override
  Widget buildContent(BuildContext context, LoginController controller) {
    return AuthPageLayout(child: _LoginForm(controller: controller));
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({required this.controller});

  final LoginController controller;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      await widget.controller.login();
      if (!mounted) return;
      context.go(AppRoute.main);
    } on AuthException {
      _showErrorMessage(_LoginTexts.invalidCredentials);
    } on AppException {
      _showErrorMessage(_LoginTexts.loginFailed);
    } catch (error, stackTrace) {
      developer.log('Login failed', error: error, stackTrace: stackTrace);
      _showErrorMessage(_LoginTexts.loginFailed);
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

  void _showErrorMessage(LocalizedText text) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.localize(text))));
  }

  @override
  Widget build(BuildContext context) {
    // Listen to controller changes for UI updates
    final controller = widget.controller;

    // We use Consumer in the parent BaseView, but here we are in a separate widget.
    // However, since we pass controller, we can use it.
    // But to rebuild on controller changes, we should use AnimatedBuilder or Consumer.
    // BaseView uses Consumer, so buildContent is called on changes.
    // But _LoginForm is a StatefulWidget, so it might not rebuild unless we pass data.
    // Actually, BaseView's buildContent is called inside Consumer's builder.
    // So when controller notifies, buildContent is called, which rebuilds _LoginForm.
    // But _LoginForm is const, so it might not rebuild if arguments didn't change?
    // No, if parent rebuilds, child rebuilds.

    final autovalidateMode = controller.autoValidate
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
          _buildEmailField(context, controller),
          const SizedBox(height: 20),
          _buildPasswordField(context, controller),
          const SizedBox(height: 16),
          _buildForgotPasswordButton(context),
          const SizedBox(height: 28),
          RoundButton(
            title: context.localize(_LoginTexts.loginButton),
            onPressed: _onLoginPressed,
            isEnabled: controller.isLoginEnabled && !controller.isLoading,
            isLoading: controller.isLoading,
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

  Widget _buildEmailField(BuildContext context, LoginController controller) {
    return RoundTextField(
      controller: controller.emailController,
      focusNode: _emailFocusNode,
      hintText: context.localize(_LoginTexts.emailHint),
      icon: 'assets/img/email.png',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: _validateEmail,
      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
    );
  }

  Widget _buildPasswordField(BuildContext context, LoginController controller) {
    return RoundTextField(
      controller: controller.passwordController,
      focusNode: _passwordFocusNode,
      hintText: context.localize(_LoginTexts.passwordHint),
      icon: 'assets/img/lock.png',
      obscureText: controller.isObscurePassword,
      textInputAction: TextInputAction.done,
      validator: _validatePassword,
      onFieldSubmitted: (_) => _onLoginPressed(),
      rightIcon: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: controller.togglePasswordVisibility,
        icon: Image.asset(
          controller.isObscurePassword
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
