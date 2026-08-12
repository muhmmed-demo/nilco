import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/rep_dashboard_provider.dart';

class PerformanceCards extends ConsumerWidget {
  const PerformanceCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfAsync = ref.watch(repPerformanceProvider);

    return perfAsync.when(
      data: (report) {
        if (report == null) return const SizedBox.shrink();
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'تغطية السير',
                value: '${report.coveragePercent.toInt()}%',
                icon: Icons.map_outlined,
                color: AppColors.secondary,
              ).animate().fade().scale(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'المبيعات',
                value: '${report.totalSalesValue / 1000}K',
                icon: Icons.attach_money,
                color: AppColors.success,
              ).animate().fade(delay: 100.ms).scale(delay: 100.ms),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'الزيارات',
                value: '${report.visitedClients}/${report.totalClientsInRoute}',
                icon: Icons.storefront,
                color: AppColors.primary,
              ).animate().fade(delay: 200.ms).scale(delay: 200.ms),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error: $e'),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headingMedium),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
