import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/archive_repository.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final archiveAsync = ref.watch(archivedTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('archive'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                if (!mounted) return;
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
          if (_selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => _selectedDate = null),
            )
        ],
      ),
      body: archiveAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (tasks) {
          final filteredTasks = _selectedDate == null
              ? tasks
              : tasks.where((t) =>
                  t.completedAt.year == _selectedDate!.year &&
                  t.completedAt.month == _selectedDate!.month &&
                  t.completedAt.day == _selectedDate!.day).toList();

          if (filteredTasks.isEmpty) {
            return Center(
              child: Text(
                'no_archived_tasks'.tr(),
                style: AppTextStyles.bodySecondary,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(archivedTasksProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return AppCard(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: AppColors.success),
                    title: Text(task.title, style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(task.details, style: AppTextStyles.bodySecondary),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM dd, yyyy - hh:mm a').format(task.completedAt),
                          style: AppTextStyles.bodySecondary.copyWith(fontSize: 12, color: AppColors.primary),
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
