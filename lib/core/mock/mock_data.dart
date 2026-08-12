import '../models/user_model.dart';
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
