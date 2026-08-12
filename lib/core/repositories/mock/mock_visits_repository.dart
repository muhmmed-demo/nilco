import '../visits_repository.dart';
import '../../models/visit_model.dart';
import '../../models/performance_model.dart';
import '../../mock/mock_data.dart';

class MockVisitsRepository implements VisitsRepository {
  @override
  Future<VisitModel> createVisit(VisitModel visit) async {
    await Future.delayed(const Duration(seconds: 1));
    MockData.visits.add(visit);
    return visit;
  }

  @override
  Future<List<VisitModel>> getAllVisits({DateRange? range}) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.visits;
  }

  @override
  Future<List<VisitModel>> getRepVisits(String repId, {DateRange? range}) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.visits.where((v) => v.repId == repId).toList();
  }

  @override
  Future<VisitModel> updateVisit(String visitId, VisitModel updated) async {
    await Future.delayed(const Duration(seconds: 1));
    return updated;
  }
}
