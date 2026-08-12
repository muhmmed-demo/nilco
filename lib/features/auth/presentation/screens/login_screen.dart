import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/parallax_widget.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_state.dart';
import '../../../../core/models/user_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: '55555');
  final _passwordController = TextEditingController(text: '55555');
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authControllerProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        switch (next.user.role) {
          case UserRole.salesRep:
            context.go('/rep/home');
            break;
          case UserRole.manager:
            context.go('/manager/home');
            break;
          case UserRole.warehouse:
            context.go('/warehouse/home');
            break;
        }
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: AppColors.error),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ParallaxWidget(
              tiltFactor: 0.08,
              child: AppCard(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo placeholder
                      const Icon(Icons.sports_mma, size: 80, color: AppColors.primary),
                      const SizedBox(height: 24),
                      Text(
                        'login'.tr(),
                        style: AppTextStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppTextField(
                        controller: _emailController,
                        labelText: 'email'.tr(),
                        keyboardType: TextInputType.text,
                        validator: (val) => val == null || val.isEmpty ? 'validation.email_required'.tr() : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'password'.tr(),
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                activeColor: AppColors.primary,
                              ),
                              Text('remember_me'.tr(), style: AppTextStyles.bodySecondary),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.push(AppRouter.forgotPassword),
                            child: Text(
                              'forgot_password'.tr(),
                              style: AppTextStyles.bodySecondary.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'login'.tr(),
                        isLoading: authState is AuthLoading,
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.push(AppRouter.signUp),
                        child: Text(
                          'signup'.tr(), // Needs to be added to ar.json/en.json if missing
                          style: AppTextStyles.bodyMain.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
