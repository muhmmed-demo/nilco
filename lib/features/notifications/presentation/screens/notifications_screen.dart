import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/notifications_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr()),
      ),
      body: notifsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'no_notifications'.tr(),
                style: AppTextStyles.bodySecondary,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return InkWell(
                onTap: () {
                  if (!notif.isRead) {
                    ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                  }
                },
                child: AppCard(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: notif.isRead ? Colors.transparent : AppColors.primary,
                          width: 4,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(notif.title, style: AppTextStyles.headingSection.copyWith(fontSize: 16)),
                            Text(
                              DateFormat('MMM dd, hh:mm a').format(notif.timestamp),
                              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(notif.message, style: AppTextStyles.bodyMain),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
