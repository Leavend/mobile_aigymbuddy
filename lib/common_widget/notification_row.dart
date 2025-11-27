import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

@immutable
class NotificationItem {
  const NotificationItem({
    required this.imageAsset,
    required this.title,
    required this.timestampLabel,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      imageAsset: json['image']?.toString() ?? 'assets/img/placeholder.png',
      title: json['title']?.toString() ?? 'Notification',
      timestampLabel: json['time']?.toString() ?? '',
    );
  }

  final String imageAsset;
  final String title;
  final String timestampLabel;
}

class NotificationRow extends StatelessWidget {
  const NotificationRow({
    required this.notification, super.key,
    this.onMenuTap,
  });

  factory NotificationRow.fromMap(
    Map<String, dynamic> data, {
    VoidCallback? onMenuTap,
  }) {
    return NotificationRow(
      notification: NotificationItem.fromJson(data),
      onMenuTap: onMenuTap,
    );
  }

  final NotificationItem notification;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              notification.imageAsset,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  notification.timestampLabel,
                  style: const TextStyle(color: TColor.gray, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMenuTap,
            icon: Image.asset(
              'assets/img/sub_menu.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
