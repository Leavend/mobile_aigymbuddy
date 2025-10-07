import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Constants moved outside the class for better separation of concerns ---

const _socialProviders = ['assets/img/google.png', 'assets/img/facebook.png'];

const _greetingText = LocalizedText(english: 'Hey there,', indonesian: 'Hai,');
const _welcomeBackText = LocalizedText(
  english: 'Welcome Back',
  indonesian: 'Selamat Datang Kembali',
);
const _emailHint = LocalizedText(english: 'Email', indonesian: 'Email');
const _passwordHint = LocalizedText(
  english: 'Password',
  indonesian: 'Kata Sandi',
);
const _forgotPasswordText = LocalizedText(
  english: 'Forgot your password?',
  indonesian: 'Lupa kata sandi?',
);
const _loginButtonText = LocalizedText(english: 'Login', indonesian: 'Masuk');
const _dividerText = LocalizedText(english: 'Or', indonesian: 'Atau');
const _noAccountText = LocalizedText(
  english: 'Don’t have an account yet? ',
  indonesian: 'Belum punya akun? ',
);
const _registerText = LocalizedText(english: 'Register', indonesian: 'Daftar');

final _emailRegExp = RegExp(
  r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
  caseSensitive: false,
);

const _emailRequiredError = LocalizedText(
  english: 'Email is required',
  indonesian: 'Email wajib diisi',
);
const _emailInvalidError = LocalizedText(
  english: 'Enter a valid email address',
  indonesian: 'Masukkan alamat email yang valid',
);
const _passwordRequiredError = LocalizedText(
  english: 'Password is required',
  indonesian: 'Kata sandi wajib diisi',
);
const _passwordLengthError = LocalizedText(
  english: 'Password must be at least 8 characters',
  indonesian: 'Kata sandi minimal 8 karakter',
);

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

  void _validateForm() {
    final isValid = _canSubmit();
    if (isValid != _isLoginEnabled) {
      setState(() {
        _isLoginEnabled = isValid;
      });
    }
  }

  void _onLoginPressed() {
    // Unfocus all fields to hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _autoValidate = true;
    });

    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to the next screen if the form is valid
      context.push(AppRoute.completeProfile);
    }
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

  bool _canSubmit() {
    return _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null;
  }

  static final RegExp _emailRegExp = RegExp(
    '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$',
    caseSensitive: false,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  Widget _buildContent(BuildContext context, double minHeight) {
    final autovalidateMode =
        _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 36),
            _buildEmailField(context, autovalidateMode),
            const SizedBox(height: 20),
            _buildPasswordField(context, autovalidateMode),
            const SizedBox(height: 16),
            _buildForgotPasswordButton(context),
            const SizedBox(height: 28),
            RoundButton(
              title: context.localize(_loginButtonText),
              onPressed: _onLoginPressed,
              isEnabled: _isLoginEnabled,
            ),
            const SizedBox(height: 28),
            _buildDivider(context),
            const SizedBox(height: 24),
            _buildSocialRow(),
            const SizedBox(height: 28),
            _buildSignUpPrompt(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          context.localize(_greetingText),
          textAlign: TextAlign.center,
          style: TextStyle(color: TColor.gray, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          context.localize(_welcomeBackText),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: TColor.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, AutovalidateMode autovalidateMode) {
    return RoundTextField(
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
    );
  }

  Widget _buildPasswordField(BuildContext context, AutovalidateMode autovalidateMode) {
    return RoundTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      hintText: context.localize(_passwordHint),
      icon: 'assets/img/lock.png',
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
      autovalidateMode: autovalidateMode,
      validator: _validatePassword,
      onChanged: _onFieldChanged,
      onFieldSubmitted: (_) => _onLoginPressed(),
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
              // Assuming you have this asset. If not, you can use a different icon.
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
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          context.localize(_forgotPasswordText),
          style: TextStyle(
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
            context.localize(_dividerText),
            style: TextStyle(color: TColor.black, fontSize: 12),
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
        for (var i = 0; i < _socialProviders.length; i++) ...[
          SocialAuthButton(assetPath: _socialProviders[i]),
          if (i < _socialProviders.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go(AppRoute.signUp);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.localize(_noAccountText),
            style: TextStyle(color: TColor.black, fontSize: 14),
          ),
          Text(
            context.localize(_registerText),
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _onFieldChanged(String _) {
    final isValid = _canSubmit();
    if (isValid != _isLoginEnabled) {
      setState(() {
        _isLoginEnabled = isValid;
      });
    }
  }

  void _onLoginPressed() {
    final form = _formKey.currentState;
    if (form == null) {
      return;
    }

    setState(() {
      _autoValidate = true;
    });

    if (!form.validate()) {
      _onFieldChanged('');
      return;
    }

    context.push(AppRoute.completeProfile);
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

  bool _canSubmit() {
    return _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null;
  }
}
