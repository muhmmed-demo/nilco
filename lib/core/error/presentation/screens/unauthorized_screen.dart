import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../router/app_router.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.lock_clock,
                size: 100,
                color: AppColors.warning,
              ),
              const SizedBox(height: 32),
              Text(
                'session_expired'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Your session has expired for security reasons. Please log in again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 48),
              AppButton(
                text: 'login'.tr(),
                onPressed: () {
                  // Force routing to login
                  context.go(AppRouter.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
