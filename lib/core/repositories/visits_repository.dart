import '../models/visit_model.dart';
import '../models/performance_model.dart';

abstract class VisitsRepository {
  Future<List<VisitModel>> getRepVisits(String repId, {DateRange? range});
  Future<List<VisitModel>> getAllVisits({DateRange? range});
  Future<VisitModel> createVisit(VisitModel visit);
  Future<VisitModel> updateVisit(String visitId, VisitModel updated);
}
