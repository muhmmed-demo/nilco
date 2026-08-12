import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/models/client_model.dart';
import '../../../../core/models/stock_model.dart';
import 'providers/rep_orders_provider.dart';

class NewOrderScreen extends ConsumerWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final clients = ref.watch(clientsProvider);
    final productsAsync = ref.watch(availableProductsProvider);
    final isSubmitting = ref.watch(orderSubmissionProvider) is AsyncLoading;

    // Calculate total
    double totalValue = 0;
    productsAsync.whenData((products) {
      cartState.itemQuantities.forEach((productId, qty) {
        // mock price 50.0
        totalValue += 50.0 * qty; 
      });
    });

    void _submit() async {
      final success = await ref.read(orderSubmissionProvider.notifier).submitOrder();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب بنجاح'), backgroundColor: AppColors.success));
        context.pop();
      } else if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى اختيار العميل وإضافة منتجات'), backgroundColor: AppColors.error));
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('طلب جديد', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('العميل', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 8),
                  AppCard(
                    child: DropdownButtonFormField<ClientModel>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      value: cartState.selectedClient,
                      hint: const Text('اختر العميل...'),
                      items: clients.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                      onChanged: (c) {
                        if (c != null) ref.read(cartControllerProvider.notifier).selectClient(c);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('المنتجات المتاحة', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 8),
                  productsAsync.when(
                    data: (products) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final p = products[index];
                          final currentQty = cartState.itemQuantities[p.productId] ?? 0;
                          return AppCard(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.inventory_2, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(p.productName, style: AppTextStyles.bodyMainBold),
                                        Text('المتاح: ${p.quantity}', style: AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                                        onPressed: () => ref.read(cartControllerProvider.notifier).updateQuantity(p.productId, currentQty - 1),
                                      ),
                                      Text('$currentQty', style: AppTextStyles.headingSmall),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: AppColors.success),
                                        onPressed: () => ref.read(cartControllerProvider.notifier).updateQuantity(p.productId, currentQty + 1),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Text('Error: $e'),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Bar for Checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('الإجمالي', style: AppTextStyles.caption),
                        Text('${totalValue.toStringAsFixed(2)} ريال', style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      text: 'إرسال الطلب',
                      isLoading: isSubmitting,
                      onPressed: totalValue > 0 && cartState.selectedClient != null ? _submit : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
