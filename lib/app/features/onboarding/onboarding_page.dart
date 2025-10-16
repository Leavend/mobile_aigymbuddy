import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/user_profile.dart';
import '../../app_scope.dart';
import '../../widgets/enum_selector.dart';
import '../../widgets/view_model_builder.dart';
import 'onboarding_view_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

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
    final dependencies = AppScope.of(context);

    return ViewModelBuilder<OnboardingViewModel>(
      create: () => OnboardingViewModel(
        upsertUserProfile: dependencies.upsertUserProfile,
        sessionController: dependencies.sessionController,
      ),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(title: const Text('Mari Kenalan')), 
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'AI Gym Buddy',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Lengkapi profil untuk rekomendasi latihan yang lebih personal.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nama panggilan (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: viewModel.setName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Usia (tahun)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Masukkan usia yang valid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null) {
                      viewModel.updateAge(parsed);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Tinggi badan (cm)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Masukkan tinggi yang valid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      viewModel.updateHeight(parsed);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Berat badan (kg)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Masukkan berat yang valid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      viewModel.updateWeight(parsed);
                    }
                  },
                ),
                const SizedBox(height: 24),
                EnumSelector<Gender>(
                  label: 'Jenis kelamin',
                  value: viewModel.gender,
                  values: Gender.values,
                  toText: (value) => value.label,
                  onChanged: viewModel.updateGender,
                ),
                const SizedBox(height: 16),
                EnumSelector<FitnessGoal>(
                  label: 'Target latihan utama',
                  value: viewModel.goal,
                  values: FitnessGoal.values,
                  toText: (value) => value.label,
                  onChanged: viewModel.updateGoal,
                ),
                const SizedBox(height: 16),
                EnumSelector<ExperienceLevel>(
                  label: 'Level pengalaman',
                  value: viewModel.level,
                  values: ExperienceLevel.values,
                  toText: (value) => value.label,
                  onChanged: viewModel.updateLevel,
                ),
                const SizedBox(height: 16),
                EnumSelector<WorkoutMode>(
                  label: 'Preferensi latihan',
                  value: viewModel.preferredMode,
                  values: WorkoutMode.values,
                  toText: (value) => value.label,
                  onChanged: viewModel.updateMode,
                ),
                const SizedBox(height: 24),
                if (viewModel.errorMessage != null) ...[
                  Text(
                    viewModel.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton.icon(
                  onPressed: viewModel.isSaving
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() != true) {
                            return;
                          }
                          final success = await viewModel.submit();
                          if (!mounted) return;
                          if (success) {
                            if (!mounted) return;
                            context.go('/home');
                          }
                        },
                  icon: viewModel.isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(viewModel.isSaving ? 'Menyimpan...' : 'Mulai'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

