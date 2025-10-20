// lib/database/daos/body_metrics_dao.dart

part of '../app_db.dart';

@DriftAccessor(tables: [BodyMetrics])
class BodyMetricsDao extends DatabaseAccessor<AppDatabase> with _$BodyMetricsDaoMixin {
  BodyMetricsDao(super.db);

  Future<void> addWeight({required String userId, required double kg, double? bodyFatPct, String? notes}) async {
    await into(bodyMetrics).insert(BodyMetricsCompanion.insert(
      userId: userId,
      weightKg: kg,
      bodyFatPct: Value(bodyFatPct),
      notes: Value(notes),
    ));
  }

  Stream<List<BodyMetric>> watchWeights(String userId) {
    return (select(bodyMetrics)
      ..where((b) => b.userId.equals(userId))
      ..orderBy([(b) => OrderingTerm.asc(b.loggedAt)]))
    .watch();
  }
}