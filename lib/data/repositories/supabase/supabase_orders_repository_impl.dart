import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/repositories/orders_repository.dart';
import '../../../core/models/order_model.dart';
import '../../sources/remote/supabase_orders_source.dart';
import '../../sources/local/hive_cache.dart';

class SupabaseOrdersRepositoryImpl implements OrdersRepository {
  final SupabaseOrdersSource _remoteSource;
  final HiveOrdersCache _localCache;

  SupabaseOrdersRepositoryImpl(this._remoteSource, this._localCache);

  Future<bool> _hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<OrderModel>> getRepOrders(String repId) async {
    if (await _hasInternet()) {
      try {
        final data = await _remoteSource.getOrdersByRep(repId);
        final orders = data.map((e) => _mapToOrderModel(e)).toList();
        await _localCache.cacheOrders(data);
        return orders;
      } catch (e) {
        return _getCachedOrders(repId);
      }
    } else {
      return _getCachedOrders(repId);
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    // Maps to getPendingOrders for Manager
    if (await _hasInternet()) {
      final data = await _remoteSource.getPendingOrders();
      return data.map((e) => _mapToOrderModel(e)).toList();
    }
    return [];
  }

  @override
  Future<List<OrderModel>> getIncomingOrders() async {
    // Maps to getApprovedOrders for Warehouse
    if (await _hasInternet()) {
      final data = await _remoteSource.getApprovedOrders();
      return data.map((e) => _mapToOrderModel(e)).toList();
    }
    return [];
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    if (await _hasInternet()) {
      final orderMap = {
        'id': order.id,
        'client_id': order.clientId,
        'client_name': order.clientName,
        'rep_id': order.repId,
        'total_value': order.totalValue,
        'status': 'pending',
      };
      
      final itemsMap = order.items.map((i) => {
        'product_id': i.productId,
        'product_name': i.productName,
        'quantity': i.quantity,
        'unit_price': i.unitPrice,
      }).toList();
      
      await _remoteSource.createOrder(orderMap, itemsMap);
      return order;
    } else {
      // Save locally to sync later
      throw Exception('Offline order creation requires sync queue implementation');
    }
  }

  @override
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus status, {String? note}) async {
    if (await _hasInternet()) {
      if (status == OrderStatus.approvedByManager) {
        await _remoteSource.approveOrder(orderId, 'manager_id');
      } else if (status == OrderStatus.cancelled) {
        await _remoteSource.rejectOrder(orderId);
      } else if (status == OrderStatus.fulfilled) {
        await _remoteSource.fulfillOrder(orderId, 'warehouse_id');
      }
      
      // Return a dummy updated order for state
      return OrderModel(
        id: orderId,
        clientId: 'cli',
        clientName: 'Client',
        repId: 'rep',
        items: [],
        totalValue: 0,
        status: status,
        createdAt: DateTime.now(),
      );
    } else {
      throw Exception('Cannot update order status offline');
    }
  }

  Future<List<OrderModel>> _getCachedOrders(String repId) async {
    final cached = await _localCache.getCachedOrders();
    final mapped = cached.map((e) => _mapToOrderModel(Map<String,dynamic>.from(e))).toList();
    return mapped.where((o) => o.repId == repId).toList();
  }

  OrderModel _mapToOrderModel(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'] ?? '',
      clientId: data['client_id'] ?? '',
      clientName: data['client_name'] ?? 'Unknown Client',
      repId: data['sales_rep_id'] ?? data['rep_id'] ?? '',
      items: [], // Map items properly if needed
      totalValue: (data['total_value'] ?? 0).toDouble(),
      status: OrderStatus.pending, // map from string properly
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : DateTime.now(),
    );
  }
}
