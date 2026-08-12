import '../routes_repository.dart';
import '../../models/route_model.dart';
import '../../mock/mock_data.dart';

class MockRoutesRepository implements RoutesRepository {
  @override
  Future<RouteModel> createRoute(RouteModel route) async {
    await Future.delayed(const Duration(seconds: 1));
    return route;
  }

  @override
  Future<List<RouteModel>> getAllRoutes({String? repId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return [MockData.todayRoute];
  }

  @override
  Future<RouteModel?> getTodayRoute(String repId) async {
    await Future.delayed(const Duration(seconds: 1));
    if (repId == MockData.salesRep.id) return MockData.todayRoute;
    return null;
  }

  @override
  Future<void> markStopVisited(String routeId, String clientId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<RouteModel> updateRoute(String routeId, RouteModel updated) async {
    await Future.delayed(const Duration(seconds: 1));
    return updated;
  }
}
