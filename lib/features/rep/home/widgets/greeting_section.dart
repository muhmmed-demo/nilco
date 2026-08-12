import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class GreetingSection extends ConsumerWidget {
  const GreetingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final String name = authState is AuthAuthenticated ? authState.user.firstName : 'Mendob';
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM', 'ar'); // Requires locale setup or default

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً يا $name 👋',
              style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(now),
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
      ],
    );
  }
}
