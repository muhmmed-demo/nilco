import '../stock_repository.dart';
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
