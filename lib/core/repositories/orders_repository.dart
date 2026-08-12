import '../models/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getRepOrders(String repId);
  Future<List<OrderModel>> getAllOrders();
  Future<List<OrderModel>> getIncomingOrders();
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus status, {String? note});
}
