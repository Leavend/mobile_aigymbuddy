import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/latest_activity_row.dart';
import '../../common_widget/today_target_cell.dart';

class ActivityTrackerView extends StatefulWidget {
  const ActivityTrackerView({super.key});

  @override
  State<ActivityTrackerView> createState() => _ActivityTrackerViewState();
}

class _ActivityTrackerViewState extends State<ActivityTrackerView> {
  static const _periodOptions = ['Weekly', 'Monthly'];

  int _touchedBarIndex = -1;
  String _selectedPeriod = _periodOptions.first;

  final List<Map<String, String>> _latestActivities = const [
    {
      'image': 'assets/img/pic_4.png',
      'title': 'Drinking 300ml Water',
      'time': 'About 1 minutes ago',
    },
    {
      'image': 'assets/img/pic_5.png',
      'title': 'Eat Snack (Fitbar)',
      'time': 'About 3 hours ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final spacing = media.width * 0.05;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          children: [
            _buildTodayTarget(),
            SizedBox(height: media.width * 0.1),
            _buildProgressHeader(),
            SizedBox(height: spacing),
            _buildBarChart(media),
            SizedBox(height: spacing),
            _buildLatestWorkoutHeader(),
            _buildLatestActivityList(),
            SizedBox(height: media.width * 0.1),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: _CircleIconButton(
        asset: 'assets/img/black_btn.png',
        onTap: () => context.pop(),
      ),
      title: Text(
        'Activity Tracker',
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: const [_CircleIconButton(asset: 'assets/img/more_btn.png')],
    );
  }

  Widget _buildTodayTarget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withValues(alpha: 0.3),
            TColor.primaryColor1.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today Target',
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: TColor.primaryG),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textColor: Colors.white,
                    elevation: 0,
                    child: const Icon(Icons.add, size: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              Expanded(
                child: TodayTargetCell(
                  icon: 'assets/img/water.png',
                  value: '8L',
                  title: 'Water Intake',
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: TodayTargetCell(
                  icon: 'assets/img/foot.png',
                  value: '2400',
                  title: 'Foot Steps',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Activity  Progress',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.primaryG),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              items: _periodOptions
                  .map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(
                        name,
                        style: TextStyle(color: TColor.gray, fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null || value == _selectedPeriod) {
                  return;
                }
                setState(() => _selectedPeriod = value);
              },
              icon: Icon(Icons.expand_more, color: TColor.white),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(Size media) {
    return Container(
      height: media.width * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.grey,
              tooltipHorizontalAlignment: FLHorizontalAlignment.right,
              tooltipMargin: 10,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final labels = const [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday',
                ];
                final weekDay = (group.x >= 0 && group.x < labels.length)
                    ? labels[group.x]
                    : '';

                return BarTooltipItem(
                  '$weekDay\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: (rod.toY - 1).toString(),
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response?.spot == null) {
                  _touchedBarIndex = -1;
                  return;
                }
                _touchedBarIndex = response!.spot!.touchedBarGroupIndex;
              });
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _buildBottomTitle,
                reservedSize: 38,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  Widget _buildLatestWorkoutHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Latest Workout',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'See More',
            style: TextStyle(
              color: TColor.gray,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLatestActivityList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _latestActivities.length,
      itemBuilder: (context, index) {
        final data = Map<String, dynamic>.from(_latestActivities[index]);
        return LatestActivityRow.fromMap(data);
      },
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final style = TextStyle(
      color: TColor.gray,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final idx = value.toInt();
    final text = (idx >= 0 && idx < labels.length) ? labels[idx] : '';
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> _buildBarGroups() => List.generate(7, (index) {
    switch (index) {
      case 0:
        return _buildGroupData(
          0,
          5,
          TColor.primaryG,
          isTouched: index == _touchedBarIndex,
        );
      case 1:
        return _buildGroupData(
          1,
          10.5,
          TColor.secondaryG,
          isTouched: index == _touchedBarIndex,
        );
      case 2:
        return _buildGroupData(
          2,
          5,
          TColor.primaryG,
          isTouched: index == _touchedBarIndex,
        );
      case 3:
        return _buildGroupData(
          3,
          7.5,
          TColor.secondaryG,
          isTouched: index == _touchedBarIndex,
        );
      case 4:
        return _buildGroupData(
          4,
          15,
          TColor.primaryG,
          isTouched: index == _touchedBarIndex,
        );
      case 5:
        return _buildGroupData(
          5,
          5.5,
          TColor.secondaryG,
          isTouched: index == _touchedBarIndex,
        );
      case 6:
        return _buildGroupData(
          6,
          8.5,
          TColor.primaryG,
          isTouched: index == _touchedBarIndex,
        );
      default:
        throw StateError('Invalid index $index');
    }
  });

  BarChartGroupData _buildGroupData(
    int x,
    double y,
    List<Color> barColor, {
    bool isTouched = false,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(
            colors: barColor,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: TColor.lightGray,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.asset, this.onTap});

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
