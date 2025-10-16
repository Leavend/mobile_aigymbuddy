// lib/features/profile/presentation/profile_form_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_state.dart';
import '../../../app/dependencies.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key, required this.isEditing});

  final bool isEditing;

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileRepository _repository;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  Gender _selectedGender = Gender.other;
  FitnessGoal _selectedGoal = FitnessGoal.buildMuscle;
  ExperienceLevel _selectedLevel = ExperienceLevel.beginner;
  WorkoutMode _selectedMode = WorkoutMode.gym;

  bool _loading = true;
  bool _submitting = false;
  UserProfile? _existing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository = AppDependencies.of(context).profileRepository;
    if (_loading) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    final profile = await _repository.loadProfile();
    if (!mounted) return;

    if (profile != null) {
      _existing = profile;
      _nameController.text = profile.name ?? '';
      _ageController.text = profile.age.toString();
      _heightController.text = profile.heightCm.toStringAsFixed(1);
      _weightController.text = profile.weightKg.toStringAsFixed(1);
      _selectedGender = profile.gender;
      _selectedGoal = profile.goal;
      _selectedLevel = profile.level;
      _selectedMode = profile.mode;
    } else {
      _ageController.text = '25';
      _heightController.text = '170';
      _weightController.text = '70';
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final age = int.parse(_ageController.text.trim());
    final height = double.parse(_heightController.text.trim());
    final weight = double.parse(_weightController.text.trim());

    final profile = UserProfile(
      id: _existing?.id,
      name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      age: age,
      heightCm: height,
      weightKg: weight,
      gender: _selectedGender,
      goal: _selectedGoal,
      level: _selectedLevel,
      mode: _selectedMode,
    );

    setState(() => _submitting = true);

    try {
      await _repository.saveProfile(profile);

      if (!mounted) return;

      AppStateScope.of(context).updateHasProfile(true);

      final message = widget.isEditing
          ? 'Profil berhasil diperbarui'
          : 'Profil berhasil dibuat';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (widget.isEditing) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Profil' : 'Profil Pengguna'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEditing
                          ? 'Perbarui informasi profil Anda'
                          : 'Mari kenali tujuan latihanmu',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama panggilan (opsional)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageController,
                            decoration:
                                const InputDecoration(labelText: 'Usia'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final parsed = int.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Usia harus lebih dari 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Tinggi (cm)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              final parsed = double.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Tinggi harus valid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Berat Badan (kg)',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Berat harus valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Gender>(
                      initialValue: _selectedGender,
                      items: Gender.values
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(describeGender(gender)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<FitnessGoal>(
                      initialValue: _selectedGoal,
                      items: FitnessGoal.values
                          .map(
                            (goal) => DropdownMenuItem(
                              value: goal,
                              child: Text(describeGoal(goal)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGoal = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Target'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ExperienceLevel>(
                      initialValue: _selectedLevel,
                      items: ExperienceLevel.values
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(describeLevel(level)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedLevel = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Level'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<WorkoutMode>(
                      initialValue: _selectedMode,
                      items: WorkoutMode.values
                          .map(
                            (mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(describeMode(mode)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedMode = value);
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Preferensi latihan'),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: Text(
                            widget.isEditing ? 'Simpan Perubahan' : 'Mulai'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
