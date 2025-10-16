import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/user_profile.dart';
import '../../app_scope.dart';
import '../../widgets/enum_selector.dart';
import '../../widgets/view_model_builder.dart';
import 'profile_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppScope.of(context);

    return ViewModelBuilder<ProfileViewModel>(
      create: () => ProfileViewModel(
        watchUserProfile: dependencies.watchUserProfile,
        upsertUserProfile: dependencies.upsertUserProfile,
      ),
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = viewModel.profile;
        if (profile == null) {
          return const Center(
            child: Text('Profil belum tersedia. Mulai onboarding terlebih dahulu.'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Kamu'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: viewModel.isSaving
                    ? null
                    : () async {
                        final updated = await showModalBottomSheet<UserProfile>(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => ProfileEditSheet(profile: profile),
                        );
                        if (updated != null) {
                          await viewModel.saveProfile(updated);
                        }
                      },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? 'Gym Buddy',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _ProfileChip(label: 'Usia', value: '${profile.age} th'),
                    _ProfileChip(label: 'Tinggi', value: '${profile.heightCm.toStringAsFixed(1)} cm'),
                    _ProfileChip(label: 'Berat', value: '${profile.weightKg.toStringAsFixed(1)} kg'),
                    _ProfileChip(label: 'Gender', value: profile.gender.label),
                    _ProfileChip(label: 'Level', value: profile.level.label),
                    _ProfileChip(label: 'Target', value: profile.goal.label),
                    _ProfileChip(label: 'Mode', value: profile.preferredMode.label),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Terakhir diperbarui: ${DateFormat.yMMMEd().format(profile.updatedAt.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (viewModel.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    viewModel.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
    );
  }
}

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  late Gender _gender;
  late FitnessGoal _goal;
  late ExperienceLevel _level;
  late WorkoutMode _mode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name ?? '');
    _ageController = TextEditingController(text: widget.profile.age.toString());
    _heightController =
        TextEditingController(text: widget.profile.heightCm.toStringAsFixed(1));
    _weightController =
        TextEditingController(text: widget.profile.weightKg.toStringAsFixed(1));
    _gender = widget.profile.gender;
    _goal = widget.profile.goal;
    _level = widget.profile.level;
    _mode = widget.profile.preferredMode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbarui Profil',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama panggilan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Usia',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Usia tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Tinggi (cm)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Tinggi tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Berat (kg)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Berat tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                EnumSelector<Gender>(
                  label: 'Gender',
                  value: _gender,
                  values: Gender.values,
                  toText: (value) => value.label,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: 12),
                EnumSelector<FitnessGoal>(
                  label: 'Target',
                  value: _goal,
                  values: FitnessGoal.values,
                  toText: (value) => value.label,
                  onChanged: (value) => setState(() => _goal = value),
                ),
                const SizedBox(height: 12),
                EnumSelector<ExperienceLevel>(
                  label: 'Level',
                  value: _level,
                  values: ExperienceLevel.values,
                  toText: (value) => value.label,
                  onChanged: (value) => setState(() => _level = value),
                ),
                const SizedBox(height: 12),
                EnumSelector<WorkoutMode>(
                  label: 'Mode',
                  value: _mode,
                  values: WorkoutMode.values,
                  toText: (value) => value.label,
                  onChanged: (value) => setState(() => _mode = value),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() != true) {
                      return;
                    }
                    final updated = widget.profile.copyWith(
                      name: _nameController.text.trim().isEmpty
                          ? null
                          : _nameController.text.trim(),
                      age: int.parse(_ageController.text),
                      heightCm: double.parse(_heightController.text),
                      weightKg: double.parse(_weightController.text),
                      gender: _gender,
                      goal: _goal,
                      level: _level,
                      preferredMode: _mode,
                      updatedAt: DateTime.now().toUtc(),
                    );
                    Navigator.of(context).pop(updated);
                  },
                  child: const Text('Simpan perubahan'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
