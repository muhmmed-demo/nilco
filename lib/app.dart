import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class SaytaraApp extends ConsumerWidget {
  const SaytaraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Saytara',
      theme: AppTheme.darkTheme,
      // Localization setup
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // Router setup
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
