import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const _socialProviders = [
    'assets/img/google.png',
    'assets/img/facebook.png',
  ];

  static const _greetingText = LocalizedText(
    english: 'Hey there,',
    indonesian: 'Hai,',
  );
  static const _welcomeBackText = LocalizedText(
    english: 'Welcome Back',
    indonesian: 'Selamat Datang Kembali',
  );
  static const _emailHint = LocalizedText(
    english: 'Email',
    indonesian: 'Email',
  );
  static const _passwordHint = LocalizedText(
    english: 'Password',
    indonesian: 'Kata Sandi',
  );
  static const _forgotPasswordText = LocalizedText(
    english: 'Forgot your password?',
    indonesian: 'Lupa kata sandi?',
  );
  static const _loginButtonText = LocalizedText(
    english: 'Login',
    indonesian: 'Masuk',
  );
  static const _dividerText = LocalizedText(english: 'Or', indonesian: 'Atau');
  static const _noAccountText = LocalizedText(
    english: 'Don’t have an account yet? ',
    indonesian: 'Belum punya akun? ',
  );
  static const _registerText = LocalizedText(
    english: 'Register',
    indonesian: 'Daftar',
  );

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      const SizedBox(height: 36),
                      RoundTextField(
                        hitText: context.localize(_emailHint),
                        icon: 'assets/img/email.png',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      RoundTextField(
                        hitText: context.localize(_passwordHint),
                        icon: 'assets/img/lock.png',
                        obscureText: true,
                        rigtIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/img/show_password.png',
                            width: 20,
                            height: 20,
                            color: TColor.gray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
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
                      ),
                      const SizedBox(height: 28),
                      RoundButton(
                        title: context.localize(_loginButtonText),
                        onPressed: () {
                          context.push(AppRoute.completeProfile);
                        },
                      ),
                      const SizedBox(height: 28),
                      Row(
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
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: TColor.gray.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSocialRow(),
                      const SizedBox(height: 28),
                      _buildSignUpPrompt(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
}
