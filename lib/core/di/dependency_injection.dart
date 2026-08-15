import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sources/remote/supabase_auth_source.dart';
import '../../data/sources/remote/supabase_orders_source.dart';
import '../../data/sources/local/hive_auth_cache.dart';
import '../../data/sources/local/hive_cache.dart';
import '../../data/repositories/supabase/supabase_auth_repository_impl.dart';
import '../../data/repositories/supabase/supabase_orders_repository_impl.dart';
import '../../data/repositories/supabase/supabase_stock_repository_impl.dart';
import '../repositories/mock/mock_orders_repository.dart';
import '../repositories/mock/mock_stock_repository.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/data/auth_repository.dart';
import '../repositories/orders_repository.dart';
import '../repositories/stock_repository.dart';

// --- 1. Sources & Caches ---
final supabaseAuthSourceProvider = Provider((ref) => SupabaseAuthSource());
final supabaseOrdersSourceProvider = Provider((ref) => SupabaseOrdersSource());
final hiveAuthCacheProvider = Provider((ref) => HiveAuthCache());
final hiveOrdersCacheProvider = Provider((ref) => HiveOrdersCache());

// --- 2. Mock Repositories (Fallback) ---
final mockAuthRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl());
final mockOrdersRepositoryProvider = Provider<OrdersRepository>((ref) => MockOrdersRepository());
final mockStockRepositoryProvider = Provider<StockRepository>((ref) => MockStockRepository());

// --- 3. Supabase Repositories ---
final supabaseAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepositoryImpl(
    ref.watch(supabaseAuthSourceProvider),
    ref.watch(hiveAuthCacheProvider),
  );
});

final supabaseOrdersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return SupabaseOrdersRepositoryImpl(
    ref.watch(supabaseOrdersSourceProvider),
    ref.watch(hiveOrdersCacheProvider),
  );
});

final supabaseStockRepositoryProvider = Provider<StockRepository>((ref) {
  return SupabaseStockRepositoryImpl();
});

// --- 4. Main Active Providers (Switched to Supabase) ---
final authRepositoryProvider = Provider<AuthRepository>((ref) => ref.watch(supabaseAuthRepositoryProvider));

// Order Repositories used by different features
final repOrdersRepoProvider = Provider<OrdersRepository>((ref) => ref.watch(supabaseOrdersRepositoryProvider));
final managerOrdersRepoProvider = Provider<OrdersRepository>((ref) => ref.watch(supabaseOrdersRepositoryProvider));
final warehouseOrdersRepoProvider = Provider<OrdersRepository>((ref) => ref.watch(supabaseOrdersRepositoryProvider));

// Stock Repositories used by different features
final clientStockRepoProvider = Provider<StockRepository>((ref) => ref.watch(supabaseStockRepositoryProvider));
final warehouseStockRepoProvider = Provider<StockRepository>((ref) => ref.watch(supabaseStockRepositoryProvider));
