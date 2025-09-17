// lib/view/photo_progress/result_view.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../common/color_extension.dart';
import '../../common/common.dart';
import '../../common_widget/round_button.dart';

class ResultView extends StatefulWidget {
  final DateTime date1;
  final DateTime date2;
  const ResultView({super.key, required this.date1, required this.date2});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  int selectButton = 0;

  final List<Map<String, String>> imaArr = const [
    {
      "title": "Front Facing",
      "month_1_image": "assets/img/pp_1.png",
      "month_2_image": "assets/img/pp_2.png",
    },
    {
      "title": "Back Facing",
      "month_1_image": "assets/img/pp_3.png",
      "month_2_image": "assets/img/pp_4.png",
    },
    {
      "title": "Left Facing",
      "month_1_image": "assets/img/pp_5.png",
      "month_2_image": "assets/img/pp_6.png",
    },
    {
      "title": "Right Facing",
      "month_1_image": "assets/img/pp_7.png",
      "month_2_image": "assets/img/pp_8.png",
    },
  ];

  final List<Map<String, String>> statArr = const [
    {"title": "Lose Weight", "diff_per": "33", "month_1_per": "33%", "month_2_per": "67%"},
    {"title": "Height Increase", "diff_per": "88", "month_1_per": "88%", "month_2_per": "12%"},
    {"title": "Muscle Mass Increase", "diff_per": "57", "month_1_per": "57%", "month_2_per": "43%"},
    {"title": "Abs", "diff_per": "89", "month_1_per": "89%", "month_2_per": "11%"},
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Result",
          style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)),
              child: Image.asset("assets/img/share.png", width: 15, height: 15, fit: BoxFit.contain),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)),
              child: Image.asset("assets/img/more_btn.png", width: 15, height: 15, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            // Toggle
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(30)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedAlign(
                    alignment: selectButton == 0 ? Alignment.centerLeft : Alignment.centerRight,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: (media.width * 0.5) - 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectButton = 0),
                            child: Text(
                              "Photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectButton == 0 ? TColor.white : TColor.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectButton = 1),
                            child: Text(
                              "Statistic",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectButton == 1 ? TColor.white : TColor.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== Photo Tab =====
            if (selectButton == 0) _buildPhotoTab(context, media),

            // ===== Statistic Tab =====
            if (selectButton == 1) _buildStatisticTab(context, media),
          ],
        ),
      ),
    );
  }

  // ---------------- Photo Tab ----------------
  Widget _buildPhotoTab(BuildContext context, Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Average Progress",
                style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
            const Text("Good",
                style: TextStyle(color: Color(0xFF6DD570), fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 15),

        // Progress Bar
        Stack(
          alignment: Alignment.center,
          children: [
            SimpleAnimationProgressBar(
              height: 20,
              width: media.width - 40,
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.purple,
              ratio: 0.62,
              direction: Axis.horizontal,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 3),
              borderRadius: BorderRadius.circular(10),
              gradientColor: LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            Text("62%", style: TextStyle(color: TColor.white, fontSize: 12)),
          ],
        ),

        const SizedBox(height: 15),

        // Month labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateToString(widget.date1, formatStr: "MMMM"),
                style: TextStyle(color: TColor.yellow, fontSize: 16, fontWeight: FontWeight.w700)),
            Text(dateToString(widget.date2, formatStr: "MMMM"),
                style: TextStyle(color: TColor.yellow, fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),

        // Images list
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: imaArr.length,
          itemBuilder: (context, index) {
            final iObj = imaArr[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(iObj["title"]!, style: TextStyle(color: TColor.yellow, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(iObj["month_1_image"]!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(iObj["month_2_image"]!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        // CTA
        const SizedBox(height: 16),
        RoundButton(title: "Back to Home", onPressed: () => Navigator.pop(context)),
        const SizedBox(height: 15),
      ],
    );
  }

  // ---------------- Statistic Tab ----------------
  Widget _buildStatisticTab(BuildContext context, Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line chart
        Container(
          padding: const EdgeInsets.only(left: 10),
          height: media.width * 0.5,
          width: double.maxFinite,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchCallback: (event, response) {}, // keep default interactions
                mouseCursorResolver: (event, response) =>
                    (response == null || response.lineBarSpots == null)
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes
                      .map(
                        (index) => TouchedSpotIndicatorData(
                          const FlLine(color: Colors.transparent),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, idx) => FlDotCirclePainter(
                              radius: 3,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: TColor.secondaryColor1,
                            ),
                          ),
                        ),
                      )
                      .toList();
                },
                // fl_chart 1.1.x: tanpa tooltipBgColor/tooltipRoundedRadius
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map(
                        (s) => LineTooltipItem(
                          "${s.x.toInt()} mins ago",
                          const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      )
                      .toList(),
                ),
              ),
              lineBarsData: lineBarsData1,
              minY: -0.5,
              maxY: 110,
              titlesData: FlTitlesData(
                show: true,
                leftTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(sideTitles: bottomTitles),
                rightTitles: AxisTitles(sideTitles: rightTitles),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 25,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: TColor.lightGray, strokeWidth: 2),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.transparent),
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Month labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateToString(widget.date1, formatStr: "MMMM"),
                style: TextStyle(color: TColor.yellow, fontSize: 16, fontWeight: FontWeight.w700)),
            Text(dateToString(widget.date2, formatStr: "MMMM"),
                style: TextStyle(color: TColor.yellow, fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),

        // Stats Bars
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: statArr.length,
          itemBuilder: (context, index) {
            final iObj = statArr[index];
            final ratio = (double.tryParse(iObj["diff_per"] ?? "0") ?? 0) / 100.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Text(iObj["title"]!,
                    style: TextStyle(color: TColor.yellow, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 25,
                      child: Text(iObj["month_1_per"]!,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: TColor.yellow, fontSize: 12)),
                    ),
                    SimpleAnimationProgressBar(
                      height: 10,
                      width: media.width - 120,
                      backgroundColor: TColor.primaryColor1,
                      foregroundColor: const Color(0xffFFB2B1),
                      ratio: ratio,
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    SizedBox(
                      width: 25,
                      child: Text(iObj["month_2_per"]!,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: TColor.yellow, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        // CTA
        const SizedBox(height: 16),
        RoundButton(title: "Back to Home", onPressed: () => Navigator.pop(context)),
        const SizedBox(height: 15),
      ],
    );
  }

  // ==== Chart Helpers ====

  List<LineChartBarData> get lineBarsData1 => [lineChartBarData1_1, lineChartBarData1_2];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: TColor.primaryG),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          TColor.secondaryColor2.withValues(alpha: 0.5),
          TColor.secondaryColor1.withValues(alpha: 0.5),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  // Right axis titles
  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    switch (value.toInt()) {
      case 0:
        return Text('0%', style: TextStyle(color: TColor.yellow, fontSize: 12), textAlign: TextAlign.center);
      case 20:
        return Text('20%', style: TextStyle(color: TColor.yellow, fontSize: 12), textAlign: TextAlign.center);
      case 40:
        return Text('40%', style: TextStyle(color: TColor.yellow, fontSize: 12), textAlign: TextAlign.center);
      case 60:
        return Text('60%', style: TextStyle(color: TColor.yellow, fontSize: 12), textAlign: TextAlign.center);
      case 80:
        return Text('80%', style: TextStyle(color: TColor.yellow, fontSize: 12), textAlign: TextAlign.center);
      case 100:
        return Text('100%', style: TextStyle(color: TColor.yellow, fontSize: 12), textAlign: TextAlign.center);
      default:
        return const SizedBox.shrink();
    }
  }

  // Bottom axis titles
  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(color: TColor.yellow, fontSize: 12);
    switch (value.toInt()) {
      case 1:
        return SideTitleWidget(meta: meta, space: 10, child: Text('Jan', style: style));
      case 2:
        return SideTitleWidget(meta: meta, space: 10, child: Text('Feb', style: style));
      case 3:
        return SideTitleWidget(meta: meta, space: 10, child: Text('Mar', style: style));
      case 4:
        return SideTitleWidget(meta: meta, space: 10, child: Text('Apr', style: style));
      case 5:
        return SideTitleWidget(meta: meta, space: 10, child: Text('May', style: style));
      case 6:
        return SideTitleWidget(meta: meta, space: 10, child: Text('Jun', style: style));
      case 7:
        return SideTitleWidget(meta: meta, space: 10, child: Text('Jul', style: style));
      default:
        return const SizedBox.shrink();
    }
  }
}
