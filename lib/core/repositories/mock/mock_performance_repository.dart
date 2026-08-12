import '../performance_repository.dart';
import '../../models/performance_model.dart';
import '../../mock/mock_data.dart';

class MockPerformanceRepository implements PerformanceRepository {
  @override
  Future<List<PerformanceReport>> getAllRepsPerformance(DateRange period) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<PerformanceReport> getRepPerformance(String repId, DateRange period) async {
    await Future.delayed(const Duration(seconds: 1));
    return PerformanceReport(
      repId: repId,
      repName: 'أحمد علي',
      period: period,
      totalClientsInRoute: 10,
      visitedClients: 8,
      coveragePercent: 80.0,
      totalSalesValue: 15000.0,
      ordersCount: 12,
      dailyBreakdown: [
        DailyPerformance(date: DateTime.now(), visits: 8, sales: 15000.0, dayLabel: 'اليوم'),
      ],
    );
  }
}
