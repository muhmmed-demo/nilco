import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/rep_dashboard_provider.dart';

class TodayRoutePreview extends ConsumerWidget {
  const TodayRoutePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAsync = ref.watch(todayRouteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('خط سير اليوم', style: AppTextStyles.headingSmall),
            TextButton(
              onPressed: () {}, // Navigate to full route
              child: const Text('عرض الكل'),
            )
          ],
        ),
        const SizedBox(height: 8),
        routeAsync.when(
          data: (route) {
            if (route == null || route.stops.isEmpty) {
              return const AppCard(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('لا يوجد خط سير مسجل لليوم.'),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: route.stops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final stop = route.stops[index];
                return AppCard(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: stop.isVisited ? AppColors.success.withOpacity(0.2) : AppColors.background,
                      child: Icon(
                        stop.isVisited ? Icons.check : Icons.store,
                        color: stop.isVisited ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                    title: Text(stop.clientName, style: AppTextStyles.bodyMainBold),
                    subtitle: Text(stop.address, style: AppTextStyles.caption),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Text('Error: $e'),
        ),
      ],
    );
  }
}
