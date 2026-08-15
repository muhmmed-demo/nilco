import 'package:hive/hive.dart';
import 'sync_operation.dart';

class SyncQueue {
  static const String _boxName = 'sync_queue';
  
  Future<void> addOperation(SyncOperation op) async {
    final box = await Hive.openBox<Map>(_boxName);
    await box.add(op.toJson());
  }
  
  Future<List<SyncOperation>> getPending() async {
    final box = await Hive.openBox<Map>(_boxName);
    return box.values.map((e) => SyncOperation.fromJson(e)).toList();
  }
  
  Future<void> removeOperation(int index) async {
    final box = await Hive.openBox<Map>(_boxName);
    await box.deleteAt(index);
  }
  
  Future<void> clear() async {
    final box = await Hive.openBox<Map>(_boxName);
    await box.clear();
  }
}
