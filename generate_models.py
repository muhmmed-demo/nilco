import os

models_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\core\models"
os.makedirs(models_dir, exist_ok=True)

models = {
    "user_model.dart": """enum UserRole {
  salesRep,
  manager,
  warehouse,
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String token;
  final String companyName;
  final String? branchId;
  final String? regionId;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    required this.token,
    required this.companyName,
    this.branchId,
    this.regionId,
  });
}
""",
    "order_model.dart": """enum OrderStatus { pending, approvedByManager, sentToWarehouse, fulfilled, cancelled }

class OrderModel {
  final String id;
  final String repId;
  final String clientId;
  final String clientName;
  final List<OrderItem> items;
  final double totalValue;
  final OrderStatus status;
  final DateTime createdAt;
  final String? managerNote;
  final String? warehouseNote;

  OrderModel({
    required this.id,
    required this.repId,
    required this.clientId,
    required this.clientName,
    required this.items,
    required this.totalValue,
    required this.status,
    required this.createdAt,
    this.managerNote,
    this.warehouseNote,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
}
""",
    "visit_model.dart": """enum VisitStatus { planned, inProgress, completed, skipped }

class VisitModel {
  final String id;
  final String repId;
  final String clientId;
  final String clientName;
  final String clientAddress;
  final double? latitude;
  final double? longitude;
  final List<String> photoUrls;
  final String? notes;
  final VisitStatus status;
  final DateTime scheduledAt;
  final DateTime? arrivedAt;
  final DateTime? completedAt;

  VisitModel({
    required this.id,
    required this.repId,
    required this.clientId,
    required this.clientName,
    required this.clientAddress,
    this.latitude,
    this.longitude,
    required this.photoUrls,
    this.notes,
    required this.status,
    required this.scheduledAt,
    this.arrivedAt,
    this.completedAt,
  });
}
""",
    "route_model.dart": """class RouteModel {
  final String id;
  final String repId;
  final String repName;
  final DateTime date;
  final List<RouteStop> stops;
  final bool isAssignedByManager;

  RouteModel({
    required this.id,
    required this.repId,
    required this.repName,
    required this.date,
    required this.stops,
    required this.isAssignedByManager,
  });
}

class RouteStop {
  final int order;
  final String clientId;
  final String clientName;
  final String address;
  final double latitude;
  final double longitude;
  final bool isVisited;

  RouteStop({
    required this.order,
    required this.clientId,
    required this.clientName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isVisited,
  });
}
""",
    "stock_model.dart": """enum StockLocation { warehouse, client }

class StockItem {
  final String id;
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final StockLocation location;
  final String locationId;
  final DateTime updatedAt;
  final String updatedById;

  StockItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.location,
    required this.locationId,
    required this.updatedAt,
    required this.updatedById,
  });
}
""",
    "client_model.dart": """class ClientModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final String regionId;
  final String? assignedRepId;
  final DateTime? lastVisitDate;

  ClientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.regionId,
    this.assignedRepId,
    this.lastVisitDate,
  });
}
""",
    "performance_model.dart": """class PerformanceReport {
  final String repId;
  final String repName;
  final DateRange period;
  final int totalClientsInRoute;
  final int visitedClients;
  final double coveragePercent;
  final double totalSalesValue;
  final int ordersCount;
  final List<DailyPerformance> dailyBreakdown;

  PerformanceReport({
    required this.repId,
    required this.repName,
    required this.period,
    required this.totalClientsInRoute,
    required this.visitedClients,
    required this.coveragePercent,
    required this.totalSalesValue,
    required this.ordersCount,
    required this.dailyBreakdown,
  });
}

class DailyPerformance {
  final DateTime date;
  final int visits;
  final double sales;
  final String dayLabel;

  DailyPerformance({
    required this.date,
    required this.visits,
    required this.sales,
    required this.dayLabel,
  });
}

class DateRange {
  final DateTime from;
  final DateTime to;

  DateRange({required this.from, required this.to});
}
"""
}

for filename, content in models.items():
    filepath = os.path.join(models_dir, filename)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Created {filename}")

print("All models generated.")
