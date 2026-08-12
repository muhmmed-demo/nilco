import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/models/order_model.dart';
import 'providers/rep_orders_provider.dart';
import '../home/widgets/rep_bottom_nav.dart';

class RepOrdersScreen extends ConsumerWidget {
  const RepOrdersScreen({Key? key}) : super(key: key);

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return AppColors.warning;
      case OrderStatus.approvedByManager: return Colors.blue;
      case OrderStatus.sentToWarehouse: return Colors.purple;
      case OrderStatus.fulfilled: return AppColors.success;
      case OrderStatus.cancelled: return AppColors.error;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'معلق';
      case OrderStatus.approvedByManager: return 'مقبول (مدير)';
      case OrderStatus.sentToWarehouse: return 'في المخزن';
      case OrderStatus.fulfilled: return 'مكتمل';
      case OrderStatus.cancelled: return 'ملغي';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(repOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('الطلبيات', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevent back button since it's bottom nav
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('لا توجد طلبيات سابقة.'));
          }
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final statusColor = _getStatusColor(order.status);
              
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
                          Expanded(child: Text(order.clientName, style: AppTextStyles.headingSmall)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(_getStatusText(order.status), style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(dateFormat.format(order.createdAt), style: AppTextStyles.caption),
                            ],
                          ),
                          Text('${order.totalValue.toStringAsFixed(2)} ريال', style: AppTextStyles.bodyMainBold.copyWith(color: AppColors.primary)),
                        ],
                      ),
                      const Divider(height: 24),
                      Text('${order.items.length} منتجات', style: AppTextStyles.bodySecondary),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/rep/order/new'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('طلب جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: const RepBottomNav(currentIndex: 2),
    );
  }
}
