import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArchivedTask {
  final String id;
  final String title;
  final String details;
  final DateTime completedAt;

  ArchivedTask({
    required this.id,
    required this.title,
    required this.details,
    required this.completedAt,
  });
}

abstract class ArchiveRepository {
  Future<List<ArchivedTask>> getArchivedTasks();
}

class ArchiveRepositoryImpl implements ArchiveRepository {
  @override
  Future<List<ArchivedTask>> getArchivedTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      ArchivedTask(
        id: '1',
        title: 'Inventory Check',
        details: 'Checked the Action Figures section at City Center',
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ArchivedTask(
        id: '2',
        title: 'New Display Setup',
        details: 'Arranged the new Board Games display at Mall',
        completedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ArchivedTask(
        id: '3',
        title: 'Store Visit',
        details: 'Visited Learn & Play Store for stock checking',
        completedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}

final archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  return ArchiveRepositoryImpl();
});

final archivedTasksProvider = FutureProvider<List<ArchivedTask>>((ref) async {
  final repository = ref.watch(archiveRepositoryProvider);
  return repository.getArchivedTasks();
});
