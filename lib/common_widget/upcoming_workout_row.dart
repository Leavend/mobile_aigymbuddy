// lib/common_widget/upcoming_workout_row.dart

import 'package:aigymbuddy/common/color_extension.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

@immutable
class UpcomingWorkoutItem {
  const UpcomingWorkoutItem({
    required this.title,
    required this.timeLabel,
    required this.imageAsset,
  });

  factory UpcomingWorkoutItem.fromJson(Map<String, dynamic> json) {
    return UpcomingWorkoutItem(
      title: json['title']?.toString() ?? 'Workout',
      timeLabel: json['time']?.toString() ?? '',
      imageAsset: json['image']?.toString() ?? 'assets/img/placeholder.png',
    );
  }

  final String title;
  final String timeLabel;
  final String imageAsset;
}

class UpcomingWorkoutRow extends StatefulWidget {
  const UpcomingWorkoutRow({
    required this.workout, super.key,
    this.initialActive = false,
    this.onToggle,
  });

  factory UpcomingWorkoutRow.fromMap(
    Map<String, dynamic> map, {
    bool initialActive = false,
    ValueChanged<bool>? onToggle,
  }) {
    return UpcomingWorkoutRow(
      workout: UpcomingWorkoutItem.fromJson(map),
      initialActive: initialActive,
      onToggle: onToggle,
    );
  }

  final UpcomingWorkoutItem workout;
  final bool initialActive;
  final ValueChanged<bool>? onToggle;

  @override
  State<UpcomingWorkoutRow> createState() => _UpcomingWorkoutRowState();
}

class _UpcomingWorkoutRowState extends State<UpcomingWorkoutRow> {
  late bool _active;

  static const double _avatarSize = 50;
  static const double _gap = 15;
  static const double _toggleTrackHeight = 30;
  static const double _toggleIndicator = 30;
  static const double _indicatorDot = 10;

  @override
  void initState() {
    super.initState();
    _active = widget.initialActive;
  }

  @override
  Widget build(BuildContext context) {
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
            borderRadius: BorderRadius.circular(_avatarSize / 2),
            child: Image.asset(
              widget.workout.imageAsset,
              width: _avatarSize,
              height: _avatarSize,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: _gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workout.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.workout.timeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: TColor.gray, fontSize: 10),
                ),
              ],
            ),
          ),
          _buildGymBuddyToggle(
            current: _active,
            onChanged: (v) {
              setState(() => _active = v);
              widget.onToggle?.call(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGymBuddyToggle({
    required bool current,
    required ValueChanged<bool> onChanged,
  }) {
    return CustomAnimatedToggleSwitch<bool>(
      current: current,
      values: const [false, true],
      indicatorSize: const Size.square(_toggleIndicator),
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.linear,
      onChanged: onChanged,
      iconBuilder: (context, local, global) => const SizedBox(),
      cursors: const ToggleCursors(defaultCursor: SystemMouseCursors.click),
      onTap: (props) => onChanged(!current),
      iconsTappable: false,
      wrapperBuilder: (context, global, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              left: 10,
              right: 10,
              height: _toggleTrackHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.secondaryG),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
            child,
          ],
        );
      },
      foregroundIndicatorBuilder: (context, global) {
        return SizedBox.fromSize(
          size: const Size(_indicatorDot, _indicatorDot),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0.05,
                  blurRadius: 1.1,
                  offset: Offset(0, 0.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
