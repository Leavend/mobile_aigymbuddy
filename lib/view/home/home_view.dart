import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/dependencies.dart';
import '../../common/app_router.dart';
import '../shared/models/exercise.dart';
import '../shared/models/tracking.dart' as tracking_models;
import '../shared/models/user_profile.dart' as profile_domain;
import '../shared/repositories/exercise_repository.dart';
import '../shared/repositories/profile_repository.dart';
import '../shared/repositories/tracking_repository.dart';
import '../login/models/onboarding_draft.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ProfileRepository _profileRepository;
  late final TrackingRepository _trackingRepository;
  late final ExerciseRepository _exerciseRepository;

  final _weightController = TextEditingController();
  final _setIndexController = TextEditingController(text: '1');
  final _repsController = TextEditingController();
  final _loadController = TextEditingController();
  final _noteController = TextEditingController();

  bool _initialised = false;
  bool _addingWeight = false;
  bool _loggingSet = false;
  List<ExerciseSummary> _exercises = const [];
  ExerciseSummary? _selectedExercise;
  late Future<List<tracking_models.WeeklyVolumePoint>> _weeklyVolumeFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    final deps = AppDependencies.of(context);
    _profileRepository = deps.profileRepository;
    _trackingRepository = deps.trackingRepository;
    _exerciseRepository = deps.exerciseRepository;
    _weeklyVolumeFuture = _trackingRepository.loadWeeklyVolume();
    _loadExercises();
    _initialised = true;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _setIndexController.dispose();
    _repsController.dispose();
    _loadController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    final exercises = await _exerciseRepository.listExercises();
    if (!mounted) return;
    setState(() {
      _exercises = exercises;
      if (_selectedExercise == null && exercises.isNotEmpty) {
        _selectedExercise = exercises.first;
      }
    });
  }

  Future<void> _addWeight() async {
    final value = double.tryParse(_weightController.text.trim());
    if (value == null || value <= 0) {
      _showMessage('Masukkan berat badan yang valid.');
      return;
    }

    setState(() => _addingWeight = true);
    try {
      await _trackingRepository.addBodyWeight(value);
      _weightController.clear();
      _showMessage('Berat badan tersimpan.');
    } catch (error) {
      _showMessage('Gagal menyimpan berat badan: $error');
    } finally {
      if (mounted) {
        setState(() => _addingWeight = false);
      }
    }
  }

  Future<void> _logSet() async {
    final exercise = _selectedExercise;
    if (exercise == null) {
      _showMessage('Data latihan belum siap.');
      return;
    }

    final setIndex = int.tryParse(_setIndexController.text.trim());
    if (setIndex == null || setIndex <= 0) {
      _showMessage('Index set harus lebih dari 0.');
      return;
    }

    final repsText = _repsController.text.trim();
    final loadText = _loadController.text.trim();
    final reps = repsText.isEmpty ? null : int.tryParse(repsText);
    final weight = loadText.isEmpty ? null : double.tryParse(loadText);

    if (repsText.isNotEmpty && reps == null) {
      _showMessage('Reps harus berupa angka.');
      return;
    }
    if (loadText.isNotEmpty && weight == null) {
      _showMessage('Beban harus berupa angka.');
      return;
    }

    setState(() => _loggingSet = true);
    try {
      await _trackingRepository.logManualSet(
        exerciseId: exercise.id,
        setIndex: setIndex,
        reps: reps,
        weight: weight,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );
      _repsController.clear();
      _loadController.clear();
      _noteController.clear();
      _setIndexController.text = '1';
      setState(() {
        _weeklyVolumeFuture = _trackingRepository.loadWeeklyVolume();
      });
      _showMessage('Catatan latihan tersimpan.');
    } catch (error) {
      _showMessage('Gagal menyimpan latihan: $error');
    } finally {
      if (mounted) {
        setState(() => _loggingSet = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
    return Scaffold(
      appBar: AppBar(title: const Text('AI Gym Buddy')),
      body: StreamBuilder<profile_domain.UserProfile?>(
        stream: _profileRepository.watchProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _ProfileSummaryCard(
                  profile: profile,
                  onEdit: profile == null ? null : () => _startEdit(profile)),
              const SizedBox(height: 24),
              _WeightChartCard(
                weightStream: _trackingRepository.watchBodyWeight(),
                controller: _weightController,
                onAddWeight: _addWeight,
                isSaving: _addingWeight,
              ),
              const SizedBox(height: 24),
              _LogSetCard(
                exercises: _exercises,
                selectedExercise: _selectedExercise,
                onExerciseChanged: (exercise) =>
                    setState(() => _selectedExercise = exercise),
                setIndexController: _setIndexController,
                repsController: _repsController,
                loadController: _loadController,
                noteController: _noteController,
                onSubmit: _loggingSet ? null : _logSet,
                isSaving: _loggingSet,
              ),
              const SizedBox(height: 24),
              _RecentSetsCard(stream: _trackingRepository.watchRecentSetLogs()),
              const SizedBox(height: 24),
              _WeeklyVolumeCard(future: _weeklyVolumeFuture),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.profile, required this.onEdit});

  final profile_domain.UserProfile? profile;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    // FIX: Create a local variable to allow type promotion for null safety.
    final p = profile;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        // Use the local variable `p` for the null check.
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
                    // Now you can safely access properties on `p`.
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
  final VoidCallback onAddWeight;
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
                  onPressed: isSaving ? null : onAddWeight,
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
  final VoidCallback? onSubmit;
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
              'Catat Latihan Manual',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExerciseSummary>(
              value: selectedExercise,
              decoration: const InputDecoration(labelText: 'Pilih latihan'),
              items: exercises
                  .map(
                    (exercise) => DropdownMenuItem<ExerciseSummary>(
                      value: exercise,
                      child: Text(exercise.name),
                    ),
                  )
                  .toList(),
              onChanged: onExerciseChanged,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setIndexController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Set ke'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps'),
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
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration:
                  const InputDecoration(labelText: 'Catatan (opsional)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onSubmit,
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan Latihan'),
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
