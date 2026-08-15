import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/services/notification_service.dart';
import 'core/di/dependency_injection.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key',
  );
  await Hive.initFlutter();
  
  // Note: Generate firebase_options.dart using FlutterFire CLI and pass options here
  await Firebase.initializeApp();
  await NotificationService.init();

  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/l10n',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const SaytaraAppWrapper(),
      ),
    ),
  );
}

class SaytaraAppWrapper extends ConsumerWidget {
  const SaytaraAppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        ref.read(syncServiceProvider).processQueue();
      }
    });

    return const SaytaraApp();
  }
}
