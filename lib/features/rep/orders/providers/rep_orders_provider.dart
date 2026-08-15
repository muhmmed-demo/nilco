import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../../core/di/dependency_injection.dart';