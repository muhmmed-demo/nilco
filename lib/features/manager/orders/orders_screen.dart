import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/models/order_model.dart';
import '../home/providers/manager_dashboard_provider.dart';
import '../home/widgets/manager_bottom_nav.dart';

class OrdersManagerScreen extends ConsumerWidget {
  const OrdersManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(managerOrdersProvider);
    final isUpdating = ref.watch(orderApprovalProvider) is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('إدارة الطلبيات', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('لا توجد طلبيات.'));
          }
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final isPending = order.status.name == 'pending';
              
              return AppCard(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.clientName, style: AppTextStyles.headingSmall),
                                Text('مندوب: ${order.repId}', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          Text('${order.totalValue.toStringAsFixed(2)} ريال', style: AppTextStyles.bodyMainBold.copyWith(color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(dateFormat.format(order.createdAt), style: AppTextStyles.caption),
                        ],
                      ),
                      if (isPending) ...[
                        const Divider(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: isUpdating ? null : () async {
                                  await ref.read(orderApprovalProvider.notifier).updateOrderStatus(order.id, OrderStatus.approvedByManager);
                                },
                                child: const Text('اعتماد'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(color: AppColors.error),
                                ),
                                onPressed: isUpdating ? null : () async {
                                  await ref.read(orderApprovalProvider.notifier).updateOrderStatus(order.id, OrderStatus.cancelled);
                                },
                                child: const Text('رفض'),
                              ),
                            ),
                          ],
                        )
                      ] else ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('تمت معالجة الطلب', style: AppTextStyles.caption),
                        )
                      ]
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.1);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: const ManagerBottomNav(currentIndex: 1),
    );
  }
}
