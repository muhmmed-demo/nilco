import '../models/performance_model.dart';

abstract class PerformanceRepository {
  Future<PerformanceReport> getRepPerformance(String repId, DateRange period);
  Future<List<PerformanceReport>> getAllRepsPerformance(DateRange period);
}
