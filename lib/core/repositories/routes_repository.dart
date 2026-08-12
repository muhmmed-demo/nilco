import '../models/route_model.dart';

abstract class RoutesRepository {
  Future<RouteModel?> getTodayRoute(String repId);
  Future<List<RouteModel>> getAllRoutes({String? repId});
  Future<RouteModel> createRoute(RouteModel route);
  Future<RouteModel> updateRoute(String routeId, RouteModel updated);
  Future<void> markStopVisited(String routeId, String clientId);
}
