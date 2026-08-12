import 'package:flutter/material.dart';
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
