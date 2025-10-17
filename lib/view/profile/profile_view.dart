import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../common/app_router.dart';
import '../../features/profile/domain/profile_repository.dart';
import '../../features/profile/domain/user_profile.dart' as domain;
import '../login/models/onboarding_draft.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileRepository _repository;
  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _repository = AppDependencies.of(context).profileRepository;
    _initialised = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<domain.UserProfile?>(
        stream: _repository.watchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;
          if (profile == null) {
            return _buildEmptyState(context);
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _ProfileHeader(profile: profile, onEdit: () => _onEdit(profile)),
              const SizedBox(height: 24),
              _MetricGrid(profile: profile),
              const SizedBox(height: 24),
              _ProfileDetails(profile: profile),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Profil belum tersedia. Silakan selesaikan onboarding terlebih dahulu.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoute.onboarding),
              child: const Text('Mulai Onboarding'),
            ),
          ],
        ),
      ),
    );
  }

  void _onEdit(domain.UserProfile profile) {
    final draft = OnboardingDraft.fromProfile(profile);
    final args = ProfileFormArguments(
      draft: draft,
      mode: ProfileFormMode.edit,
    );
    context.push(AppRoute.completeProfile, extra: args);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile, required this.onEdit});

  final domain.UserProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final name = profile.name ?? 'Gym Buddy';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${domain.describeGoal(profile.goal)} • ${domain.describeLevel(profile.level)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.profile});

  final domain.UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricTile(
        label: 'Age',
        value: '${profile.age} yrs',
        icon: Icons.cake_outlined,
      ),
      _MetricTile(
        label: 'Height',
        value: '${profile.heightCm.toStringAsFixed(1)} cm',
        icon: Icons.height,
      ),
      _MetricTile(
        label: 'Weight',
        value: '${profile.weightKg.toStringAsFixed(1)} kg',
        icon: Icons.fitness_center,
      ),
      _MetricTile(
        label: 'Mode',
        value: domain.describeMode(profile.mode),
        icon: Icons.sports_gymnastics,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => metrics[index],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});

  final domain.UserProfile profile;

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
              'Goals',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(domain.describeGoal(profile.goal)),
            const SizedBox(height: 16),
            Text(
              'Preferred Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(domain.describeMode(profile.mode)),
          ],
        ),
      ),
    );
  }
}
