import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const EmptyState({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: AppTextStyles.headingSection,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
