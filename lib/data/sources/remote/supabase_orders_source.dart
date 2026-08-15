import 'package:supabase_flutter/supabase_flutter.dart';
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
