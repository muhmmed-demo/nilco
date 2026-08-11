enum ActivityStatus { pending, completed, overdue }

class ActivityTask {
  final String id;
  final String title;
  final String storeName;
  final ActivityStatus status;
  final DateTime dueDate;

  ActivityTask({
    required this.id,
    required this.title,
    required this.storeName,
    required this.status,
    required this.dueDate,
  });
}

abstract class ActivityRepository {
  Future<List<ActivityTask>> getDailyTasks();
}
