import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import 'widgets/manager_bottom_nav.dart';
import 'providers/manager_dashboard_provider.dart';

class ManagerHomeScreen extends ConsumerWidget {
  const ManagerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(managerOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('لوحة تحكم المدير', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Branch Summary
            Text('ملخص الفرع', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            ordersAsync.when(
              data: (orders) {
                final totalSales = orders.fold<double>(0, (sum, item) => sum + item.totalValue);
                final pendingCount = orders.where((o) => o.status.name == 'pending').length;
                return Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.monetization_on, color: AppColors.success, size: 32),
                            const SizedBox(height: 8),
                            Text('مبيعات اليوم', style: AppTextStyles.caption),
                            Text('${totalSales / 1000}K', style: AppTextStyles.headingMedium),
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
                            const Icon(Icons.pending_actions, color: AppColors.warning, size: 32),
                            const SizedBox(height: 8),
                            Text('طلبات معلقة', style: AppTextStyles.caption),
                            Text('$pendingCount', style: AppTextStyles.headingMedium.copyWith(color: AppColors.warning)),
                          ],
                        ),
                      ).animate().fade(delay: 100.ms).scale(),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),
            
            // Top Performers Placeholder
            Text('أفضل المناديب أداءً', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            AppCard(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.star, color: AppColors.primary),
                ),
                title: Text('أحمد علي', style: AppTextStyles.bodyMainBold),
                subtitle: Text('محقق 80% من التارجت', style: AppTextStyles.caption),
                trailing: Text('15K', style: AppTextStyles.headingSmall.copyWith(color: AppColors.success)),
              ),
            ).animate().slideY(begin: 0.1, delay: 200.ms).fade(),
            const SizedBox(height: 24),
            
            // Quick Alerts
            Text('تنبيهات عاجلة', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.warning, color: AppColors.error),
                title: Text('2 طلبية تتجاوز الحد الائتماني', style: AppTextStyles.bodyMainBold.copyWith(color: AppColors.error)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ).animate().slideY(begin: 0.1, delay: 300.ms).fade(),
          ],
        ),
      ),
      bottomNavigationBar: const ManagerBottomNav(currentIndex: 0),
    );
  }
}
