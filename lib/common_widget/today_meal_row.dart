import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/date_time_utils.dart';
import 'package:flutter/material.dart';

class TodayMealRow extends StatelessWidget {
  const TodayMealRow({
    required this.name, required this.imageAsset, required this.scheduledAt, super.key,
    this.onReminderTap,
  });

  factory TodayMealRow.fromMap(Map<String, String> data) {
    final rawTime = data['time'];
    final parsedTime = _tryParseScheduledAt(rawTime);

    return TodayMealRow(
      name: data['name'] ?? 'Unknown Meal',
      imageAsset: data['image'] ?? 'assets/img/m_1.png',
      scheduledAt: parsedTime,
    );
  }

  final String name;
  final String imageAsset;
  final DateTime scheduledAt;
  final VoidCallback? onReminderTap;

  @override
  Widget build(BuildContext context) {
    final relativeDay = scheduledAt.relativeDayLabel;
    final formattedTime = DateTimeUtils.formatDate(
      scheduledAt,
      pattern: 'h:mm aa',
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              imageAsset,
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
                  name,
                  style: const TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$relativeDay | $formattedTime',
                  style: const TextStyle(color: TColor.gray, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onReminderTap,
            icon: Image.asset('assets/img/bell.png', width: 25, height: 25),
          ),
        ],
      ),
    );
  }
}

DateTime _tryParseScheduledAt(String? rawTime) {
  if (rawTime == null || rawTime.isEmpty) {
    return DateTime.now();
  }

  try {
    return DateTimeUtils.parseDate(rawTime, pattern: 'dd/MM/yyyy hh:mm aa');
  } on FormatException {
    return DateTime.now();
  }
}
