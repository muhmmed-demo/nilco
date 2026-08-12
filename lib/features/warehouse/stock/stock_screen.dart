import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../home/providers/warehouse_dashboard_provider.dart';
import '../home/widgets/warehouse_bottom_nav.dart';

class StockManagementScreen extends ConsumerWidget {
  const StockManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(warehouseStockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('جرد المخزون', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppCard(
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'البحث عن منتج أو كود...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: stockAsync.when(
              data: (stock) {
                if (stock.isEmpty) {
                  return const Center(child: Text('المخزن فارغ.'));
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
                          child: Icon(Icons.category, color: AppColors.primary),
                        ),
                        title: Text(item.productName, style: AppTextStyles.bodyMainBold),
                        subtitle: Text(item.productCode, style: AppTextStyles.caption),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${item.quantity}', style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary)),
                            Text('حبة', style: AppTextStyles.caption),
                          ],
                        ),
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
      bottomNavigationBar: const WarehouseBottomNav(currentIndex: 2),
    );
  }
}
