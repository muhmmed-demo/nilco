import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/parallax_widget.dart';
import '../providers/training_provider.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(trainingModulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('training'.tr()),
      ),
      body: modulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (modules) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(trainingModulesProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: modules.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final module = modules[index];
                return ParallaxWidget(
                  tiltFactor: 0.03,
                  child: AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            module.category,
                            style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(module.title, style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: module.progress,
                                backgroundColor: AppColors.border,
                                color: module.progress == 1.0 ? AppColors.success : AppColors.primary,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('${(module.progress * 100).toInt()}%', style: AppTextStyles.bodySecondary),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
