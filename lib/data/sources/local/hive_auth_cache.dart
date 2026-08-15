import 'package:hive/hive.dart';

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
