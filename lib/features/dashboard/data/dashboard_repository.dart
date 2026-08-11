class DashboardSummary {
  final int totalPoints;
  final int totalCoins;
  final List<DailyPerformance> weeklyPerformance;

  DashboardSummary({
    required this.totalPoints,
    required this.totalCoins,
    required this.weeklyPerformance,
  });
}

class DailyPerformance {
  final String dayName;
  final double score;

  DailyPerformance(this.dayName, this.score);
}

abstract class DashboardRepository {
  Future<DashboardSummary> getSummary();
  Future<List<DailyPerformance>> getMonthlyStatistics();
}
