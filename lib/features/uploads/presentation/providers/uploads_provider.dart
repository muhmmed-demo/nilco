import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/uploads_repository.dart';
import '../data/uploads_repository_impl.dart';

final galleryReportsProvider = FutureProvider<List<UploadedReport>>((ref) async {
  final repository = ref.watch(uploadsRepositoryProvider);
  return repository.getGalleryReports();
});

class UploadController extends StateNotifier<AsyncValue<void>> {
  final UploadsRepository _repository;

  UploadController(this._repository) : super(const AsyncData(null));

  Future<void> submitReport(String imagePath, String category, String note, double lat, double lng) async {
    state = const AsyncLoading();
    try {
      await _repository.submitReport(imagePath, category, note, lat, lng);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final uploadControllerProvider = StateNotifierProvider<UploadController, AsyncValue<void>>((ref) {
  return UploadController(ref.watch(uploadsRepositoryProvider));
});
