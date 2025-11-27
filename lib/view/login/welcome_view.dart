import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/auth_page_layout.dart';

abstract final class _WelcomeTexts {
  static const title = LocalizedText(
    english: 'Welcome, GYM Buddy',
    indonesian: 'Selamat datang, GYM Buddy',
  );
  static const subtitle = LocalizedText(
    english: 'You are all set now, let’s reach your\ngoals together with us',
    indonesian: 'Semua sudah siap, ayo capai\ntujuanmu bersama kami',
  );
  static const cta = LocalizedText(
    english: 'Go To Home',
    indonesian: 'Pergi ke Beranda',
  );
}

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    return AuthPageLayout(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Image.asset(
            'assets/img/welcome.png',
            width: mediaWidth * 0.75,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 32),
          Text(
            context.localize(_WelcomeTexts.title),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TColor.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.localize(_WelcomeTexts.subtitle),
            textAlign: TextAlign.center,
            style: const TextStyle(color: TColor.gray, fontSize: 14),
          ),
          const SizedBox(height: 40),
          RoundButton(
            title: context.localize(_WelcomeTexts.cta),
            onPressed: _goToHome,
          ),
        ],
      ),
    );
  }

  Future<void> _goToHome() async {
    final router = GoRouter.of(context);
    await AuthService.instance.setHasCredentials(true);
    if (!mounted) return;
    router.go(AppRoute.main);
  }
}
