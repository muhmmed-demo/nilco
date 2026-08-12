import '../models/stock_model.dart';

abstract class StockRepository {
  Future<List<StockItem>> getWarehouseStock(String branchId);
  Future<List<StockItem>> getClientStock(String clientId);
  Future<StockItem> updateStock(StockItem item);
  Future<List<StockItem>> searchProducts(String query);
}
