class PerformanceReport {
  final String repId;
  final String repName;
  final DateRange period;
  final int totalClientsInRoute;
  final int visitedClients;
  final double coveragePercent;
  final double totalSalesValue;
  final int ordersCount;
  final List<DailyPerformance> dailyBreakdown;

  PerformanceReport({
    required this.repId,
    required this.repName,
    required this.period,
    required this.totalClientsInRoute,
    required this.visitedClients,
    required this.coveragePercent,
    required this.totalSalesValue,
    required this.ordersCount,
    required this.dailyBreakdown,
  });
}

class DailyPerformance {
  final DateTime date;
  final int visits;
  final double sales;
  final String dayLabel;

  DailyPerformance({
    required this.date,
    required this.visits,
    required this.sales,
    required this.dayLabel,
  });
}

class DateRange {
  final DateTime from;
  final DateTime to;

  DateRange({required this.from, required this.to});
}
