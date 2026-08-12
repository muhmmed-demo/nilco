import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/models/order_model.dart';
import '../home/providers/warehouse_dashboard_provider.dart';
import '../home/widgets/warehouse_bottom_nav.dart';

class IncomingOrdersScreen extends ConsumerWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingAsync = ref.watch(incomingOrdersProvider);
    final isUpdating = ref.watch(orderFulfillmentProvider) is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('تجهيز الطلبيات', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: incomingAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('لا توجد طلبات قيد الانتظار للتجهيز.'));
          }
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              
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
                                Text('العميل: ${order.clientName}', style: AppTextStyles.headingSmall),
                                Text('الطلب رقم: ${order.id.substring(0, 8)}', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('جاهز للتجميع', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
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
                      const Divider(height: 24),
                      Text('الأصناف (${order.items.length}):', style: AppTextStyles.bodyMainBold),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('- ${item.productName}', style: AppTextStyles.bodySecondary),
                            Text('${item.quantity} حبة', style: AppTextStyles.bodyMainBold.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: isUpdating ? null : () async {
                            final success = await ref.read(orderFulfillmentProvider.notifier).fulfillOrder(order.id);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تجهيز الطلب بنجاح!'), backgroundColor: AppColors.success));
                            }
                          },
                          child: const Text('تجهيز الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
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
      bottomNavigationBar: const WarehouseBottomNav(currentIndex: 1),
    );
  }
}
