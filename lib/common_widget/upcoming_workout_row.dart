// lib/common_widget/upcoming_workout_row.dart

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class UpcomingWorkoutRow extends StatefulWidget {
  const UpcomingWorkoutRow({
    super.key,
    required this.wObj,
    this.initialActive = false,
    this.onToggle,
  });

  final Map<String, dynamic> wObj;

  /// Initial toggle value.
  final bool initialActive;

  /// Callback when toggle changes.
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
    final String title = (widget.wObj['title'] ?? '').toString();
    final String time = (widget.wObj['time'] ?? '').toString();
    final String imagePath = (widget.wObj['image'] ?? '').toString();

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
              imagePath.isNotEmpty ? imagePath : 'assets/img/placeholder.png',
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
                // Title
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Time
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TColor.yellow,
                    fontSize: 10,
                  ),
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

  /// Extracted toggle builder (DRY & reusable).
  Widget _buildGymBuddyToggle({
    required bool current,
    required ValueChanged<bool> onChanged,
  }) {
    return CustomAnimatedToggleSwitch<bool>(
      current: current,
      values: const [false, true],
      spacing: 0.0, // (was 'dif' in older versions)
      indicatorSize: const Size.square(_toggleIndicator),
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.linear,
      onChanged: onChanged,
      iconBuilder: (context, local, global) => const SizedBox(),
      // (was 'defaultCursor' param) now provided via cursors:
      cursors: const ToggleCursors(defaultCursor: SystemMouseCursors.click),
      // TapCallback<bool> requires props arg:
      onTap: (props) => onChanged(!current),
      iconsTappable: false,
      wrapperBuilder: (context, global, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Gradient track
            Positioned(
              left: 10.0,
              right: 10.0,
              height: _toggleTrackHeight,
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
          size: const Size(_indicatorDot, _indicatorDot),
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
}
