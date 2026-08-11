import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../router/app_router.dart';

class DisconnectScreen extends StatelessWidget {
  const DisconnectScreen({Key? key}) : super(key: key);

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
                Icons.wifi_off_rounded,
                size: 100,
                color: AppColors.error,
              ),
              const SizedBox(height: 32),
              Text(
                'no_connection'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 48),
              AppButton(
                text: 'retry'.tr(),
                onPressed: () {
                  // In a real app, this would re-check connection status.
                  // For now, we pop to simulate a successful retry if they hit it.
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRouter.home);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
