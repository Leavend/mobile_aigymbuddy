import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/notification_row.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  static const List<Map<String, String>> _notifications = [
    {
      'image': 'assets/img/Workout1.png',
      'title': 'Hey, it’s time for lunch',
      'time': 'About 1 minutes ago',
    },
    {
      'image': 'assets/img/Workout2.png',
      'title': 'Don’t miss your lowerbody workout',
      'time': 'About 3 hours ago',
    },
    {
      'image': 'assets/img/Workout3.png',
      'title': 'Hey, let’s add some meals for your b',
      'time': 'About 3 hours ago',
    },
    {
      'image': 'assets/img/Workout1.png',
      'title': 'Congratulations, You have finished A..',
      'time': '29 May',
    },
    {
      'image': 'assets/img/Workout2.png',
      'title': 'Hey, it’s time for lunch',
      'time': '8 April',
    },
    {
      'image': 'assets/img/Workout3.png',
      'title': 'Ups, You have missed your Lowerbo...',
      'time': '8 April',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: _SquareIconButton(
          asset: 'assets/img/black_btn.png',
          onTap: () => context.pop(),
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [_SquareIconButton(asset: 'assets/img/more_btn.png')],
      ),
      backgroundColor: TColor.white,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        itemCount: _notifications.length,
        itemBuilder: (context, index) => NotificationRow.fromMap(
          Map<String, dynamic>.from(_notifications[index]),
        ),
        separatorBuilder: (_, index) =>
            Divider(color: TColor.gray.withValues(alpha: 0.5), height: 1),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;

  const _SquareIconButton({required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(asset, width: 15, height: 15, fit: BoxFit.contain),
      ),
    );
  }
}
