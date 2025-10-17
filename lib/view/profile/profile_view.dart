import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../common/app_router.dart';
import '../login/models/onboarding_draft.dart';
import '../shared/models/user_profile.dart' as domain;
import '../shared/repositories/profile_repository.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileRepository _repository;
  Stream<domain.UserProfile?>? _profileStream;
  bool _dependenciesResolved = false;

  void _retryProfileLoad() {
    setState(() {
      _profileStream = _repository.watchProfile();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesResolved) return;

    final dependencies = AppDependencies.of(context);
    _repository = dependencies.profileRepository;
    _profileStream = _repository.watchProfile();
    _dependenciesResolved = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<domain.UserProfile?>(
        stream: _profileStream,
        builder: (context, snapshot) {
          if (_profileStream == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ProfileErrorState(onRetry: _retryProfileLoad);
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const _ProfileEmptyState();
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
    final theme = Theme.of(context);
    final name = (profile.name?.trim().isNotEmpty ?? false)
        ? profile.name!.trim()
        : 'Gym Buddy';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${domain.describeGoal(profile.goal)} • ${domain.describeLevel(profile.level)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
    final metrics = <_MetricData>[
      _MetricData(
        label: 'Age',
        value: '${profile.age} yrs',
        icon: Icons.cake_outlined,
      ),
      _MetricData(
        label: 'Height',
        value: '${profile.heightCm.toStringAsFixed(1)} cm',
        icon: Icons.height,
      ),
      _MetricData(
        label: 'Weight',
        value: '${profile.weightKg.toStringAsFixed(1)} kg',
        icon: Icons.fitness_center,
      ),
      _MetricData(
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
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _MetricTile(metric: metric);
      },
    );
  }
}

@immutable
class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(metric.icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metric.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    metric.value,
                    style: theme.textTheme.titleMedium,
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
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(domain.describeGoal(profile.goal)),
            const SizedBox(height: 16),
            Text(
              'Preferred Mode',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(domain.describeMode(profile.mode)),
          ],
        ),
      ),
    );
  }
}

class _ProfileEmptyState extends StatelessWidget {
  const _ProfileEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
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
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 72,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak dapat memuat profil saat ini. Coba lagi nanti.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
