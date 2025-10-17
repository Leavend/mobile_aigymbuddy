import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/date_time_utils.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import 'photo_progress_models.dart';
import 'photo_progress_sample_data.dart';
import 'photo_progress_strings.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key, required this.date1, required this.date2});

  final DateTime date1;
  final DateTime date2;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  _ResultTab _selectedTab = _ResultTab.photo;

  List<PhotoComparison> get _photoComparisons => samplePhotoComparisons;
  List<ProgressStatistic> get _statistics => sampleProgressStatistics;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final localize = context.localize;
    final language = context.appLanguage;

    return Scaffold(
      appBar: _buildAppBar(localize),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            _ResultTabSwitcher(
              media: media,
              selectedTab: _selectedTab,
              localize: localize,
              onChanged: _selectTab,
            ),
            const SizedBox(height: 20),
            if (_selectedTab == _ResultTab.photo)
              _PhotoComparisonTab(
                media: media,
                localize: localize,
                comparisons: _photoComparisons,
                firstDate: widget.date1,
                secondDate: widget.date2,
                onBack: () => context.pop(),
              ),
            if (_selectedTab == _ResultTab.statistic)
              _StatisticTab(
                media: media,
                localize: localize,
                statistics: _statistics,
                firstDate: widget.date1,
                secondDate: widget.date2,
                chartData: _chartData(language),
                onBack: () => context.pop(),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Localizer localize) {
    return AppBar(
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
        localize(ResultTexts.title),
        style: const TextStyle(
          color: Colors.black,
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
        SnackBar(content: Text(context.localize(ResultTexts.shareInfo))),
      );
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final localize = sheetContext.localize;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: Text(localize(ResultTexts.saveReport)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content:
                            Text(localize(ResultTexts.saveReportInfo)),
                      ),
                    );
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(localize(ResultTexts.resetChart)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  setState(() => _selectedTab = _ResultTab.photo);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  LineTouchData _lineTouchData(AppLanguage language) => LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots
              .map(
                (spot) => LineTooltipItem(
                  PhotoProgressLocalizationHelper.minutesAgo(
                    language,
                    spot.x.toInt(),
                  ),
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

  LineChartData _chartData(AppLanguage language) => LineChartData(
        lineTouchData: _lineTouchData(language),
        lineBarsData: _lineBarsData,
        minY: -0.5,
        maxY: 110,
        titlesData: FlTitlesData(
          show: true,
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: _bottomTitles(language),
          ),
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
      );

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

  SideTitles _bottomTitles(AppLanguage language) => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final style = TextStyle(color: TColor.gray, fontSize: 12);
          final label = PhotoProgressLocalizationHelper.monthShortLabel(
            language,
            value.toInt(),
          );
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

class _ResultTabSwitcher extends StatelessWidget {
  const _ResultTabSwitcher({
    required this.media,
    required this.selectedTab,
    required this.localize,
    required this.onChanged,
  });

  final Size media;
  final _ResultTab selectedTab;
  final Localizer localize;
  final ValueChanged<_ResultTab> onChanged;

  @override
  Widget build(BuildContext context) {
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
            alignment: selectedTab == _ResultTab.photo
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
                    onPressed: () => onChanged(_ResultTab.photo),
                    child: Text(
                      localize(ResultTexts.photoTab),
                      style: TextStyle(
                        color: selectedTab == _ResultTab.photo
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
                    onPressed: () => onChanged(_ResultTab.statistic),
                    child: Text(
                      localize(ResultTexts.statisticTab),
                      style: TextStyle(
                        color: selectedTab == _ResultTab.statistic
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
}

class _PhotoComparisonTab extends StatelessWidget {
  const _PhotoComparisonTab({
    required this.media,
    required this.localize,
    required this.comparisons,
    required this.firstDate,
    required this.secondDate,
    required this.onBack,
  });

  final Size media;
  final Localizer localize;
  final List<PhotoComparison> comparisons;
  final DateTime firstDate;
  final DateTime secondDate;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localize(ResultTexts.averageProgress),
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              localize(ResultTexts.progressStatusGood),
              style: const TextStyle(
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
        _ComparisonDateHeader(firstDate: firstDate, secondDate: secondDate),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: comparisons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final comparison = comparisons[index];
            return Column(
              children: [
                Text(
                  localize(comparison.title),
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
        RoundButton(
          title: localize(ResultTexts.backToComparison),
          onPressed: onBack,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class _StatisticTab extends StatelessWidget {
  const _StatisticTab({
    required this.media,
    required this.localize,
    required this.statistics,
    required this.firstDate,
    required this.secondDate,
    required this.chartData,
    required this.onBack,
  });

  final Size media;
  final Localizer localize;
  final List<ProgressStatistic> statistics;
  final DateTime firstDate;
  final DateTime secondDate;
  final LineChartData chartData;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: media.width * 0.5,
          width: double.infinity,
          child: LineChart(
            chartData,
          ),
        ),
        const SizedBox(height: 15),
        _ComparisonDateHeader(firstDate: firstDate, secondDate: secondDate),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: statistics.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final stat = statistics[index];
            return Column(
              children: [
                Text(
                  localize(stat.title),
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
        RoundButton(
          title: localize(ResultTexts.backToComparison),
          onPressed: onBack,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class _ComparisonDateHeader extends StatelessWidget {
  const _ComparisonDateHeader({
    required this.firstDate,
    required this.secondDate,
  });

  final DateTime firstDate;
  final DateTime secondDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateTimeUtils.formatDate(firstDate, pattern: 'MMMM'),
          style: TextStyle(
            color: TColor.gray,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          DateTimeUtils.formatDate(secondDate, pattern: 'MMMM'),
          style: TextStyle(
            color: TColor.gray,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
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
