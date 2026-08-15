import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/stock_model.dart';
import '../../../../core/repositories/mock/mock_stock_repository.dart';
import '../../orders/providers/rep_orders_provider.dart';

final stockRepoProvider = Provider((ref) => MockStockRepository());

// Used for client dropdown in stock screen
final stockClientProvider = StateProvider<String?>((ref) => null);

final clientStockProvider = FutureProvider<List<StockItem>>((ref) async {
  final clientId = ref.watch(stockClientProvider);
  if (clientId == null) return [];
  
  final repo = ref.watch(stockRepoProvider);
  return repo.getClientStock(clientId);
});
import '../../../../core/di/dependency_injection.dart';