import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.timestamp,
  });
}

abstract class NotificationsRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  final List<NotificationModel> _mockData = [
    NotificationModel(
      id: '1',
      title: 'New Training Assigned',
      message: 'Please complete the Safety Guidelines module by Friday.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '2',
      title: 'Goal Achieved! 🎉',
      message: 'You have reached 1000 points this week.',
      isRead: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: '3',
      title: 'Task Overdue',
      message: 'Your visit to Learn & Play Store is overdue.',
      isRead: true,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockData;
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockData.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockData[index] = NotificationModel(
        id: _mockData[index].id,
        title: _mockData[index].title,
        message: _mockData[index].message,
        isRead: true,
        timestamp: _mockData[index].timestamp,
      );
    }
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl();
});

class NotificationsNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationsRepository _repository;

  NotificationsNotifier(this._repository) : super(const AsyncLoading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    state = const AsyncLoading();
    try {
      final notifications = await _repository.getNotifications();
      state = AsyncData(notifications);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    await fetchNotifications(); // refresh list
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationsNotifier(ref.watch(notificationsRepositoryProvider));
});
