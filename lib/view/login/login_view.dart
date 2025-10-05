// lib/view/login/login_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
  static const _dividerText = LocalizedText(
    english: '  Or  ',
    indonesian: '  Atau  ',
  );
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      context.localize(_greetingText),
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.localize(_welcomeBackText),
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 32),
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
                    const SizedBox(height: 12),
                    TextButton(
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
                    const SizedBox(height: 32),
                    RoundButton(
                      title: context.localize(_loginButtonText),
                      onPressed: () {
                        context.push(AppRoute.completeProfile);
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: TColor.gray.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          context.localize(_dividerText),
                          style: TextStyle(color: TColor.black, fontSize: 12),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SocialAuthButton(assetPath: 'assets/img/google.png'),
                        SizedBox(width: 16),
                        SocialAuthButton(assetPath: 'assets/img/facebook.png'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.localize(_noAccountText),
                            style:
                                TextStyle(color: TColor.black, fontSize: 14),
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
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
