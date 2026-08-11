import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/performance_chart.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  bool _isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final weeklyAsync = ref.watch(dashboardSummaryProvider);
    final monthlyAsync = ref.watch(monthlyStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('statistics'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Custom Toggle Buttons
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isWeekly = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isWeekly ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'weekly'.tr(),
                            style: AppTextStyles.bodyMain.copyWith(
                              color: _isWeekly ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isWeekly = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isWeekly ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'monthly'.tr(),
                            style: AppTextStyles.bodyMain.copyWith(
                              color: !_isWeekly ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _isWeekly
                  ? weeklyAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                      data: (summary) => AppCard(
                        child: PerformanceChart(performanceData: summary.weeklyPerformance),
                      ),
                    )
                  : monthlyAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                      data: (data) => AppCard(
                        child: PerformanceChart(performanceData: data),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
