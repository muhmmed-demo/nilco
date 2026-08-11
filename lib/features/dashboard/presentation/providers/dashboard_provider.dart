import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dashboard_repository.dart';
import '../data/dashboard_repository_impl.dart';

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getSummary();
});

final monthlyStatisticsProvider = FutureProvider<List<DailyPerformance>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getMonthlyStatistics();
});
