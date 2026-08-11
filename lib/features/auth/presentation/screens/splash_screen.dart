import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some loading time for the splash screen
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final authState = ref.read(authControllerProvider);
      _navigateBasedOnState(authState);
    });
  }

  void _navigateBasedOnState(AuthState state) {
    if (state is AuthAuthenticated) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      // Only navigate if we're not still in the artificial delay
      // In a real app, you might sync this better.
    });

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo or Lottie Animation
            Icon(Icons.sports_mma, size: 100, color: AppColors.primary),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
