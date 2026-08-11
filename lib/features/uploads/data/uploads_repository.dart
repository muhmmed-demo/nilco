class UploadedReport {
  final String id;
  final String imageUrl;
  final String toyCategory;
  final String note;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  UploadedReport({
    required this.id,
    required this.imageUrl,
    required this.toyCategory,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

abstract class UploadsRepository {
  Future<void> submitReport(String imagePath, String category, String note, double lat, double lng);
  Future<List<UploadedReport>> getGalleryReports();
}
