class TrainingModule {
  final String id;
  final String title;
  final String category;
  final double progress; // 0.0 to 1.0

  TrainingModule({
    required this.id,
    required this.title,
    required this.category,
    required this.progress,
  });
}

abstract class TrainingRepository {
  Future<List<TrainingModule>> getTrainingModules();
}
