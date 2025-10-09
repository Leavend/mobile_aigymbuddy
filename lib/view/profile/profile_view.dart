// lib/view/profile/profile_view.dart

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_router.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';

enum _ProfileAction {
  personalData(
    label: 'Personal Data',
    iconPath: 'assets/img/p_personal.png',
    route: AppRoute.completeProfile,
  ),
  achievement(
    label: 'Achievement',
    iconPath: 'assets/img/p_achi.png',
    route: AppRoute.finishedWorkout,
  ),
  activityHistory(
    label: 'Activity History',
    iconPath: 'assets/img/p_activity.png',
    route: AppRoute.activityTracker,
  ),
  workoutProgress(
    label: 'Workout Progress',
    iconPath: 'assets/img/p_workout.png',
    route: AppRoute.workoutTracker,
  ),
  contactUs(label: 'Contact Us', iconPath: 'assets/img/p_contact.png'),
  privacyPolicy(label: 'Privacy Policy', iconPath: 'assets/img/p_privacy.png'),
  settings(label: 'Settings', iconPath: 'assets/img/p_setting.png');

  const _ProfileAction({
    required this.label,
    required this.iconPath,
    this.route,
  });

  final String label;
  final String iconPath;
  final String? route;
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
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: '180cm',
                      subtitle: 'Height',
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(title: '65kg', subtitle: 'Weight'),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(title: '22yo', subtitle: 'Age'),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildSection(
                title: 'Account',
                child: _buildMenuList(_accountActions),
              ),
              const SizedBox(height: 25),
              _buildSection(
                title: 'Notification',
                child: _buildNotificationToggle(),
              ),
              const SizedBox(height: 25),
              _buildSection(
                title: 'Other',
                child: _buildMenuList(_otherActions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'Profile',
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
              onPressed: () => _showComingSoon('More options'),
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

  Widget _buildHeader() {
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
                'Lose a Fat Program',
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 70,
          height: 25,
          child: RoundButton(
            title: 'Edit',
            type: RoundButtonType.bgGradient,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            onPressed: () => _onActionSelected(_ProfileAction.personalData),
          ),
        ),
      ],
    );
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

  Widget _buildMenuList(List<_ProfileAction> actions) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final action = actions[index];
        return SettingRow(
          icon: action.iconPath,
          title: action.label,
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
              'Pop-up Notification',
              style: TextStyle(color: TColor.black, fontSize: 12),
            ),
          ),
          _buildToggle(),
        ],
      ),
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

  void _showComingSoon(String featureName) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$featureName feature is coming soon.')),
      );
  }
}
