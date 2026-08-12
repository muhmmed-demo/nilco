import os

mock_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\core\mock"
os.makedirs(mock_dir, exist_ok=True)

repos_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\core\repositories"
mock_repos_dir = os.path.join(repos_dir, "mock")
os.makedirs(mock_repos_dir, exist_ok=True)

mock_data_content = """import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/visit_model.dart';
import '../models/route_model.dart';
import '../models/stock_model.dart';
import '../models/client_model.dart';
import '../models/performance_model.dart';

class MockData {
  static final UserModel salesRep = UserModel(
    id: 'rep_001',
    firstName: 'أحمد',
    lastName: 'علي',
    username: 'ahmed_rep',
    email: 'test@saytara.com',
    phone: '01000000001',
    role: UserRole.salesRep,
    token: 'token_rep_123',
    companyName: 'نيلكو',
    regionId: 'reg_01',
  );

  static final UserModel manager = UserModel(
    id: 'mgr_001',
    firstName: 'محمود',
    lastName: 'حسن',
    username: 'mahmoud_mgr',
    email: 'manager@saytara.com',
    phone: '01000000002',
    role: UserRole.manager,
    token: 'token_mgr_123',
    companyName: 'نيلكو',
    branchId: 'br_01',
  );

  static final UserModel warehouse = UserModel(
    id: 'wh_001',
    firstName: 'كريم',
    lastName: 'سامي',
    username: 'karim_wh',
    email: 'warehouse@saytara.com',
    phone: '01000000003',
    role: UserRole.warehouse,
    token: 'token_wh_123',
    companyName: 'نيلكو',
    branchId: 'br_01',
  );

  static final List<ClientModel> clients = [
    ClientModel(id: 'c1', name: 'مكتبة جرير', phone: '0111111', address: 'الرياض', latitude: 24.71, longitude: 46.67, regionId: 'reg_01'),
    ClientModel(id: 'c2', name: 'ألعاب الحسين', phone: '0222222', address: 'جدة', latitude: 21.48, longitude: 39.18, regionId: 'reg_01'),
    ClientModel(id: 'c3', name: 'مكتبة العبيكان', phone: '0333333', address: 'الدمام', latitude: 26.42, longitude: 50.08, regionId: 'reg_01'),
  ];

  static final List<StockItem> warehouseStock = [
    StockItem(id: 's1', productId: 'p1', productName: 'لعبة بازل', productCode: 'PZ-01', quantity: 500, location: StockLocation.warehouse, locationId: 'br_01', updatedAt: DateTime.now(), updatedById: 'wh_001'),
    StockItem(id: 's2', productId: 'p2', productName: 'سيارة ريموت', productCode: 'RC-02', quantity: 300, location: StockLocation.warehouse, locationId: 'br_01', updatedAt: DateTime.now(), updatedById: 'wh_001'),
  ];

  static final List<OrderModel> orders = [
    OrderModel(id: 'o1', repId: 'rep_001', clientId: 'c1', clientName: 'مكتبة جرير', items: [OrderItem(productId: 'p1', productName: 'لعبة بازل', quantity: 10, unitPrice: 50.0)], totalValue: 500.0, status: OrderStatus.pending, createdAt: DateTime.now()),
  ];

  static final List<VisitModel> visits = [
    VisitModel(id: 'v1', repId: 'rep_001', clientId: 'c1', clientName: 'مكتبة جرير', clientAddress: 'الرياض', photoUrls: [], status: VisitStatus.completed, scheduledAt: DateTime.now().subtract(const Duration(hours: 2)), arrivedAt: DateTime.now().subtract(const Duration(hours: 2)), completedAt: DateTime.now().subtract(const Duration(hours: 1))),
  ];

  static final RouteModel todayRoute = RouteModel(
    id: 'rt_01',
    repId: 'rep_001',
    repName: 'أحمد علي',
    date: DateTime.now(),
    isAssignedByManager: true,
    stops: [
      RouteStop(order: 1, clientId: 'c1', clientName: 'مكتبة جرير', address: 'الرياض', latitude: 24.71, longitude: 46.67, isVisited: true),
      RouteStop(order: 2, clientId: 'c2', clientName: 'ألعاب الحسين', address: 'جدة', latitude: 21.48, longitude: 39.18, isVisited: false),
    ],
  );
}
"""

with open(os.path.join(mock_dir, "mock_data.dart"), "w", encoding="utf-8") as f:
    f.write(mock_data_content)

repos = {
    "orders_repository.dart": """import '../models/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getRepOrders(String repId);
  Future<List<OrderModel>> getAllOrders();
  Future<List<OrderModel>> getIncomingOrders();
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus status, {String? note});
}
""",
    "visits_repository.dart": """import '../models/visit_model.dart';
import '../models/performance_model.dart';

abstract class VisitsRepository {
  Future<List<VisitModel>> getRepVisits(String repId, {DateRange? range});
  Future<List<VisitModel>> getAllVisits({DateRange? range});
  Future<VisitModel> createVisit(VisitModel visit);
  Future<VisitModel> updateVisit(String visitId, VisitModel updated);
}
""",
    "routes_repository.dart": """import '../models/route_model.dart';

abstract class RoutesRepository {
  Future<RouteModel?> getTodayRoute(String repId);
  Future<List<RouteModel>> getAllRoutes({String? repId});
  Future<RouteModel> createRoute(RouteModel route);
  Future<RouteModel> updateRoute(String routeId, RouteModel updated);
  Future<void> markStopVisited(String routeId, String clientId);
}
""",
    "stock_repository.dart": """import '../models/stock_model.dart';

abstract class StockRepository {
  Future<List<StockItem>> getWarehouseStock(String branchId);
  Future<List<StockItem>> getClientStock(String clientId);
  Future<StockItem> updateStock(StockItem item);
  Future<List<StockItem>> searchProducts(String query);
}
""",
    "performance_repository.dart": """import '../models/performance_model.dart';

abstract class PerformanceRepository {
  Future<PerformanceReport> getRepPerformance(String repId, DateRange period);
  Future<List<PerformanceReport>> getAllRepsPerformance(DateRange period);
}
"""
}

mock_repos = {
    "mock_orders_repository.dart": """import '../orders_repository.dart';
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
""",
    "mock_visits_repository.dart": """import '../visits_repository.dart';
import '../../models/visit_model.dart';
import '../../models/performance_model.dart';
import '../../mock/mock_data.dart';

class MockVisitsRepository implements VisitsRepository {
  @override
  Future<VisitModel> createVisit(VisitModel visit) async {
    await Future.delayed(const Duration(seconds: 1));
    MockData.visits.add(visit);
    return visit;
  }

  @override
  Future<List<VisitModel>> getAllVisits({DateRange? range}) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.visits;
  }

  @override
  Future<List<VisitModel>> getRepVisits(String repId, {DateRange? range}) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.visits.where((v) => v.repId == repId).toList();
  }

  @override
  Future<VisitModel> updateVisit(String visitId, VisitModel updated) async {
    await Future.delayed(const Duration(seconds: 1));
    return updated;
  }
}
""",
    "mock_routes_repository.dart": """import '../routes_repository.dart';
import '../../models/route_model.dart';
import '../../mock/mock_data.dart';

class MockRoutesRepository implements RoutesRepository {
  @override
  Future<RouteModel> createRoute(RouteModel route) async {
    await Future.delayed(const Duration(seconds: 1));
    return route;
  }

  @override
  Future<List<RouteModel>> getAllRoutes({String? repId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return [MockData.todayRoute];
  }

  @override
  Future<RouteModel?> getTodayRoute(String repId) async {
    await Future.delayed(const Duration(seconds: 1));
    if (repId == MockData.salesRep.id) return MockData.todayRoute;
    return null;
  }

  @override
  Future<void> markStopVisited(String routeId, String clientId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<RouteModel> updateRoute(String routeId, RouteModel updated) async {
    await Future.delayed(const Duration(seconds: 1));
    return updated;
  }
}
""",
    "mock_stock_repository.dart": """import '../stock_repository.dart';
import '../../models/stock_model.dart';
import '../../mock/mock_data.dart';

class MockStockRepository implements StockRepository {
  @override
  Future<List<StockItem>> getClientStock(String clientId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<List<StockItem>> getWarehouseStock(String branchId) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.warehouseStock.where((s) => s.locationId == branchId).toList();
  }

  @override
  Future<List<StockItem>> searchProducts(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.warehouseStock.where((s) => s.productName.contains(query)).toList();
  }

  @override
  Future<StockItem> updateStock(StockItem item) async {
    await Future.delayed(const Duration(seconds: 1));
    return item;
  }
}
""",
    "mock_performance_repository.dart": """import '../performance_repository.dart';
import '../../models/performance_model.dart';
import '../../mock/mock_data.dart';

class MockPerformanceRepository implements PerformanceRepository {
  @override
  Future<List<PerformanceReport>> getAllRepsPerformance(DateRange period) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<PerformanceReport> getRepPerformance(String repId, DateRange period) async {
    await Future.delayed(const Duration(seconds: 1));
    return PerformanceReport(
      repId: repId,
      repName: 'أحمد علي',
      period: period,
      totalClientsInRoute: 10,
      visitedClients: 8,
      coveragePercent: 80.0,
      totalSalesValue: 15000.0,
      ordersCount: 12,
      dailyBreakdown: [
        DailyPerformance(date: DateTime.now(), visits: 8, sales: 15000.0, dayLabel: 'اليوم'),
      ],
    );
  }
}
"""
}

for filename, content in repos.items():
    filepath = os.path.join(repos_dir, filename)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

for filename, content in mock_repos.items():
    filepath = os.path.join(mock_repos_dir, filename)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("All repos generated.")
