import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<DashboardSummary> getSummary() async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 1));
    return DashboardSummary(
      totalPoints: 1250,
      totalCoins: 340,
      weeklyPerformance: [
        DailyPerformance('Sat', 65),
        DailyPerformance('Sun', 80),
        DailyPerformance('Mon', 45),
        DailyPerformance('Tue', 90),
        DailyPerformance('Wed', 75),
        DailyPerformance('Thu', 100),
        DailyPerformance('Fri', 20),
      ],
    );
  }

  @override
  Future<List<DailyPerformance>> getMonthlyStatistics() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock monthly data (returning 4 weeks of data points for simplicity)
    return [
      DailyPerformance('Week 1', 320),
      DailyPerformance('Week 2', 450),
      DailyPerformance('Week 3', 290),
      DailyPerformance('Week 4', 510),
    ];
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});
