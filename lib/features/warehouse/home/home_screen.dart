import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import 'widgets/warehouse_bottom_nav.dart';
import 'providers/warehouse_dashboard_provider.dart';

class WarehouseHomeScreen extends ConsumerWidget {
  const WarehouseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingAsync = ref.watch(incomingOrdersProvider);
    final stockAsync = ref.watch(warehouseStockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('لوحة تحكم المخزن', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ملخص العمليات', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.move_to_inbox, color: AppColors.primary, size: 32),
                        const SizedBox(height: 8),
                        Text('طلبات للتجهيز', style: AppTextStyles.caption),
                        incomingAsync.when(
                          data: (orders) => Text('${orders.length}', style: AppTextStyles.headingMedium),
                          loading: () => const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                          error: (_, __) => const Text('Error'),
                        ),
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
                        const Icon(Icons.inventory, color: AppColors.secondary, size: 32),
                        const SizedBox(height: 8),
                        Text('إجمالي الأصناف', style: AppTextStyles.caption),
                        stockAsync.when(
                          data: (stock) => Text('${stock.length}', style: AppTextStyles.headingMedium.copyWith(color: AppColors.secondary)),
                          loading: () => const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                          error: (_, __) => const Text('Error'),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 100.ms).scale(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Text('وصول سريع', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            AppCard(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.qr_code_scanner, color: AppColors.primary),
                ),
                title: Text('بدء تجهيز طلبية', style: AppTextStyles.bodyMainBold),
                subtitle: Text('امسح الباركود للبدء', style: AppTextStyles.caption),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.push('/warehouse/orders');
                },
              ),
            ).animate().slideY(begin: 0.1, delay: 200.ms).fade(),
          ],
        ),
      ),
      bottomNavigationBar: const WarehouseBottomNav(currentIndex: 0),
    );
  }
}
