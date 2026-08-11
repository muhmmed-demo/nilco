import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/training_repository.dart';
import '../../data/training_repository_impl.dart';

final trainingModulesProvider = FutureProvider<List<TrainingModule>>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return repository.getTrainingModules();
});
