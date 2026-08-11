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
import '../../../../core/utils/validators.dart';
import '../providers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _sendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authControllerProvider.notifier).forgotPassword(_emailController.text.trim());
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _codeSent = true;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authControllerProvider.notifier).resetPassword(
          _emailController.text.trim(),
          _otpController.text.trim(),
          _newPasswordController.text.trim(),
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully'), backgroundColor: AppColors.success),
          );
          context.go(AppRouter.login);
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('forgot_password'.tr()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _codeSent ? 'Enter OTP and New Password' : 'Enter your email to reset password',
                    style: AppTextStyles.headingSection,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (!_codeSent) ...[
                    AppTextField(
                      controller: _emailController,
                      labelText: 'email'.tr(),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Send Reset Link',
                      isLoading: _isLoading,
                      onPressed: _sendResetEmail,
                    ),
                  ] else ...[
                    AppTextField(
                      controller: _otpController,
                      labelText: 'OTP Code',
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.requiredField(v, 'OTP'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _newPasswordController,
                      labelText: 'New Password',
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Reset Password',
                      isLoading: _isLoading,
                      onPressed: _resetPassword,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
