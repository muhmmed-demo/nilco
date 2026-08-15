import 'package:flutter_riverpod/flutter_riverpod.dart';
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
\nimport '../../../../core/di/dependency_injection.dart';