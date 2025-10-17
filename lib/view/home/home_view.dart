import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/dependencies.dart';
import '../../common/app_router.dart';
import '../login/models/onboarding_draft.dart';
import '../shared/models/exercise.dart';
import '../shared/models/tracking.dart' as tracking_models;
import '../shared/models/user_profile.dart' as profile_domain;
import 'home_action_result.dart';
import 'home_controller.dart';
import 'home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _weightController = TextEditingController();
  final _setIndexController = TextEditingController(text: '1');
  final _repsController = TextEditingController();
  final _loadController = TextEditingController();
  final _noteController = TextEditingController();

  late HomeController _controller;
  bool _controllerInitialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllerInitialised) return;
    final deps = AppDependencies.of(context);
    _controller = HomeController.fromContext(deps);
    _controller.initialize();
    _controllerInitialised = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    _weightController.dispose();
    _setIndexController.dispose();
    _repsController.dispose();
    _loadController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleAddWeight() async {
    final HomeActionResult result =
        await _controller.addBodyWeight(_weightController.text);
    if (!mounted) return;
    _showMessage(result.message);
    if (result.shouldResetForm) {
      _weightController.clear();
    }
  }

  Future<void> _handleLogSet() async {
    final HomeActionResult result = await _controller.logManualSet(
      setIndex: _setIndexController.text,
      reps: _repsController.text,
      weight: _loadController.text,
      note: _noteController.text,
    );
    if (!mounted) return;
    _showMessage(result.message);
    if (result.shouldResetForm) {
      _repsController.clear();
      _loadController.clear();
      _noteController.clear();
      _setIndexController.text = '1';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _startEdit(profile_domain.UserProfile profile) {
    final draft = OnboardingDraft.fromProfile(profile);
    final args = ProfileFormArguments(
      draft: draft,
      mode: ProfileFormMode.edit,
    );
    context.push(AppRoute.completeProfile, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controllerInitialised) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final HomeState state = _controller.state;
        return Scaffold(
          appBar: AppBar(title: const Text('AI Gym Buddy')),
          body: RefreshIndicator(
            onRefresh: _controller.refreshData,
            child: StreamBuilder<profile_domain.UserProfile?>(
              stream: _controller.profileRepository.watchProfile(),
              builder: (context, snapshot) {
                final profile = snapshot.data;

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    _ProfileSummaryCard(
                      profile: profile,
                      onEdit:
                          profile == null ? null : () => _startEdit(profile),
                    ),
                    const SizedBox(height: 24),
                    _WeightChartCard(
                      weightStream:
                          _controller.trackingRepository.watchBodyWeight(),
                      controller: _weightController,
                      onAddWeight:
                          state.isAddingWeight ? null : _handleAddWeight,
                      isSaving: state.isAddingWeight,
                    ),
                    const SizedBox(height: 24),
                    _LogSetCard(
                      exercises: state.exercises,
                      selectedExercise: state.selectedExercise,
                      onExerciseChanged: _controller.selectExercise,
                      setIndexController: _setIndexController,
                      repsController: _repsController,
                      loadController: _loadController,
                      noteController: _noteController,
                      onSubmit: state.isLoggingSet ? null : _handleLogSet,
                      isSaving: state.isLoggingSet,
                    ),
                    const SizedBox(height: 24),
                    _RecentSetsCard(
                      stream: _controller.trackingRepository.watchRecentSetLogs(),
                    ),
                    const SizedBox(height: 24),
                    _WeeklyVolumeCard(future: state.weeklyVolumeFuture),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.profile, required this.onEdit});

  final profile_domain.UserProfile? profile;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final p = profile;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: p == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat datang! Lengkapi profilmu untuk rekomendasi yang lebih akurat.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go(AppRoute.onboarding),
                    child: const Text('Mulai Lengkapi Profil'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name ?? 'Gym Buddy',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${profile_domain.describeGoal(p.goal)} • ${profile_domain.describeLevel(p.level)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profil'),
                  ),
                ],
              ),
      ),
    );
  }
}

class _WeightChartCard extends StatelessWidget {
  const _WeightChartCard({
    required this.weightStream,
    required this.controller,
    required this.onAddWeight,
    required this.isSaving,
  });

  final Stream<List<tracking_models.BodyWeightEntry>> weightStream;
  final TextEditingController controller;
  final Future<void> Function()? onAddWeight;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perkembangan Berat Badan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: StreamBuilder<List<tracking_models.BodyWeightEntry>>(
                stream: weightStream,
                builder: (context, snapshot) {
                  final entries = snapshot.data ?? const [];
                  if (entries.isEmpty) {
                    return const Center(
                      child: Text('Belum ada data berat badan.'),
                    );
                  }

                  final spots = _mapToSpots(entries);
                  final minY = entries
                          .map((e) => e.weightKg)
                          .reduce((a, b) => a < b ? a : b) -
                      1;
                  final maxY = entries
                          .map((e) => e.weightKg)
                          .reduce((a, b) => a > b ? a : b) +
                      1;

                  return LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: maxY,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 42),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= entries.length) {
                                return const SizedBox.shrink();
                              }
                              final entry = entries[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(DateFormat('dd/MM')
                                    .format(entry.timestamp.toLocal())),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color: Theme.of(context).colorScheme.primary,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Berat badan (kg)',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          onAddWeight?.call();
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _mapToSpots(List<tracking_models.BodyWeightEntry> entries) {
    return entries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weightKg);
    }).toList();
  }
}

class _LogSetCard extends StatelessWidget {
  const _LogSetCard({
    required this.exercises,
    required this.selectedExercise,
    required this.onExerciseChanged,
    required this.setIndexController,
    required this.repsController,
    required this.loadController,
    required this.noteController,
    required this.onSubmit,
    required this.isSaving,
  });

  final List<ExerciseSummary> exercises;
  final ExerciseSummary? selectedExercise;
  final ValueChanged<ExerciseSummary?> onExerciseChanged;
  final TextEditingController setIndexController;
  final TextEditingController repsController;
  final TextEditingController loadController;
  final TextEditingController noteController;
  final Future<void> Function()? onSubmit;
  final bool isSaving;

  bool get _isFormEnabled => exercises.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catat Latihan Manual',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExerciseSummary>(
              value: _isFormEnabled ? selectedExercise : null,
              decoration: const InputDecoration(labelText: 'Pilih latihan'),
              disabledHint: const Text('Latihan belum tersedia'),
              items: exercises
                  .map((exercise) => DropdownMenuItem(
                        value: exercise,
                        child: Text(exercise.name),
                      ))
                  .toList(),
              onChanged: _isFormEnabled ? onExerciseChanged : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setIndexController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Set ke-'),
                    enabled: _isFormEnabled,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    enabled: _isFormEnabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: loadController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Beban (kg)'),
              enabled: _isFormEnabled,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Catatan tambahan'),
              enabled: _isFormEnabled,
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: !_isFormEnabled || isSaving
                    ? null
                    : () {
                        onSubmit?.call();
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan Catatan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSetsCard extends StatelessWidget {
  const _RecentSetsCard({required this.stream});

  final Stream<List<tracking_models.WorkoutSetLog>> stream;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat Latihan Terakhir',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<tracking_models.WorkoutSetLog>>(
              stream: stream,
              builder: (context, snapshot) {
                final logs = snapshot.data ?? const [];
                if (logs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Belum ada catatan latihan.'),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final subtitle = _buildSubtitle(log);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(log.exerciseName),
                      subtitle: Text(subtitle),
                      trailing: Text(DateFormat('dd MMM')
                          .format(log.performedAt.toLocal())),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(tracking_models.WorkoutSetLog log) {
    final buffer = StringBuffer('Set ${log.setIndex}');
    if (log.reps != null) {
      buffer.write(' • ${log.reps} reps');
    }
    if (log.weight != null) {
      buffer.write(' @ ${log.weight} kg');
    }
    if (log.note != null && log.note!.isNotEmpty) {
      buffer.write(' — ${log.note}');
    }
    return buffer.toString();
  }
}

class _WeeklyVolumeCard extends StatelessWidget {
  const _WeeklyVolumeCard({required this.future});

  final Future<List<tracking_models.WeeklyVolumePoint>> future;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volume Latihan Mingguan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<tracking_models.WeeklyVolumePoint>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final points = snapshot.data ?? const [];
                if (points.isEmpty) {
                  return const Text('Belum ada data volume latihan.');
                }

                return Column(
                  children: points.map((point) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Minggu ${point.weekKey}'),
                      trailing: Text(point.totalVolume.toStringAsFixed(1)),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
