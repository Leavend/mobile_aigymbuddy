import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/app_language_toggle.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/setting_row.dart';
import 'package:aigymbuddy/common_widget/title_subtitle_cell.dart';

enum _ProfileAction {
  personalData(
    label: LocalizedText(english: 'Personal Data', indonesian: 'Data Pribadi'),
    iconPath: 'assets/img/p_personal.png',
    route: AppRoute.completeProfile,
  ),
  achievement(
    label: LocalizedText(english: 'Achievement', indonesian: 'Pencapaian'),
    iconPath: 'assets/img/p_achi.png',
    route: AppRoute.finishedWorkout,
  ),
  activityHistory(
    label: LocalizedText(
      english: 'Activity History',
      indonesian: 'Riwayat Aktivitas',
    ),
    iconPath: 'assets/img/p_activity.png',
    route: AppRoute.activityTracker,
  ),
  workoutProgress(
    label: LocalizedText(
      english: 'Workout Progress',
      indonesian: 'Progres Latihan',
    ),
    iconPath: 'assets/img/p_workout.png',
    route: AppRoute.workoutTracker,
  ),
  contactUs(
    label: LocalizedText(english: 'Contact Us', indonesian: 'Hubungi Kami'),
    iconPath: 'assets/img/p_contact.png',
  ),
  privacyPolicy(
    label: LocalizedText(
      english: 'Privacy Policy',
      indonesian: 'Kebijakan Privasi',
    ),
    iconPath: 'assets/img/p_privacy.png',
  ),
  settings(
    label: LocalizedText(english: 'Settings', indonesian: 'Pengaturan'),
    iconPath: 'assets/img/p_setting.png',
  );

  const _ProfileAction({
    required this.label,
    required this.iconPath,
    this.route,
  });

  final LocalizedText label;
  final String iconPath;
  final String? route;
}

class _ProfileMetric {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final LocalizedText label;
}

class _ProfileStrings {
  const _ProfileStrings._();

  static const title = LocalizedText(english: 'Profile', indonesian: 'Profil');

  static const edit = LocalizedText(english: 'Edit', indonesian: 'Ubah');

  static const program = LocalizedText(
    english: 'Lose a Fat Program',
    indonesian: 'Program Kurangi Lemak',
  );

  static const account = LocalizedText(english: 'Account', indonesian: 'Akun');

  static const notification = LocalizedText(
    english: 'Notification',
    indonesian: 'Notifikasi',
  );

  static const language = LocalizedText(
    english: 'Language',
    indonesian: 'Bahasa',
  );

  static const languageDescription = LocalizedText(
    english: 'Select your preferred app language',
    indonesian: 'Pilih bahasa aplikasi Anda',
  );

  static const other = LocalizedText(english: 'Other', indonesian: 'Lainnya');

  static const popupNotification = LocalizedText(
    english: 'Pop-up Notification',
    indonesian: 'Notifikasi Pop-up',
  );

  static const moreOptions = LocalizedText(
    english: 'More options',
    indonesian: 'Opsi lainnya',
  );

  static const metrics = [
    _ProfileMetric(
      value: '180cm',
      label: LocalizedText(english: 'Height', indonesian: 'Tinggi Badan'),
    ),
    _ProfileMetric(
      value: '65kg',
      label: LocalizedText(english: 'Weight', indonesian: 'Berat Badan'),
    ),
    _ProfileMetric(
      value: '22yo',
      label: LocalizedText(english: 'Age', indonesian: 'Usia'),
    ),
  ];

  static String comingSoonMessage(
    AppLanguage language,
    LocalizedText featureName,
  ) {
    final feature = featureName.resolve(language);
    return switch (language) {
      AppLanguage.english => '$feature feature is coming soon.',
      AppLanguage.indonesian => 'Fitur $feature akan hadir segera.',
    };
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isNotificationEnabled = false;

  static const List<_ProfileAction> _accountActions = [
    _ProfileAction.personalData,
    _ProfileAction.achievement,
    _ProfileAction.activityHistory,
    _ProfileAction.workoutProgress,
  ];

  static const List<_ProfileAction> _otherActions = [
    _ProfileAction.contactUs,
    _ProfileAction.privacyPolicy,
    _ProfileAction.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final language = context.appLanguage;
    final localize = context.localize;
    final languageController = AppLanguageScope.of(context);

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: _buildAppBar(localize),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(localize),
              const SizedBox(height: 15),
              _buildMetrics(language),
              const SizedBox(height: 25),
              _buildSection(
                title: localize(_ProfileStrings.account),
                child: _buildMenuList(_accountActions, language),
              ),
              const SizedBox(height: 25),
              _buildSection(
                title: localize(_ProfileStrings.language),
                child: _buildLanguageSection(
                  language: language,
                  onSelected: languageController.select,
                ),
              ),
              const SizedBox(height: 25),
              _buildSection(
                title: localize(_ProfileStrings.notification),
                child: _buildNotificationToggle(),
              ),
              const SizedBox(height: 25),
              _buildSection(
                title: localize(_ProfileStrings.other),
                child: _buildMenuList(_otherActions, language),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(String Function(LocalizedText) localize) {
    return AppBar(
      backgroundColor: TColor.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        localize(_ProfileStrings.title),
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () => _showComingSoon(_ProfileStrings.moreOptions),
              icon: Image.asset(
                'assets/img/more_btn.png',
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String Function(LocalizedText) localize) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/img/u2.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stefani Wong',
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                localize(_ProfileStrings.program),
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 95,
          height: 25,
          child: RoundButton(
            title: localize(_ProfileStrings.edit),
            type: RoundButtonType.bgGradient,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            onPressed: () => _onActionSelected(_ProfileAction.personalData),
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(AppLanguage language) {
    final metricWidgets = <Widget>[];

    for (var i = 0; i < _ProfileStrings.metrics.length; i++) {
      final metric = _ProfileStrings.metrics[i];
      metricWidgets.add(
        Expanded(
          child: TitleSubtitleCell(
            title: metric.value,
            subtitle: metric.label.resolve(language),
          ),
        ),
      );

      if (i != _ProfileStrings.metrics.length - 1) {
        metricWidgets.add(const SizedBox(width: 15));
      }
    }

    return Row(children: metricWidgets);
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildMenuList(List<_ProfileAction> actions, AppLanguage language) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final action = actions[index];
        return SettingRow(
          icon: action.iconPath,
          title: action.label.resolve(language),
          onPressed: () => _onActionSelected(action),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 6),
      itemCount: actions.length,
    );
  }

  Widget _buildNotificationToggle() {
    return SizedBox(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/p_notification.png',
            height: 15,
            width: 15,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              context.localize(_ProfileStrings.popupNotification),
              style: TextStyle(color: TColor.black, fontSize: 12),
            ),
          ),
          _buildToggle(),
        ],
      ),
    );
  }

  Widget _buildLanguageSection({
    required AppLanguage language,
    required ValueChanged<AppLanguage> onSelected,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.translate, size: 18, color: TColor.primaryColor1),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            context.localize(_ProfileStrings.languageDescription),
            style: TextStyle(color: TColor.black, fontSize: 12),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Align(
            alignment: Alignment.centerRight,
            child: AppLanguageToggle(
              selectedLanguage: language,
              onSelected: onSelected,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return CustomAnimatedToggleSwitch<bool>(
      current: _isNotificationEnabled,
      values: const [false, true],
      spacing: 0.0,
      indicatorSize: const Size.square(30.0),
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.linear,
      onChanged: (value) => setState(() => _isNotificationEnabled = value),
      iconBuilder: (context, local, global) => const SizedBox.shrink(),
      onTap: (value) =>
          setState(() => _isNotificationEnabled = !_isNotificationEnabled),
      iconsTappable: false,
      wrapperBuilder: (context, global, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 10.0,
              right: 10.0,
              height: 30.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.secondaryG),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
            ),
            child,
          ],
        );
      },
      foregroundIndicatorBuilder: (context, global) {
        return SizedBox.fromSize(
          size: const Size(10, 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0.05,
                  blurRadius: 1.1,
                  offset: Offset(0.0, 0.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onActionSelected(_ProfileAction action) {
    final route = action.route;
    if (route != null) {
      context.push(route);
      return;
    }

    _showComingSoon(action.label);
  }

  void _showComingSoon(LocalizedText featureName) {
    final messenger = ScaffoldMessenger.of(context);
    final language = context.appLanguage;
    messenger.hideCurrentSnackBar(); // Call the first method
    messenger.showSnackBar(
      // Call the second method
      SnackBar(
        content: Text(_ProfileStrings.comingSoonMessage(language, featureName)),
      ),
    );
  }
}
