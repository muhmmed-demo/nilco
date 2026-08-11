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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authControllerProvider.notifier).register(
            _firstNameController.text,
            _lastNameController.text,
            _usernameController.text,
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
        // Based on the plan, go to phone verification after sign up
        context.push(AppRouter.phoneVerification);
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: AppColors.error),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ParallaxWidget(
              tiltFactor: 0.05,
              child: AppCard(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'signup'.tr(),
                        style: AppTextStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _firstNameController,
                              labelText: 'first_name'.tr(),
                              validator: (v) => Validators.requiredField(v, 'first_name'.tr()),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              controller: _lastNameController,
                              labelText: 'last_name'.tr(),
                              validator: (v) => Validators.requiredField(v, 'last_name'.tr()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _usernameController,
                        labelText: 'username'.tr(),
                        validator: (v) => Validators.requiredField(v, 'username'.tr()),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _emailController,
                        labelText: 'email'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'password'.tr(),
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _confirmPasswordController,
                        labelText: 'confirm_password'.tr(),
                        obscureText: true,
                        validator: (v) => Validators.confirmPassword(v, _passwordController.text),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: 'signup'.tr(),
                        isLoading: authState is AuthLoading,
                        onPressed: _handleSignUp,
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
