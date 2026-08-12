import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara"
manager_dir = os.path.join(base_dir, "lib", "features", "manager")

files = {}

# 1. manager_bottom_nav.dart
os.makedirs(os.path.join(manager_dir, "home", "widgets"), exist_ok=True)
files[os.path.join(manager_dir, "home", "widgets", "manager_bottom_nav.dart")] = """import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class ManagerBottomNav extends StatelessWidget {
  final int currentIndex;

  const ManagerBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/manager/home');
        break;
      case 1:
        context.go('/manager/orders');
        break;
      case 2:
        context.go('/manager/reps');
        break;
      case 3:
        context.go('/manager/reports');
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
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الطلبيات'),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'المناديب'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'التقارير'),
      ],
    );
  }
}
"""

# 2. manager_dashboard_provider.dart
os.makedirs(os.path.join(manager_dir, "home", "providers"), exist_ok=True)
files[os.path.join(manager_dir, "home", "providers", "manager_dashboard_provider.dart")] = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/repositories/mock/mock_orders_repository.dart';
import '../../../../core/mock/mock_data.dart';

final ordersRepositoryProvider = Provider((ref) => MockOrdersRepository());

// Fetch all orders for the branch
final managerOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final repo = ref.watch(ordersRepositoryProvider);
  return repo.getAllOrders();
});

// Provide a mock list of reps for this manager
final managerRepsProvider = Provider<List<UserModel>>((ref) {
  return [MockData.salesRep]; // In real app, fetch from a UserRepository
});

class OrderApprovalController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  OrderApprovalController(this.ref) : super(const AsyncData(null));

  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(ordersRepositoryProvider);
      await repo.updateOrderStatus(orderId, newStatus);
      ref.invalidate(managerOrdersProvider); // Refresh list
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final orderApprovalProvider = StateNotifierProvider<OrderApprovalController, AsyncValue<void>>((ref) {
  return OrderApprovalController(ref);
});
"""

# 3. home_screen.dart (Manager Dashboard)
files[os.path.join(manager_dir, "home", "home_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

# 4. orders_screen.dart (Manager Orders)
os.makedirs(os.path.join(manager_dir, "orders"), exist_ok=True)
files[os.path.join(manager_dir, "orders", "orders_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

# 5. reps_screen.dart (Manager Reps List)
os.makedirs(os.path.join(manager_dir, "reps"), exist_ok=True)
files[os.path.join(manager_dir, "reps", "reps_screen.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../home/providers/manager_dashboard_provider.dart';
import '../home/widgets/manager_bottom_nav.dart';

class RepsListScreen extends ConsumerWidget {
  const RepsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reps = ref.watch(managerRepsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('المناديب', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reps.length,
        itemBuilder: (context, index) {
          final rep = reps[index];
          return AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              title: Text('${rep.firstName} ${rep.lastName}', style: AppTextStyles.bodyMainBold),
              subtitle: Text(rep.phone, style: AppTextStyles.caption),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to rep details
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const ManagerBottomNav(currentIndex: 2),
    );
  }
}
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Phase 7 Manager Screens generated.")
