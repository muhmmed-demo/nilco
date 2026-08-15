import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\data\sources"
remote_dir = os.path.join(base_dir, "remote")
local_dir = os.path.join(base_dir, "local")

os.makedirs(remote_dir, exist_ok=True)
os.makedirs(local_dir, exist_ok=True)

files = {}

# 1. supabase_auth_source.dart
files[os.path.join(remote_dir, "supabase_auth_source.dart")] = """import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_client.dart';

class SupabaseAuthSource {
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  Stream<AuthState> onAuthStateChange() {
    return supabase.auth.onAuthStateChange;
  }
}
"""

# 2. supabase_orders_source.dart
files[os.path.join(remote_dir, "supabase_orders_source.dart")] = """import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_client.dart';

class SupabaseOrdersSource {
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> order, List<Map<String, dynamic>> items) async {
    // Start a transaction implicitly by using RPC or just insert sequentially.
    // Assuming inserting order then items
    final response = await supabase.from('orders').insert(order).select().single();
    final orderId = response['id'];
    
    if (items.isNotEmpty) {
      final itemsToInsert = items.map((e) => {...e, 'order_id': orderId}).toList();
      await supabase.from('order_items').insert(itemsToInsert);
    }
    
    return response;
  }

  Future<List<Map<String, dynamic>>> getOrdersByRep(String repId) async {
    return await supabase.from('orders').select('*, order_items(*)').eq('sales_rep_id', repId).order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    return await supabase.from('orders').select('*, order_items(*)').eq('status', 'pending').order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getApprovedOrders() async {
    return await supabase.from('orders').select('*, order_items(*)').eq('status', 'approved').order('created_at', ascending: false);
  }

  Future<void> approveOrder(String orderId, String managerId) async {
    await supabase.from('orders').update({
      'status': 'approved',
      'approved_by': managerId,
      'approved_at': DateTime.now().toIso8601String(),
    }).eq('id', orderId);
  }

  Future<void> rejectOrder(String orderId) async {
    await supabase.from('orders').update({
      'status': 'rejected',
    }).eq('id', orderId);
  }

  Future<void> fulfillOrder(String orderId, String warehouseId) async {
    await supabase.from('orders').update({
      'status': 'fulfilled',
      'fulfilled_by': warehouseId,
      'fulfilled_at': DateTime.now().toIso8601String(),
    }).eq('id', orderId);
  }
}
"""

# 3. hive_cache.dart
files[os.path.join(local_dir, "hive_cache.dart")] = """import 'package:hive/hive.dart';

class HiveOrdersCache {
  static const String _boxName = 'orders_cache';

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  Future<void> cacheOrders(List<dynamic> orders) async {
    final box = await _getBox();
    await box.put('orders', orders);
  }

  Future<List<dynamic>> getCachedOrders() async {
    final box = await _getBox();
    return box.get('orders', defaultValue: []) ?? [];
  }

  Future<void> clearCache() async {
    final box = await _getBox();
    await box.clear();
  }
}
"""

# 4. hive_auth_cache.dart
files[os.path.join(local_dir, "hive_auth_cache.dart")] = """import 'package:hive/hive.dart';

class HiveAuthCache {
  static const String _boxName = 'auth_cache';

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  Future<void> cacheUser(Map<String, dynamic> userData) async {
    final box = await _getBox();
    await box.put('user', userData);
  }

  Future<Map<String, dynamic>?> getCachedUser() async {
    final box = await _getBox();
    final data = box.get('user');
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  Future<void> clearAuth() async {
    final box = await _getBox();
    await box.delete('user');
  }
}
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Data sources generated.")
