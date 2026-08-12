import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/route_model.dart';
import '../../../../core/models/performance_model.dart';
import '../../../../core/repositories/mock/mock_routes_repository.dart';
import '../../../../core/repositories/mock/mock_performance_repository.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

final routesRepositoryProvider = Provider((ref) => MockRoutesRepository());
final performanceRepositoryProvider = Provider((ref) => MockPerformanceRepository());

final todayRouteProvider = FutureProvider<RouteModel?>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(routesRepositoryProvider);
    return repo.getTodayRoute(authState.user.id);
  }
  return null;
});

final repPerformanceProvider = FutureProvider<PerformanceReport?>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(performanceRepositoryProvider);
    return repo.getRepPerformance(
      authState.user.id, 
      DateRange(from: DateTime.now().subtract(const Duration(days: 30)), to: DateTime.now())
    );
  }
  return null;
});
