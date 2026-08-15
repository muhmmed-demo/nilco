import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib"
di_dir = os.path.join(base_dir, "core", "di")
os.makedirs(di_dir, exist_ok=True)

# 1. Create dependency_injection.dart
di_content = """import 'package:flutter_riverpod/flutter_riverpod.dart';
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
"""

with open(os.path.join(di_dir, "dependency_injection.dart"), "w", encoding="utf-8") as f:
    f.write(di_content)

def remove_lines_and_add_import(filepath, lines_to_remove, import_statement):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for line in lines_to_remove:
        content = content.replace(line, "")
    
    if import_statement not in content:
        # Add import after first import
        parts = content.split('\\n')
        for i, p in enumerate(parts):
            if p.startswith('import '):
                parts.insert(i + 1, import_statement)
                break
        content = "\\n".join(parts)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

# 2. Update auth_repository_impl.dart
auth_repo_impl = os.path.join(base_dir, "features", "auth", "data", "auth_repository_impl.dart")
remove_lines_and_add_import(
    auth_repo_impl, 
    [
        "// Provider for injecting the repository\\n",
        "final authRepositoryProvider = Provider<AuthRepository>((ref) {\\n  return AuthRepositoryImpl();\\n});\\n"
    ],
    ""
)

# 3. Update auth_controller.dart (add import to DI)
auth_controller = os.path.join(base_dir, "features", "auth", "presentation", "providers", "auth_controller.dart")
remove_lines_and_add_import(auth_controller, [], "import '../../../../core/di/dependency_injection.dart';")

# 4. Update rep_orders_provider.dart
rep_orders = os.path.join(base_dir, "features", "rep", "orders", "providers", "rep_orders_provider.dart")
remove_lines_and_add_import(
    rep_orders,
    [
        "final repOrdersRepoProvider = Provider((ref) => MockOrdersRepository());\\n",
        "final clientStockRepoProvider = Provider((ref) => MockStockRepository());\\n"
    ],
    "import '../../../../core/di/dependency_injection.dart';"
)

# 5. Update client_stock_provider.dart
client_stock = os.path.join(base_dir, "features", "rep", "stock", "providers", "client_stock_provider.dart")
remove_lines_and_add_import(
    client_stock,
    [
        "final clientStockRepoProvider = Provider((ref) => MockStockRepository());\\n"
    ],
    "import '../../../../core/di/dependency_injection.dart';"
)

# 6. Update manager_dashboard_provider.dart
manager_dashboard = os.path.join(base_dir, "features", "manager", "home", "providers", "manager_dashboard_provider.dart")
remove_lines_and_add_import(
    manager_dashboard,
    [
        "final managerOrdersRepoProvider = Provider((ref) => MockOrdersRepository());\\n"
    ],
    "import '../../../../core/di/dependency_injection.dart';"
)

# 7. Update warehouse_dashboard_provider.dart
warehouse_dashboard = os.path.join(base_dir, "features", "warehouse", "home", "providers", "warehouse_dashboard_provider.dart")
remove_lines_and_add_import(
    warehouse_dashboard,
    [
        "final warehouseOrdersRepoProvider = Provider((ref) => MockOrdersRepository());\\n",
        "final warehouseStockRepoProvider = Provider((ref) => MockStockRepository());\\n"
    ],
    "import '../../../../core/di/dependency_injection.dart';"
)

print("DI centralization applied.")
