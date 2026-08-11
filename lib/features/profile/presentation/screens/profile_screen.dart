import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/router/app_router.dart';
import '../../data/profile_repository.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.surfaceElevated,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
                const SizedBox(height: 24),
                Text('${profile.firstName} ${profile.lastName}', style: AppTextStyles.headingLarge),
                const SizedBox(height: 8),
                Text(profile.role, style: AppTextStyles.bodyMain.copyWith(color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(profile.email, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 48),
                AppButton(
                  text: 'logout'.tr(),
                  useGradient: false,
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).logout();
                    if (!context.mounted) return;
                    context.go(AppRouter.login);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
