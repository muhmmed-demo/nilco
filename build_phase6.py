import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara"
rep_dir = os.path.join(base_dir, "lib", "features", "rep")

files = {}

# 1. rep_performance_screen.dart
os.makedirs(os.path.join(rep_dir, "performance"), exist_ok=True)
files[os.path.join(rep_dir, "performance", "rep_performance_screen.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../home/providers/rep_dashboard_provider.dart';
import '../home/widgets/rep_bottom_nav.dart';

class RepPerformanceScreen extends ConsumerWidget {
  const RepPerformanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfAsync = ref.watch(repPerformanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('تقارير الأداء', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: perfAsync.when(
        data: (report) {
          if (report == null) return const Center(child: Text('لا توجد بيانات للأداء.'));
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top stats
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.monetization_on, color: AppColors.success, size: 32),
                            const SizedBox(height: 8),
                            Text('المبيعات', style: AppTextStyles.caption),
                            Text('${report.totalSalesValue / 1000}K', style: AppTextStyles.headingMedium),
                          ],
                        ),
                      ).animate().fade().scale(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.task_alt, color: AppColors.primary, size: 32),
                            const SizedBox(height: 8),
                            Text('الزيارات', style: AppTextStyles.caption),
                            Text('${report.visitedClients}', style: AppTextStyles.headingMedium),
                          ],
                        ),
                      ).animate().fade(delay: 100.ms).scale(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Chart Title
                Text('المبيعات اليومية', style: AppTextStyles.headingSmall),
                const SizedBox(height: 16),
                
                // Chart
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                // Simplified mockup labels
                                if (value % 2 != 0) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('يوم ${value.toInt()}', style: const TextStyle(fontSize: 10)),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(1, 1),
                              const FlSpot(2, 1.5),
                              const FlSpot(3, 1.4),
                              const FlSpot(4, 3.4),
                              const FlSpot(5, 2),
                              const FlSpot(6, 2.2),
                              const FlSpot(7, 4),
                            ],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().slideY(begin: 0.2, delay: 200.ms).fade(),
                
                const SizedBox(height: 24),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('نسبة التغطية', style: AppTextStyles.bodyMainBold),
                      Text('${report.coveragePercent.toInt()}%', style: AppTextStyles.headingSmall.copyWith(color: AppColors.secondary)),
                    ],
                  ),
                ).animate().slideY(begin: 0.2, delay: 300.ms).fade(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: const RepBottomNav(currentIndex: 3),
    );
  }
}
"""

# 2. client_stock_screen.dart and its provider
os.makedirs(os.path.join(rep_dir, "stock", "providers"), exist_ok=True)
files[os.path.join(rep_dir, "stock", "providers", "client_stock_provider.dart")] = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/stock_model.dart';
import '../../../../core/repositories/mock/mock_stock_repository.dart';
import '../../orders/providers/rep_orders_provider.dart';

final stockRepoProvider = Provider((ref) => MockStockRepository());

// Used for client dropdown in stock screen
final stockClientProvider = StateProvider<String?>((ref) => null);

final clientStockProvider = FutureProvider<List<StockItem>>((ref) async {
  final clientId = ref.watch(stockClientProvider);
  if (clientId == null) return [];
  
  final repo = ref.watch(stockRepoProvider);
  return repo.getClientStock(clientId);
});
"""

files[os.path.join(rep_dir, "stock", "client_stock_screen.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/models/client_model.dart';
import '../orders/providers/rep_orders_provider.dart'; // for clientsProvider
import 'providers/client_stock_provider.dart';

class ClientStockScreen extends ConsumerWidget {
  const ClientStockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);
    final selectedClientId = ref.watch(stockClientProvider);
    final stockAsync = ref.watch(clientStockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('مخزون العملاء', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppCard(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                value: selectedClientId,
                hint: const Text('اختر العميل لاستعراض المخزون...'),
                items: clients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (id) {
                  ref.read(stockClientProvider.notifier).state = id;
                },
              ),
            ),
          ),
          Expanded(
            child: stockAsync.when(
              data: (stock) {
                if (selectedClientId == null) {
                  return const Center(child: Text('يرجى اختيار العميل من القائمة أعلاه.'));
                }
                if (stock.isEmpty) {
                  return const Center(child: Text('لا توجد بيانات مخزون مسجلة لهذا العميل.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stock.length,
                  itemBuilder: (context, index) {
                    final item = stock[index];
                    return AppCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(Icons.inventory, color: AppColors.primary),
                        ),
                        title: Text(item.productName, style: AppTextStyles.bodyMainBold),
                        subtitle: Text(item.productCode, style: AppTextStyles.caption),
                        trailing: Text('${item.quantity}', style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Phase 6 Rep Performance & Stock generated.")
