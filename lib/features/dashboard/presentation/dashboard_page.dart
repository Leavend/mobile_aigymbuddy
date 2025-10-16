import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_state.dart';
import '../../../app/dependencies.dart';
import '../../exercise/domain/exercise.dart';
import '../../exercise/domain/exercise_repository.dart';
import '../../profile/domain/profile_repository.dart';
import '../../profile/domain/user_profile.dart';
import '../../tracking/domain/models.dart';
import '../../tracking/domain/tracking_repository.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
  late Future<List<WeeklyVolumePoint>> _weeklyVolumeFuture;

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

  Future<void> _loadExercises() async {
    final exercises = await _exerciseRepository.listExercises();
    if (!mounted) return;
    setState(() {
      _exercises = exercises;
      if (exercises.isNotEmpty) {
        _selectedExercise = exercises.first;
      }
    });
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

  Future<void> _addWeight() async {
    final value = double.tryParse(_weightController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan berat badan yang valid.')),
      );
      return;
    }

    setState(() => _addingWeight = true);
    try {
      await _trackingRepository.addBodyWeight(value);
      _weightController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berat badan tersimpan.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan berat badan: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _addingWeight = false);
      }
    }
  }

  Future<void> _logSet() async {
    final exercise = _selectedExercise;
    if (exercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data latihan belum siap.')),
      );
      return;
    }

    final setIndex = int.tryParse(_setIndexController.text.trim());
    if (setIndex == null || setIndex <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Index set harus lebih dari 0.')),
      );
      return;
    }

    final reps = _repsController.text.trim().isEmpty
        ? null
        : int.tryParse(_repsController.text.trim());
    if (_repsController.text.trim().isNotEmpty && reps == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reps harus berupa angka.')),
      );
      return;
    }

    final load = _loadController.text.trim().isEmpty
        ? null
        : double.tryParse(_loadController.text.trim());
    if (_loadController.text.trim().isNotEmpty && load == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beban harus berupa angka.')),
      );
      return;
    }

    setState(() => _loggingSet = true);
    try {
      await _trackingRepository.logManualSet(
        exerciseId: exercise.id,
        setIndex: setIndex,
        reps: reps,
        weight: load,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );
      if (!mounted) return;
      _repsController.clear();
      _loadController.clear();
      _noteController.clear();
      _setIndexController.text = '1';
      setState(() {
        _weeklyVolumeFuture = _trackingRepository.loadWeeklyVolume();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Latihan tersimpan.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan latihan: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _loggingSet = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Gym Buddy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profil',
            onPressed: () => context.push('/dashboard/profile/edit'),
          ),
        ],
      ),
      body: StreamBuilder<UserProfile?>(
        stream: _profileRepository.watchProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ProfileSummaryCard(profile: profile),
              const SizedBox(height: 24),
              WeightSection(
                controller: _weightController,
                addingWeight: _addingWeight,
                onAddWeight: _addWeight,
                weightStream: _trackingRepository.watchBodyWeight(),
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<WeeklyVolumePoint>>(
                future: _weeklyVolumeFuture,
                builder: (context, snapshot) {
                  return WeeklyVolumeCard(points: snapshot.data ?? const []);
                },
              ),
              const SizedBox(height: 24),
              WorkoutLogSection(
                exercises: _exercises,
                selectedExercise: _selectedExercise,
                onExerciseChanged: (exercise) =>
                    setState(() => _selectedExercise = exercise),
                setIndexController: _setIndexController,
                repsController: _repsController,
                loadController: _loadController,
                noteController: _noteController,
                loggingSet: _loggingSet,
                onSubmit: _logSet,
                logsStream: _trackingRepository.watchRecentSetLogs(limit: 30),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lengkapi profil Anda untuk mulai melacak kemajuan.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  AppStateScope.of(context).updateHasProfile(false);
                  context.go('/onboarding');
                },
                child: const Text('Buka Onboarding'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${profile!.name ?? 'Gym Buddy'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _InfoChip(label: 'Usia', value: '${profile!.age} tahun'),
                _InfoChip(
                  label: 'Tinggi',
                  value: '${profile!.heightCm.toStringAsFixed(1)} cm',
                ),
                _InfoChip(
                  label: 'Berat',
                  value: '${profile!.weightKg.toStringAsFixed(1)} kg',
                ),
                _InfoChip(
                    label: 'Gender', value: describeGender(profile!.gender)),
                _InfoChip(label: 'Target', value: describeGoal(profile!.goal)),
                _InfoChip(label: 'Level', value: describeLevel(profile!.level)),
                _InfoChip(label: 'Mode', value: describeMode(profile!.mode)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeightSection extends StatelessWidget {
  const WeightSection({
    super.key,
    required this.controller,
    required this.addingWeight,
    required this.onAddWeight,
    required this.weightStream,
  });

  final TextEditingController controller;
  final bool addingWeight;
  final VoidCallback onAddWeight;
  final Stream<List<BodyWeightEntry>> weightStream;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catat berat badan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
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
                  onPressed: addingWeight ? null : onAddWeight,
                  child: addingWeight
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<BodyWeightEntry>>(
              stream: weightStream,
              builder: (context, snapshot) {
                final points = snapshot.data ?? const [];
                if (points.isEmpty) {
                  return const Text('Belum ada data berat badan.');
                }
                return SizedBox(
                  height: 200,
                  child: WeightLineChart(points: points),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeightLineChart extends StatelessWidget {
  const WeightLineChart({super.key, required this.points});

  final List<BodyWeightEntry> points;

  @override
  Widget build(BuildContext context) {
    final sorted = [...points]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final start = sorted.first.timestamp;
    final spots = sorted
        .map(
          (point) => FlSpot(
            point.timestamp.difference(start).inDays.toDouble(),
            point.weightKg,
          ),
        )
        .toList();

    final minY = sorted.map((p) => p.weightKg).reduce((a, b) => a < b ? a : b);
    final maxY = sorted.map((p) => p.weightKg).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spots.isNotEmpty ? spots.last.x : 0,
        minY: minY - 1,
        maxY: maxY + 1,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval:
                  spots.length > 1 ? (spots.last.x / (spots.length - 1)) : 1,
              getTitlesWidget: (value, meta) {
                final date = start.add(Duration(days: value.toInt()));
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(DateFormat.Md().format(date),
                      style: Theme.of(context).textTheme.bodySmall),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

class WeeklyVolumeCard extends StatelessWidget {
  const WeeklyVolumeCard({super.key, required this.points});

  final List<WeeklyVolumePoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Belum ada volume latihan tercatat.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volume Latihan Mingguan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    for (var i = 0; i < points.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: points[i].totalVolume,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= points.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              points[value.toInt()].weekKey,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutLogSection extends StatelessWidget {
  const WorkoutLogSection({
    super.key,
    required this.exercises,
    required this.selectedExercise,
    required this.onExerciseChanged,
    required this.setIndexController,
    required this.repsController,
    required this.loadController,
    required this.noteController,
    required this.loggingSet,
    required this.onSubmit,
    required this.logsStream,
  });

  final List<ExerciseSummary> exercises;
  final ExerciseSummary? selectedExercise;
  final ValueChanged<ExerciseSummary?> onExerciseChanged;
  final TextEditingController setIndexController;
  final TextEditingController repsController;
  final TextEditingController loadController;
  final TextEditingController noteController;
  final bool loggingSet;
  final VoidCallback onSubmit;
  final Stream<List<WorkoutSetLog>> logsStream;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catatan Latihan Manual',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (exercises.isEmpty)
              const Text('Katalog latihan belum tersedia.'),
            if (exercises.isNotEmpty)
              DropdownButtonFormField<ExerciseSummary>(
                initialValue: selectedExercise,
                items: exercises
                    .map(
                      (exercise) => DropdownMenuItem(
                        value: exercise,
                        child: Text(exercise.name),
                      ),
                    )
                    .toList(),
                onChanged: onExerciseChanged,
                decoration: const InputDecoration(labelText: 'Pilih Latihan'),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setIndexController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Set ke-'),
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
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: loadController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Beban (kg)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Catatan'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed:
                    loggingSet || selectedExercise == null ? null : onSubmit,
                icon: loggingSet
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Simpan Latihan'),
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<WorkoutSetLog>>(
              stream: logsStream,
              builder: (context, snapshot) {
                final logs = snapshot.data ?? const [];
                if (logs.isEmpty) {
                  return const Text('Belum ada catatan latihan.');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Terbaru',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    for (final log in logs)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title:
                            Text('${log.exerciseName} - Set ${log.setIndex}'),
                        subtitle: Text(
                          _describeLog(log),
                        ),
                        trailing: Text(DateFormat('dd MMM')
                            .format(log.performedAt.toLocal())),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _describeLog(WorkoutSetLog log) {
    final parts = <String>[];
    if (log.reps != null) {
      parts.add('${log.reps} reps');
    }
    if (log.weight != null) {
      parts.add('${log.weight!.toStringAsFixed(1)} kg');
    }
    if (log.note != null && log.note!.isNotEmpty) {
      parts.add(log.note!);
    }
    return parts.isEmpty ? 'Tidak ada detail' : parts.join(' • ');
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
