  // lib/view/test/drift_test_view.dart
  
  import 'package:aigymbuddy/database/app_db.dart';
  import 'package:flutter/material.dart';
  import 'package:uuid/uuid.dart';

  class DriftTestView extends StatefulWidget {
    const DriftTestView({super.key});

    @override
    State<DriftTestView> createState() => _DriftTestViewState();
  }

  class _DriftTestViewState extends State<DriftTestView> {
    late AppDatabase db;
    late BodyMetricsDao bodyMetricsDao;
    final String testUserId = const Uuid().v4();

    @override
    void initState() {
      super.initState();
      db = AppDatabase();
      bodyMetricsDao = db.bodyMetricsDao;
    }

    @override
    void dispose() {
      db.close();
      super.dispose();
    }

    void _addNewWeight() {
      final newWeight = 70.0 + (DateTime.now().second / 10.0);
      bodyMetricsDao.addWeight(
        userId: testUserId,
        kg: newWeight,
        notes: 'Data Tes Dibuat pada ${DateTime.now()}',
      );
      // ✅ FIX: Menghapus pemanggilan 'print()'
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Uji Coba Database Drift'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('User ID Tes (untuk sesi ini): $testUserId'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addNewWeight,
                child: const Text('Tambah Data Berat Badan Baru'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Data Real-time dari Database:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<BodyMetric>>(
                  stream: bodyMetricsDao.watchWeights(testUserId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red)));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Belum ada data. Coba tambahkan.'));
                    }
                    final metrics = snapshot.data!;
                    return ListView.builder(
                      itemCount: metrics.length,
                      itemBuilder: (context, index) {
                        final metric = metrics[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                // ✅ FIX: Menghapus operator null-aware '?.' yang tidak perlu
                                '${metric.weightKg.toStringAsFixed(2)} kg'),
                            subtitle:
                                Text(metric.notes ?? 'Tidak ada catatan'),
                            trailing: Text(
                              // ✅ FIX: Menghapus interpolasi string yang tidak perlu
                              metric.loggedAt
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }