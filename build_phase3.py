import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\features\rep\home"
widgets_dir = os.path.join(base_dir, "widgets")
providers_dir = os.path.join(base_dir, "providers")

os.makedirs(widgets_dir, exist_ok=True)
os.makedirs(providers_dir, exist_ok=True)

files = {}

files[os.path.join(providers_dir, "rep_dashboard_provider.dart")] = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/route_model.dart';
import '../../../../core/models/performance_model.dart';
import '../../../../core/repositories/mock/mock_routes_repository.dart';
import '../../../../core/repositories/mock/mock_performance_repository.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

final routesRepositoryProvider = Provider((ref) => MockRoutesRepository());
final performanceRepositoryProvider = Provider((ref) => MockPerformanceRepository());

final todayRouteProvider = FutureProvider<RouteModel?>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(routesRepositoryProvider);
    return repo.getTodayRoute(authState.user.id);
  }
  return null;
});

final repPerformanceProvider = FutureProvider<PerformanceReport?>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(performanceRepositoryProvider);
    return repo.getRepPerformance(
      authState.user.id, 
      DateRange(from: DateTime.now().subtract(const Duration(days: 30)), to: DateTime.now())
    );
  }
  return null;
});
"""

files[os.path.join(widgets_dir, "greeting_section.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class GreetingSection extends ConsumerWidget {
  const GreetingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final String name = authState is AuthAuthenticated ? authState.user.firstName : 'Mendob';
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM', 'ar'); // Requires locale setup or default

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً يا $name 👋',
              style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(now),
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
      ],
    );
  }
}
"""

files[os.path.join(widgets_dir, "performance_cards.dart")] = """import 'package:flutter/material.dart';
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
"""

files[os.path.join(widgets_dir, "today_route_preview.dart")] = """import 'package:flutter/material.dart';
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
"""

files[os.path.join(widgets_dir, "quick_actions.dart")] = """import 'package:flutter/material.dart';
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
"""

files[os.path.join(widgets_dir, "rep_bottom_nav.dart")] = """import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class RepBottomNav extends StatelessWidget {
  final int currentIndex;

  const RepBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/rep/home');
        break;
      case 1:
        context.go('/rep/route');
        break;
      case 2:
        context.go('/rep/orders');
        break;
      case 3:
        context.go('/rep/performance');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(index, context),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'خط السير'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الطلبيات'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'الأداء'),
      ],
    );
  }
}
"""

files[os.path.join(base_dir, "home_screen.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/greeting_section.dart';
import 'widgets/performance_cards.dart';
import 'widgets/today_route_preview.dart';
import 'widgets/quick_actions.dart';
import 'widgets/rep_bottom_nav.dart';

class RepHomeScreen extends StatelessWidget {
  const RepHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingSection().animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              const PerformanceCards(),
              const SizedBox(height: 24),
              const QuickActions().animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),
              const SizedBox(height: 24),
              const TodayRoutePreview().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const RepBottomNav(currentIndex: 0),
    );
  }
}
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Phase 3 Rep Dashboard components generated.")
