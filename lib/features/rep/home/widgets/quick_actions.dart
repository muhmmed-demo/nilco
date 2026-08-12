import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إجراءات سريعة', style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionBtn(
                title: 'زيارة جديدة',
                icon: Icons.add_location_alt,
                color: AppColors.primary,
                onTap: () => context.push('/rep/visit/new'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionBtn(
                title: 'طلب جديد',
                icon: Icons.shopping_cart_checkout,
                color: AppColors.secondary,
                onTap: () => context.push('/rep/order/new'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.bodyMainBold.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
