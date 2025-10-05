// lib/view/login/welcome_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_state.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common_widget/app_language_toggle.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with AppLanguageState<WelcomeView> {
  static const _title = LocalizedText(
    english: 'Welcome, GYM Buddy',
    indonesian: 'Selamat datang, GYM Buddy',
  );
  static const _subtitle = LocalizedText(
    english:
        'You are all set now, let’s reach your\ngoals together with us',
    indonesian:
        'Semua sudah siap, ayo capai\ntujuanmu bersama kami',
  );
  static const _cta = LocalizedText(
    english: 'Go To Home',
    indonesian: 'Pergi ke Beranda',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppLanguageToggle(
                        selectedLanguage: language,
                        onSelected: updateLanguage,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/img/welcome.png',
                      width: MediaQuery.of(context).size.width * 0.75,
                      fit: BoxFit.fitWidth,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      localized(_title),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localized(_subtitle),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TColor.gray, fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    RoundButton(
                      title: localized(_cta),
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        await AuthService.instance.setHasCredentials(true);
                        if (!mounted) return;
                        router.go(AppRoute.main);
                      },
                    ),
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
