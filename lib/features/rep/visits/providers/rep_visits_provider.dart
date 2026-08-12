import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/visit_model.dart';
import '../../../../core/repositories/mock/mock_visits_repository.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

final visitsRepositoryProvider = Provider((ref) => MockVisitsRepository());

final repVisitsProvider = FutureProvider<List<VisitModel>>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(visitsRepositoryProvider);
    return repo.getRepVisits(authState.user.id);
  }
  return [];
});

class VisitController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  VisitController(this.ref) : super(const AsyncData(null));

  Future<bool> createVisit(VisitModel visit) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(visitsRepositoryProvider);
      await repo.createVisit(visit);
      ref.invalidate(repVisitsProvider); // Refresh the list
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final visitControllerProvider = StateNotifierProvider<VisitController, AsyncValue<void>>((ref) {
  return VisitController(ref);
});
