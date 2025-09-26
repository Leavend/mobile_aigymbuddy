// lib/view/sleep_tracker/sleep_add_alarm_view.dart

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/round_button.dart';

class SleepAddAlarmView extends StatefulWidget {
  final DateTime date;
  const SleepAddAlarmView({super.key, required this.date});

  @override
  State<SleepAddAlarmView> createState() => _SleepAddAlarmViewState();
}

class _SleepAddAlarmViewState extends State<SleepAddAlarmView> {
  bool _vibrateEnabled = false;

  @override
  Widget build(BuildContext context) {
    // final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Add Alarm",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            IconTitleNextRow(
              icon: "assets/img/Bed_Add.png",
              title: "Bedtime",
              time: "09:00 PM",
              color: TColor.lightGray,
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/HoursTime.png",
              title: "Hours of sleep",
              time: "8hours 30minutes",
              color: TColor.lightGray,
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/Repeat.png",
              title: "Repeat",
              time: "Mon to Fri",
              color: TColor.lightGray,
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            _buildVibrateTile(),
            const Spacer(),
            RoundButton(title: "Add", onPressed: () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVibrateTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: Image.asset(
                "assets/img/Vibrate.png",
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Vibrate When Alarm Sound",
              style: TextStyle(color: TColor.yellow, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 30,
            child: Transform.scale(
              scale: 0.7,
              child: CustomAnimatedToggleSwitch<bool>(
                current: _vibrateEnabled,
                values: const [false, true],
                spacing: 0.0, // was: dif
                indicatorSize: const Size.square(30.0),
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.linear,
                onChanged: (val) => setState(() => _vibrateEnabled = val),
                iconBuilder: (context, local, global) => const SizedBox(),
                // onTap signature pada ^0.8.5 menerima nilai yang diketuk
                onTap: (val) => setState(() => _vibrateEnabled = !_vibrateEnabled),
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
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
