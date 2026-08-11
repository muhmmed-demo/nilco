import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
