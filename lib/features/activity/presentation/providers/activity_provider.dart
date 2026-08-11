import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/activity_repository.dart';
import '../data/activity_repository_impl.dart';

final activityTasksProvider = FutureProvider<List<ActivityTask>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getDailyTasks();
});
