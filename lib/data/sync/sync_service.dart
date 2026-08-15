import 'sync_queue.dart';
import '../sources/remote/supabase_orders_source.dart';

class SyncService {
  final SyncQueue _queue;
  final SupabaseOrdersSource _remote;

  SyncService(this._queue, this._remote);

  Future<void> processQueue() async {
    final ops = await _queue.getPending();
    for (var i = 0; i < ops.length; i++) {
      try {
        final op = ops[i];
        switch (op.type) {
          case 'create_order':
            await _remote.createOrder(op.payload['order'], op.payload['items']);
            break;
          // أضف أنواع تانية هنا
        }
        await _queue.removeOperation(i);
      } catch (e) {
        print('Sync failed: $e');
        break; // وقف عشان نحاول تاني لما يجي نت
      }
    }
  }
}
