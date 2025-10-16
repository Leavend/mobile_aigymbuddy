import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/progress_models.dart';
import '../../../domain/entities/weight_entry.dart';
import '../../app_scope.dart';
import '../../widgets/view_model_builder.dart';
import 'progress_view_model.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppScope.of(context);

    return ViewModelBuilder<ProgressViewModel>(
      create: () => ProgressViewModel(
        watchBodyWeightHistory: dependencies.watchBodyWeightHistory,
        watchRecentSessions: dependencies.watchRecentSessions,
        addBodyWeightEntry: dependencies.addBodyWeightEntry,
        getWeeklyVolume: dependencies.getWeeklyVolume,
      ),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Progress Latihan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_chart),
                onPressed: () => context.go('/home/log-session'),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: viewModel.isAddingWeight
                ? null
                : () async {
                    final weight = await showDialog<double>(
                      context: context,
                      builder: (context) => const _AddWeightDialog(),
                    );
                    if (weight != null) {
                      await viewModel.addBodyWeight(weight);
                    }
                  },
            icon: const Icon(Icons.monitor_weight),
            label: Text(viewModel.isAddingWeight ? 'Menyimpan...' : 'Tambah berat'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            children: [
              _WeightSummaryCard(entries: viewModel.weightHistory),
              const SizedBox(height: 16),
              _WeeklyVolumeCard(points: viewModel.weeklyVolume),
              const SizedBox(height: 16),
              _SessionList(summaries: viewModel.sessions),
              if (viewModel.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  viewModel.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _WeightSummaryCard extends StatelessWidget {
  const _WeightSummaryCard({required this.entries});

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    final latest = entries.isNotEmpty ? entries.last : null;
    final spots = <FlSpot>[];
    if (entries.length >= 2) {
      final firstDate = entries.first.recordedAt;
      for (final entry in entries) {
        final days = entry.recordedAt.difference(firstDate).inHours / 24;
        spots.add(FlSpot(days.toDouble(), entry.weightKg));
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Berat Badan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (latest != null)
                  Text(
                    '${latest.weightKg.toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (spots.isEmpty)
              const Text('Catat minimal dua data untuk melihat grafik.')
            else
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: spots.length > 1
                              ? (spots.last.x - spots.first.x) / (spots.length - 1)
                              : 1,
                          getTitlesWidget: (value, meta) => Text('${value.toInt()}d'),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        dotData: const FlDotData(show: false),
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyVolumeCard extends StatelessWidget {
  const _WeeklyVolumeCard({required this.points});

  final List<WeeklyVolumePoint> points;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volume Latihan 6 Minggu',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (points.isEmpty)
              const Text('Belum ada sesi latihan yang tercatat.')
            else
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: points
                    .map(
                      (point) => Chip(
                        label: Text('${point.weekKey}: ${point.totalVolume.toStringAsFixed(1)} kg'),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  const _SessionList({required this.summaries});

  final List<SessionSummary> summaries;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Riwayat Sesi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => context.go('/home/log-session'),
                  child: const Text('Log sesi baru'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (summaries.isEmpty)
              const Text('Belum ada sesi yang disimpan.')
            else
              ...summaries.map((session) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(session.title),
                  subtitle: Text(
                    'Volume: ${session.totalVolume.toStringAsFixed(1)} kg • Set: ${session.totalSets}',
                  ),
                  trailing: Text(
                    '${session.startedAt.hour.toString().padLeft(2, '0')}:${session.startedAt.minute.toString().padLeft(2, '0')}',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _AddWeightDialog extends StatefulWidget {
  const _AddWeightDialog();

  @override
  State<_AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<_AddWeightDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Catat berat badan'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Berat (kg)',
          ),
          validator: (value) {
            final parsed = double.tryParse(value ?? '');
            if (parsed == null || parsed <= 0) {
              return 'Masukkan angka yang valid';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() != true) {
              return;
            }
            Navigator.of(context).pop(double.parse(_controller.text));
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
