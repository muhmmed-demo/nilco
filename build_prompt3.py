import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\data\repositories\supabase"
os.makedirs(base_dir, exist_ok=True)

files = {}

# 1. supabase_auth_repository_impl.dart
files[os.path.join(base_dir, "supabase_auth_repository_impl.dart")] = """import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../features/auth/data/auth_repository.dart';
import '../../../core/models/user_model.dart';
import '../../sources/remote/supabase_auth_source.dart';
import '../../sources/local/hive_auth_cache.dart';

class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthSource _remoteSource;
  final HiveAuthCache _localCache;

  SupabaseAuthRepositoryImpl(this._remoteSource, this._localCache);

  Future<bool> _hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    if (await _hasInternet()) {
      final response = await _remoteSource.signIn(email, password);
      if (response.user != null) {
        // Here we would typically fetch the full user profile from a 'users' table
        // For simplicity, we construct a UserModel from the auth response
        final user = UserModel(
          id: response.user!.id,
          firstName: 'User', // Mocked, should come from DB
          lastName: '',
          username: email.split('@')[0],
          email: email,
          phone: '',
          role: UserRole.salesRep, // Mocked, should come from DB
          token: response.session?.accessToken ?? '',
          companyName: 'نيلكو',
        );
        
        // Cache it
        await _localCache.cacheUser({
          'id': user.id,
          'email': user.email,
          'role': user.role.toString(),
          'token': user.token,
        });
        
        return user;
      }
      throw Exception('Login failed');
    } else {
      // Offline fallback
      final cached = await _localCache.getCachedUser();
      if (cached != null && cached['email'] == email) {
        return UserModel(
          id: cached['id'],
          firstName: 'Offline',
          lastName: 'User',
          username: 'offline',
          email: cached['email'],
          phone: '',
          role: cached['role'] == 'UserRole.manager' ? UserRole.manager : UserRole.salesRep,
          token: cached['token'],
          companyName: 'نيلكو',
        );
      }
      throw Exception('No internet and no cached credentials found.');
    }
  }

  @override
  Future<UserModel> register(String firstName, String lastName, String username, String email, String password) async {
    throw UnimplementedError('Registration is handled via Admin panel in this ERP');
  }

  @override
  Future<void> verifyPhone(String phone, String otp) async {
    // Implement phone verification logic here
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Implement forgot password logic here
  }

  @override
  Future<void> resetPassword(String newPassword, String otp) async {
    // Implement reset password logic here
  }

  @override
  Future<void> logout() async {
    await _remoteSource.signOut();
    await _localCache.clearAuth();
  }
}
"""

# 2. supabase_orders_repository_impl.dart
files[os.path.join(base_dir, "supabase_orders_repository_impl.dart")] = """import 'package:connectivity_plus/connectivity_plus.dart';
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
      } else if (status == OrderStatus.rejectedByManager) {
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
"""

# 3. supabase_stock_repository_impl.dart (Acts as ProductRepository as well)
files[os.path.join(base_dir, "supabase_stock_repository_impl.dart")] = """import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/repositories/stock_repository.dart';
import '../../../core/models/stock_model.dart';
import '../../sources/remote/supabase_orders_source.dart'; // we can use a generic or dedicated source later

class SupabaseStockRepositoryImpl implements StockRepository {
  Future<bool> _hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<StockItem>> getWarehouseStock(String branchId) async {
    // Connect to Supabase 'products' or 'stock' table
    return []; // Empty for now, to be implemented
  }

  @override
  Future<List<StockItem>> getClientStock(String clientId) async {
    return [];
  }

  @override
  Future<StockItem> updateStock(StockItem item) async {
    return item;
  }

  @override
  Future<List<StockItem>> searchProducts(String query) async {
    return [];
  }
}
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Supabase Repositories generated.")
