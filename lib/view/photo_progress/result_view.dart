import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../common/color_extension.dart';
import '../../common/date_time_utils.dart';
import '../../common_widget/round_button.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key, required this.date1, required this.date2});

  final DateTime date1;
  final DateTime date2;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  static const _photoComparisons = [
    _PhotoComparison(
      title: 'Front Facing',
      firstImagePath: 'assets/img/pp_1.png',
      secondImagePath: 'assets/img/pp_2.png',
    ),
    _PhotoComparison(
      title: 'Back Facing',
      firstImagePath: 'assets/img/pp_3.png',
      secondImagePath: 'assets/img/pp_4.png',
    ),
    _PhotoComparison(
      title: 'Left Facing',
      firstImagePath: 'assets/img/pp_5.png',
      secondImagePath: 'assets/img/pp_6.png',
    ),
    _PhotoComparison(
      title: 'Right Facing',
      firstImagePath: 'assets/img/pp_7.png',
      secondImagePath: 'assets/img/pp_8.png',
    ),
  ];

  static const _statistics = [
    _ProgressStatistic(title: 'Lose Weight', firstPercent: 33, secondPercent: 67),
    _ProgressStatistic(
      title: 'Height Increase',
      firstPercent: 88,
      secondPercent: 12,
    ),
    _ProgressStatistic(
      title: 'Muscle Mass Increase',
      firstPercent: 57,
      secondPercent: 43,
    ),
    _ProgressStatistic(title: 'Abs', firstPercent: 89, secondPercent: 11),
  ];

  _ResultTab _selectedTab = _ResultTab.photo;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: Container(
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/img/black_btn.png'),
          ),
        ),
        title: Text(
          'Result',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _shareResult(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/img/share.png'),
            ),
          ),
          IconButton(
            onPressed: _showMoreOptions,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/img/more_btn.png'),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            _buildTabSwitcher(media),
            const SizedBox(height: 20),
            if (_selectedTab == _ResultTab.photo) _buildPhotoTab(media),
            if (_selectedTab == _ResultTab.statistic)
              _buildStatisticTab(media),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher(Size media) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedAlign(
            alignment: _selectedTab == _ResultTab.photo
                ? Alignment.centerLeft
                : Alignment.centerRight,
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
                  child: TextButton(
                    onPressed: () => _selectTab(_ResultTab.photo),
                    child: Text(
                      'Photo',
                      style: TextStyle(
                        color: _selectedTab == _ResultTab.photo
                            ? TColor.white
                            : TColor.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectTab(_ResultTab.statistic),
                    child: Text(
                      'Statistic',
                      style: TextStyle(
                        color: _selectedTab == _ResultTab.statistic
                            ? TColor.white
                            : TColor.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTab(Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Average Progress',
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Good',
              style: TextStyle(
                color: Color(0xFF6DD570),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Stack(
          alignment: Alignment.center,
          children: [
            SimpleAnimationProgressBar(
              height: 20,
              width: media.width - 40,
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.transparent,
              ratio: 0.62,
              direction: Axis.horizontal,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 2),
              borderRadius: BorderRadius.circular(10),
              gradientColor: LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            Text('62%', style: TextStyle(color: TColor.white, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateTimeUtils.formatDate(widget.date1, pattern: 'MMMM'),
              style: TextStyle(
                color: TColor.gray,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              DateTimeUtils.formatDate(widget.date2, pattern: 'MMMM'),
              style: TextStyle(
                color: TColor.gray,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: _photoComparisons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final comparison = _photoComparisons[index];
            return Column(
              children: [
                Text(
                  comparison.title,
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _ProgressImage(path: comparison.firstImagePath),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _ProgressImage(path: comparison.secondImagePath),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        RoundButton(title: 'Back to Comparison', onPressed: () => context.pop()),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildStatisticTab(Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: media.width * 0.5,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              lineTouchData: _lineTouchData,
              lineBarsData: _lineBarsData,
              minY: -0.5,
              maxY: 110,
              titlesData: FlTitlesData(
                show: true,
                leftTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                rightTitles: AxisTitles(sideTitles: _rightTitles),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateTimeUtils.formatDate(widget.date1, pattern: 'MMMM'),
              style: TextStyle(
                color: TColor.gray,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              DateTimeUtils.formatDate(widget.date2, pattern: 'MMMM'),
              style: TextStyle(
                color: TColor.gray,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: _statistics.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final stat = _statistics[index];
            return Column(
              children: [
                Text(
                  stat.title,
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 35,
                      child: Text(
                        '${stat.firstPercent}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: TColor.gray, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: SimpleAnimationProgressBar(
                        height: 10,
                        width: media.width - 140,
                        backgroundColor: TColor.primaryColor1,
                        foregroundColor: const Color(0xffFFB2B1),
                        ratio: stat.firstRatio,
                        direction: Axis.horizontal,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(
                      width: 35,
                      child: Text(
                        '${stat.secondPercent}%',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: TColor.gray, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        RoundButton(title: 'Back to Comparison', onPressed: () => context.pop()),
        const SizedBox(height: 15),
      ],
    );
  }

  void _selectTab(_ResultTab tab) {
    if (_selectedTab == tab) {
      return;
    }
    setState(() => _selectedTab = tab);
  }

  void _shareResult(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Shared progress (demo).')),
      );
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('Save report'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Report saved (demo).')),
                    );
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reset chart'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _selectedTab = _ResultTab.photo);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  LineTouchData get _lineTouchData => LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots
              .map(
                (spot) => LineTooltipItem(
                  '${spot.x.toInt()} mins ago',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              .toList(),
        ),
      );

  List<LineChartBarData> get _lineBarsData => [
        LineChartBarData(
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
        ),
        LineChartBarData(
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              TColor.secondaryColor2.withValues(alpha: 0.5),
              TColor.secondaryColor1.withValues(alpha: 0.5),
            ],
          ),
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
        ),
      ];

  SideTitles get _rightTitles => SideTitles(
        showTitles: true,
        interval: 20,
        reservedSize: 40,
        getTitlesWidget: (value, _) {
          switch (value.toInt()) {
            case 0:
            case 20:
            case 40:
            case 60:
            case 80:
            case 100:
              return Text(
                '${value.toInt()}%',
                style: TextStyle(color: TColor.gray, fontSize: 12),
                textAlign: TextAlign.center,
              );
            default:
              return const SizedBox.shrink();
          }
        },
      );

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final style = TextStyle(color: TColor.gray, fontSize: 12);
          const labels = {
            1: 'Jan',
            2: 'Feb',
            3: 'Mar',
            4: 'Apr',
            5: 'May',
            6: 'Jun',
            7: 'Jul',
          };
          final label = labels[value.toInt()];
          if (label == null) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            meta: meta,
            space: 10,
            child: Text(label, style: style),
          );
        },
      );
}

enum _ResultTab { photo, statistic }

class _PhotoComparison {
  const _PhotoComparison({
    required this.title,
    required this.firstImagePath,
    required this.secondImagePath,
  });

  final String title;
  final String firstImagePath;
  final String secondImagePath;
}

class _ProgressStatistic {
  const _ProgressStatistic({
    required this.title,
    required this.firstPercent,
    required this.secondPercent,
  });

  final String title;
  final int firstPercent;
  final int secondPercent;

  double get firstRatio {
    final total = firstPercent + secondPercent;
    if (total == 0) {
      return 0;
    }
    return firstPercent / total;
  }
}

class _ProgressImage extends StatelessWidget {
  const _ProgressImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}
