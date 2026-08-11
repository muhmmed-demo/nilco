import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/performance_chart.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr(), style: AppTextStyles.headingSection),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRouter.profile),
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (summary) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(dashboardSummaryProvider.future),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('performance'.tr(), style: AppTextStyles.headingSection),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'total_points'.tr(),
                          value: summary.totalPoints.toString(),
                          icon: Icons.star,
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'coins'.tr(),
                          value: summary.totalCoins.toString(),
                          icon: Icons.monetization_on,
                          gradient: AppColors.goldGradient,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'weekly_performance'.tr(),
                        style: AppTextStyles.headingSection,
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRouter.statistics),
                        child: Text('view_all'.tr()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: PerformanceChart(performanceData: summary.weeklyPerformance),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
