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
import '../../data/auth_repository_impl.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends ConsumerState<PhoneVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Simulate network
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _codeSent = true;
      });
    }
  }

  void _verifyCode() async {
    if (_otpController.text.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authControllerProvider.notifier).verifyPhone('+201000000000', _otpController.text);
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (mounted) context.go(AppRouter.home);
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
        title: Text('phone_number'.tr()),
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
                    _codeSent ? 'Enter OTP' : 'Enter your phone number',
                    style: AppTextStyles.headingSection,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (!_codeSent) ...[
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'phone_number'.tr(),
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Send Code',
                      isLoading: _isLoading,
                      onPressed: _sendCode,
                    ),
                  ] else ...[
                    AppTextField(
                      controller: _otpController,
                      labelText: 'OTP Code',
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.requiredField(v, 'OTP'),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Verify',
                      isLoading: _isLoading,
                      onPressed: _verifyCode,
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
