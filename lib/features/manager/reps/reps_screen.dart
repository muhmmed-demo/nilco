import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../home/providers/manager_dashboard_provider.dart';
import '../home/widgets/manager_bottom_nav.dart';

class RepsListScreen extends ConsumerWidget {
  const RepsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reps = ref.watch(managerRepsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('المناديب', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reps.length,
        itemBuilder: (context, index) {
          final rep = reps[index];
          return AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              title: Text('${rep.firstName} ${rep.lastName}', style: AppTextStyles.bodyMainBold),
              subtitle: Text(rep.phone, style: AppTextStyles.caption),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to rep details
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const ManagerBottomNav(currentIndex: 2),
    );
  }
}
