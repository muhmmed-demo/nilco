import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary (Nilco Cyan/Blue)
  static const Color primary = Color(0xFF009CDE); // Example Nilco Blue
  static const Color primaryDark = Color(0xFF0077A8);
  static const Color primaryLight = Color(0xFF4AC4FF);
  static const Color secondary = Color(0xFF2E86AB);

  // Backgrounds (Dark Mode Default)
  static const Color background = Color(0xFF121214);
  static const Color surface = Color(0xFF1C1C1F);
  static const Color surfaceElevated = Color(0xFF232327);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF9A9AA2);

  // Status & Gamification
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE74C3C);
  static const Color goldCoins = Color(0xFFF2C94C);

  // Borders & Dividers
  static const Color border = Color(0xFF2C2C30);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF2C94C), Color(0xFFF2994A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
