import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara"
rep_dir = os.path.join(base_dir, "lib", "features", "rep")

files = {}

# 1. rep_orders_provider.dart
os.makedirs(os.path.join(rep_dir, "orders", "providers"), exist_ok=True)
files[os.path.join(rep_dir, "orders", "providers", "rep_orders_provider.dart")] = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/models/stock_model.dart';
import '../../../../core/models/client_model.dart';
import '../../../../core/repositories/mock/mock_orders_repository.dart';
import '../../../../core/repositories/mock/mock_stock_repository.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

final ordersRepositoryProvider = Provider((ref) => MockOrdersRepository());
final stockRepositoryProvider = Provider((ref) => MockStockRepository());

final repOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getRepOrders(authState.user.id);
  }
  return [];
});

final clientsProvider = Provider<List<ClientModel>>((ref) {
  // In real app, this would be a FutureProvider fetching rep's assigned clients
  return MockData.clients;
});

final availableProductsProvider = FutureProvider<List<StockItem>>((ref) async {
  final repo = ref.watch(stockRepositoryProvider);
  return repo.getWarehouseStock('br_01'); // Hardcoded mock branch
});

// Cart State Management
class CartState {
  final ClientModel? selectedClient;
  final Map<String, int> itemQuantities; // productId -> quantity

  CartState({this.selectedClient, required this.itemQuantities});

  CartState copyWith({ClientModel? selectedClient, Map<String, int>? itemQuantities}) {
    return CartState(
      selectedClient: selectedClient ?? this.selectedClient,
      itemQuantities: itemQuantities ?? this.itemQuantities,
    );
  }
}

class CartController extends StateNotifier<CartState> {
  CartController() : super(CartState(itemQuantities: {}));

  void selectClient(ClientModel client) {
    state = state.copyWith(selectedClient: client);
  }

  void updateQuantity(String productId, int quantity) {
    final updatedMap = Map<String, int>.from(state.itemQuantities);
    if (quantity <= 0) {
      updatedMap.remove(productId);
    } else {
      updatedMap[productId] = quantity;
    }
    state = state.copyWith(itemQuantities: updatedMap);
  }

  void clearCart() {
    state = CartState(itemQuantities: {});
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
});

class OrderSubmissionController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  OrderSubmissionController(this.ref) : super(const AsyncData(null));

  Future<bool> submitOrder() async {
    final cart = ref.read(cartControllerProvider);
    final products = ref.read(availableProductsProvider).value ?? [];
    
    if (cart.selectedClient == null || cart.itemQuantities.isEmpty) return false;

    state = const AsyncLoading();
    try {
      final authState = ref.read(authControllerProvider);
      if (authState is! AuthAuthenticated) throw Exception('Not authenticated');

      List<OrderItem> orderItems = [];
      double totalValue = 0.0;

      cart.itemQuantities.forEach((productId, qty) {
        final product = products.firstWhere((p) => p.productId == productId);
        final price = 50.0; // Mock price
        orderItems.add(OrderItem(
          productId: product.productId,
          productName: product.productName,
          quantity: qty,
          unitPrice: price,
        ));
        totalValue += price * qty;
      });

      final order = OrderModel(
        id: const Uuid().v4(),
        repId: authState.user.id,
        clientId: cart.selectedClient!.id,
        clientName: cart.selectedClient!.name,
        items: orderItems,
        totalValue: totalValue,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      await ref.read(ordersRepositoryProvider).createOrder(order);
      ref.invalidate(repOrdersProvider);
      ref.read(cartControllerProvider.notifier).clearCart();
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final orderSubmissionProvider = StateNotifierProvider<OrderSubmissionController, AsyncValue<void>>((ref) {
  return OrderSubmissionController(ref);
});
"""

# 2. rep_orders_screen.dart
files[os.path.join(rep_dir, "orders", "rep_orders_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

# 3. new_order_screen.dart
files[os.path.join(rep_dir, "orders", "new_order_screen.dart")] = """import 'package:flutter/material.dart';
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
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Phase 5 Rep Orders generated.")
