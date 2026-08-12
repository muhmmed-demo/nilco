import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara"
warehouse_dir = os.path.join(base_dir, "lib", "features", "warehouse")

files = {}

# 1. warehouse_bottom_nav.dart
os.makedirs(os.path.join(warehouse_dir, "home", "widgets"), exist_ok=True)
files[os.path.join(warehouse_dir, "home", "widgets", "warehouse_bottom_nav.dart")] = """import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class WarehouseBottomNav extends StatelessWidget {
  final int currentIndex;

  const WarehouseBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/warehouse/home');
        break;
      case 1:
        context.go('/warehouse/orders');
        break;
      case 2:
        context.go('/warehouse/stock');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(index, context),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.move_to_inbox), label: 'الطلبيات'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'المخزون'),
      ],
    );
  }
}
"""

# 2. warehouse_dashboard_provider.dart
os.makedirs(os.path.join(warehouse_dir, "home", "providers"), exist_ok=True)
files[os.path.join(warehouse_dir, "home", "providers", "warehouse_dashboard_provider.dart")] = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/models/stock_model.dart';
import '../../../../core/repositories/mock/mock_orders_repository.dart';
import '../../../../core/repositories/mock/mock_stock_repository.dart';

final warehouseOrdersRepoProvider = Provider((ref) => MockOrdersRepository());
final warehouseStockRepoProvider = Provider((ref) => MockStockRepository());

final incomingOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final repo = ref.watch(warehouseOrdersRepoProvider);
  return repo.getIncomingOrders();
});

final warehouseStockProvider = FutureProvider<List<StockItem>>((ref) async {
  final repo = ref.watch(warehouseStockRepoProvider);
  return repo.getWarehouseStock('br_01'); // using mock branch
});

class OrderFulfillmentController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  OrderFulfillmentController(this.ref) : super(const AsyncData(null));

  Future<bool> fulfillOrder(String orderId) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(warehouseOrdersRepoProvider);
      await repo.updateOrderStatus(orderId, OrderStatus.fulfilled);
      ref.invalidate(incomingOrdersProvider); // Refresh list
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final orderFulfillmentProvider = StateNotifierProvider<OrderFulfillmentController, AsyncValue<void>>((ref) {
  return OrderFulfillmentController(ref);
});
"""

# 3. home_screen.dart (Warehouse Dashboard)
files[os.path.join(warehouse_dir, "home", "home_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

# 4. orders_screen.dart (Incoming Orders)
os.makedirs(os.path.join(warehouse_dir, "orders"), exist_ok=True)
files[os.path.join(warehouse_dir, "orders", "orders_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

# 5. stock_screen.dart (Warehouse Stock List)
os.makedirs(os.path.join(warehouse_dir, "stock"), exist_ok=True)
files[os.path.join(warehouse_dir, "stock", "stock_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Phase 8 Warehouse Screens generated.")
