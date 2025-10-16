import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/progress_models.dart';
import '../../../domain/entities/user_profile.dart';
import '../../app_scope.dart';
import '../../widgets/enum_selector.dart';
import '../../widgets/view_model_builder.dart';
import 'log_session_view_model.dart';

class LogSessionPage extends StatefulWidget {
  const LogSessionPage({super.key, this.initialNote});

  final String? initialNote;

  @override
  State<LogSessionPage> createState() => _LogSessionPageState();
}

class _LogSessionPageState extends State<LogSessionPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _exerciseController = TextEditingController();
  final _setIndexController = TextEditingController(text: '1');
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _setNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.initialNote ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _exerciseController.dispose();
    _setIndexController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _setNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = AppScope.of(context);

    return ViewModelBuilder<LogSessionViewModel>(
      create: () => LogSessionViewModel(
        startSession: dependencies.startSession,
        addSetToSession: dependencies.addSetToSession,
        finishSession: dependencies.finishSession,
        watchSessionSets: dependencies.watchSessionSets,
        getUserProfile: dependencies.getUserProfile,
      ),
      builder: (context, viewModel) {
        if (_titleController.text != viewModel.title) {
          _titleController.text = viewModel.title;
        }
        if (viewModel.note != null && _noteController.text != viewModel.note) {
          _noteController.text = viewModel.note!;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Log Sesi Latihan'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _SessionConfigSection(
                viewModel: viewModel,
                titleController: _titleController,
                noteController: _noteController,
              ),
              const SizedBox(height: 24),
              if (viewModel.isSessionActive) ...[
                _SetInputSection(
                  viewModel: viewModel,
                  exerciseController: _exerciseController,
                  setIndexController: _setIndexController,
                  repsController: _repsController,
                  weightController: _weightController,
                  noteController: _setNoteController,
                ),
                const SizedBox(height: 24),
                _LoggedSetsList(sets: viewModel.sets),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final finished =
                              await viewModel.finishCurrentSession(finalNote: _noteController.text);
                          if (!mounted) return;
                          if (finished) {
                            context.pop();
                          }
                        },
                  icon: const Icon(Icons.flag),
                  label: Text(viewModel.isLoading ? 'Menyimpan...' : 'Selesai'),
                ),
              ] else ...[
                FilledButton.icon(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          viewModel.title = _titleController.text;
                          viewModel.note = _noteController.text.isEmpty ? null : _noteController.text;
                          final started = await viewModel.startNewSession();
                          if (!mounted) return;
                          if (!started && viewModel.error != null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(viewModel.error!)));
                          }
                        },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(viewModel.isLoading ? 'Memulai...' : 'Mulai Sesi'),
                ),
              ],
              if (viewModel.error != null && viewModel.isSessionActive) ...[
                const SizedBox(height: 12),
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

class _SessionConfigSection extends StatelessWidget {
  const _SessionConfigSection({
    required this.viewModel,
    required this.titleController,
    required this.noteController,
  });

  final LogSessionViewModel viewModel;
  final TextEditingController titleController;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Sesi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul sesi',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => viewModel.title = value,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) =>
                  viewModel.note = value.trim().isEmpty ? null : value.trim(),
            ),
            const SizedBox(height: 12),
            EnumSelector<FitnessGoal>(
              label: 'Target',
              value: viewModel.selectedGoal,
              values: FitnessGoal.values,
              toText: (value) => value.label,
              onChanged: viewModel.setGoal,
            ),
            const SizedBox(height: 12),
            EnumSelector<ExperienceLevel>(
              label: 'Level',
              value: viewModel.selectedLevel,
              values: ExperienceLevel.values,
              toText: (value) => value.label,
              onChanged: viewModel.setLevel,
            ),
            const SizedBox(height: 12),
            EnumSelector<WorkoutMode>(
              label: 'Mode',
              value: viewModel.selectedMode,
              values: WorkoutMode.values,
              toText: (value) => value.label,
              onChanged: viewModel.setMode,
            ),
          ],
        ),
      ),
    );
  }
}

class _SetInputSection extends StatelessWidget {
  const _SetInputSection({
    required this.viewModel,
    required this.exerciseController,
    required this.setIndexController,
    required this.repsController,
    required this.weightController,
    required this.noteController,
  });

  final LogSessionViewModel viewModel;
  final TextEditingController exerciseController;
  final TextEditingController setIndexController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Set',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: exerciseController,
              decoration: const InputDecoration(
                labelText: 'Nama latihan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setIndexController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Set ke-',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Bobot (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan set',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final exercise = exerciseController.text.trim();
                      if (exercise.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Isi nama latihan terlebih dahulu.')),
                        );
                        return;
                      }
                      final setIndex = int.tryParse(setIndexController.text) ?? 1;
                      final reps = int.tryParse(repsController.text);
                      final weight = double.tryParse(weightController.text);
                      final success = await viewModel.addSet(
                        exerciseName: exercise,
                        setIndex: setIndex,
                        reps: reps,
                        weight: weight,
                        note: noteController.text.trim().isEmpty
                            ? null
                            : noteController.text.trim(),
                      );
                      if (success) {
                        setIndexController.text = (setIndex + 1).toString();
                        repsController.clear();
                        weightController.clear();
                        noteController.clear();
                      } else if (viewModel.error != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(viewModel.error!)));
                      }
                    },
              icon: const Icon(Icons.add),
              label: Text(viewModel.isLoading ? 'Menyimpan...' : 'Simpan set'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedSetsList extends StatelessWidget {
  const _LoggedSetsList({required this.sets});

  final List<LoggedSet> sets;

  @override
  Widget build(BuildContext context) {
    if (sets.isEmpty) {
      return const Text('Belum ada set yang dicatat.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Tercatat',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...sets.map((set) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${set.exerciseName} • Set ${set.setIndex}'),
              subtitle: Text(
                [
                  if (set.reps != null) 'Reps: ${set.reps}',
                  if (set.weight != null) 'Bobot: ${set.weight!.toStringAsFixed(1)} kg',
                  if (set.note != null && set.note!.isNotEmpty) 'Catatan: ${set.note}',
                ].join(' • '),
              ),
            )),
      ],
    );
  }
}
