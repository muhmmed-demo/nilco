import '../orders_repository.dart';
import '../../models/order_model.dart';
import '../../mock/mock_data.dart';

class MockOrdersRepository implements OrdersRepository {
  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    await Future.delayed(const Duration(seconds: 1));
    MockData.orders.add(order);
    return order;
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.orders;
  }

  @override
  Future<List<OrderModel>> getIncomingOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.orders.where((o) => o.status == OrderStatus.sentToWarehouse || o.status == OrderStatus.approvedByManager).toList();
  }

  @override
  Future<List<OrderModel>> getRepOrders(String repId) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.orders.where((o) => o.repId == repId).toList();
  }

  @override
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus status, {String? note}) async {
    await Future.delayed(const Duration(seconds: 1));
    final order = MockData.orders.firstWhere((o) => o.id == orderId);
    return order; // In a real app we'd clone and update
  }
}
