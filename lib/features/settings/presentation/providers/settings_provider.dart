import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provides a SharedPreferences instance. Must be overridden in main.dart!
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

class SettingsNotifier extends StateNotifier<Map<String, bool>> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super({
    'biometric': _prefs.getBool('biometric') ?? false,
    'notifications': _prefs.getBool('notifications') ?? true,
  });

  Future<void> toggleBiometric(bool value) async {
    await _prefs.setBool('biometric', value);
    state = {...state, 'biometric': value};
  }

  Future<void> toggleNotifications(bool value) async {
    await _prefs.setBool('notifications', value);
    state = {...state, 'notifications': value};
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map<String, bool>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});
