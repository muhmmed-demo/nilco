import 'package:hive/hive.dart';

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
