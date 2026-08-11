import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/parallax_widget.dart';
import '../../data/activity_repository.dart';
import '../providers/activity_provider.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  Color _getStatusColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.completed:
        return AppColors.success;
      case ActivityStatus.pending:
        return AppColors.warning;
      case ActivityStatus.overdue:
        return AppColors.error;
    }
  }

  String _getStatusText(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.completed:
        return 'completed'.tr();
      case ActivityStatus.pending:
        return 'pending'.tr();
      case ActivityStatus.overdue:
        return 'overdue'.tr();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(activityTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('activity'.tr()),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (tasks) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(activityTasksProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ParallaxWidget(
                  tiltFactor: 0.03,
                  child: AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(task.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title, style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(task.storeName, style: AppTextStyles.bodySecondary),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getStatusText(task.status),
                                    style: TextStyle(
                                      color: _getStatusColor(task.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM dd, hh:mm a').format(task.dueDate),
                                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
