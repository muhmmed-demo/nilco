enum OrderStatus { pending, approvedByManager, sentToWarehouse, fulfilled, cancelled }

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
