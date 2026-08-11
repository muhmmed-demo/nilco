import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'training_repository.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  @override
  Future<List<TrainingModule>> getTrainingModules() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      TrainingModule(
        id: '1',
        title: 'كيفية شرح وتجربة لعبة شيتي كويسشي للعملاء',
        category: 'ألعاب الطاولة',
        progress: 1.0,
      ),
      TrainingModule(
        id: '2',
        title: 'دليل أمان ألعاب الصلصال للأطفال',
        category: 'صلصال',
        progress: 0.45,
      ),
      TrainingModule(
        id: '3',
        title: 'قواعد لعبة بانانا وتكتيكات البيع',
        category: 'ألعاب كروت',
        progress: 0.0,
      ),
    ];
  }
}

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return TrainingRepositoryImpl();
});
