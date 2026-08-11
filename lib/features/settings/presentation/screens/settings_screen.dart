import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language, color: AppColors.primary),
                title: Text('language'.tr(), style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                trailing: DropdownButton<String>(
                  value: context.locale.languageCode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      context.setLocale(Locale(val));
                    }
                  },
                ),
              ),
              const Divider(),
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint, color: AppColors.primary),
                title: Text('biometric_login'.tr(), style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                value: settings['biometric'] ?? false,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).toggleBiometric(val);
                },
              ),
              const Divider(),
              SwitchListTile(
                secondary: const Icon(Icons.notifications, color: AppColors.primary),
                title: Text('push_notifications'.tr(), style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                value: settings['notifications'] ?? true,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).toggleNotifications(val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
