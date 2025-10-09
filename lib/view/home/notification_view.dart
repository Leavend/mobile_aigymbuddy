import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/notification_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  static const List<_NotificationData> _notifications = [
    _NotificationData(
      image: 'assets/img/Workout1.png',
      title: LocalizedText(
        english: 'Hey, it’s time for lunch',
        indonesian: 'Hai, saatnya makan siang',
      ),
      time: LocalizedText(
        english: 'About 1 minute ago',
        indonesian: 'Sekitar 1 menit lalu',
      ),
    ),
    _NotificationData(
      image: 'assets/img/Workout2.png',
      title: LocalizedText(
        english: 'Don’t miss your lowerbody workout',
        indonesian: 'Jangan lewatkan latihan tubuh bagian bawahmu',
      ),
      time: LocalizedText(
        english: 'About 3 hours ago',
        indonesian: 'Sekitar 3 jam lalu',
      ),
    ),
    _NotificationData(
      image: 'assets/img/Workout3.png',
      title: LocalizedText(
        english: 'Hey, let’s add some meals for your body',
        indonesian: 'Hai, ayo tambahkan beberapa makanan untuk tubuhmu',
      ),
      time: LocalizedText(
        english: 'About 3 hours ago',
        indonesian: 'Sekitar 3 jam lalu',
      ),
    ),
    _NotificationData(
      image: 'assets/img/Workout1.png',
      title: LocalizedText(
        english: 'Congratulations, You have finished A..',
        indonesian: 'Selamat, kamu telah menyelesaikan A..',
      ),
      time: LocalizedText(english: '29 May', indonesian: '29 Mei'),
    ),
    _NotificationData(
      image: 'assets/img/Workout2.png',
      title: LocalizedText(
        english: 'Hey, it’s time for lunch',
        indonesian: 'Hai, saatnya makan siang',
      ),
      time: LocalizedText(english: '8 April', indonesian: '8 April'),
    ),
    _NotificationData(
      image: 'assets/img/Workout3.png',
      title: LocalizedText(
        english: 'Ups, You have missed your Lowerbo...',
        indonesian: 'Ups, kamu melewatkan latihan tubuh bawah...',
      ),
      time: LocalizedText(english: '8 April', indonesian: '8 April'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    final language = context.appLanguage;
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
          localize(_NotificationStrings.title),
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
        itemBuilder: (context, index) =>
            NotificationRow.fromMap(_notifications[index].toMap(language)),
        separatorBuilder: (_, index) =>
            Divider(color: TColor.gray.withValues(alpha: 0.5), height: 1),
      ),
    );
  }
}

class _NotificationData {
  const _NotificationData({
    required this.image,
    required this.title,
    required this.time,
  });

  final String image;
  final LocalizedText title;
  final LocalizedText time;

  Map<String, dynamic> toMap(AppLanguage language) {
    return {
      'image': image,
      'title': title.resolve(language),
      'time': time.resolve(language),
    };
  }
}

class _NotificationStrings {
  static const title = LocalizedText(
    english: 'Notification',
    indonesian: 'Notifikasi',
  );
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
