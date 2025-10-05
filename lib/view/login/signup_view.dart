// lib/view/login/signup_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_state.dart';
import 'package:aigymbuddy/common_widget/app_language_toggle.dart';
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

class _SignUpViewState extends State<SignUpView>
    with AppLanguageState<SignUpView> {
  bool _isTermsAccepted = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppLanguageToggle(
                          selectedLanguage: language,
                          onSelected: updateLanguage,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        localized(_greetingText),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: TColor.gray, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localized(_createAccountText),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      RoundTextField(
                        hitText: localized(_firstNameHint),
                        icon: 'assets/img/user_text.png',
                      ),
                      const SizedBox(height: 16),
                      RoundTextField(
                        hitText: localized(_lastNameHint),
                        icon: 'assets/img/user_text.png',
                      ),
                      const SizedBox(height: 16),
                      RoundTextField(
                        hitText: localized(_emailHint),
                        icon: 'assets/img/email.png',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      RoundTextField(
                        hitText: localized(_passwordHint),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _isTermsAccepted,
                            onChanged: (value) {
                              setState(() {
                                _isTermsAccepted = value ?? false;
                              });
                            },
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              localized(_termsText),
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      RoundButton(
                        title: localized(_registerText),
                        onPressed: () {
                          context.push(AppRoute.completeProfile);
                        },
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
                            localized(_dividerText),
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
                              localized(_footerQuestionText),
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              localized(_footerActionText),
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
