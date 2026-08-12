enum StockLocation { warehouse, client }

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
