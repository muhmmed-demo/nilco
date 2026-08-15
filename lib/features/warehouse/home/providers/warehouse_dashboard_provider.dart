import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
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