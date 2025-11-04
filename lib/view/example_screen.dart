// lib/view/example_screen.dart

import 'package:flutter/material.dart';
import '../common/services/error_service.dart';
import '../database/app_db.dart';

class ExampleScreen extends StatefulWidget {
  // Fix: Add key parameter
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final AppDatabase _database = AppDatabase();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      ErrorService.startPerformanceTimer('load_users');

      final users = await _database.usersDao.getAllUsers();

      ErrorService.endPerformanceTimer('load_users');
      ErrorService.logInfo(
        'UI - ExampleScreen',
        'Loaded ${users.length} users',
      );
    } catch (error, stackTrace) {
      ErrorService.logUIError('ExampleScreen._loadData', error, stackTrace);

      // Show user-friendly error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: const SizedBox.expand(),
    );
  }
}
