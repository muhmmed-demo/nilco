import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  @override
  Future<List<ActivityTask>> getDailyTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      ActivityTask(
        id: '1',
        title: 'جرد مخزون لعبة بانانا',
        storeName: 'تويز آر أص - مول العرب',
        status: ActivityStatus.completed,
        dueDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityTask(
        id: '2',
        title: 'ترتيب رفوف ألعاب الكروت (شات اب)',
        storeName: 'كارفور - سيتي سنتر',
        status: ActivityStatus.pending,
        dueDate: DateTime.now().add(const Duration(hours: 3)),
      ),
      ActivityTask(
        id: '3',
        title: 'التأكد من توفر لعبة شيتي كويسشي',
        storeName: 'مكتبة سمير وعلي',
        status: ActivityStatus.overdue,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepositoryImpl();
});
