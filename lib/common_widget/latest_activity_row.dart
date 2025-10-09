import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class LatestActivityItem {
  const LatestActivityItem({
    required this.imageAsset,
    required this.title,
    required this.timeLabel,
  });

  factory LatestActivityItem.fromJson(Map<String, dynamic> json) {
    return LatestActivityItem(
      imageAsset: json['image']?.toString() ?? 'assets/img/placeholder.png',
      title: json['title']?.toString() ?? 'Activity',
      timeLabel: json['time']?.toString() ?? '',
    );
  }

  final String imageAsset;
  final String title;
  final String timeLabel;
}

class LatestActivityRow extends StatelessWidget {
  const LatestActivityRow({
    super.key,
    required this.activity,
    this.onMenuTap,
  });

  factory LatestActivityRow.fromMap(
    Map<String, dynamic> data, {
    VoidCallback? onMenuTap,
  }) {
    return LatestActivityRow(
      activity: LatestActivityItem.fromJson(data),
      onMenuTap: onMenuTap,
    );
  }

  final LatestActivityItem activity;
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
              activity.imageAsset,
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
                  activity.title,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity.timeLabel,
                  style: TextStyle(color: TColor.gray, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMenuTap,
            icon: Image.asset(
              'assets/img/sub_menu.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
