import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'uploads_repository.dart';

class UploadsRepositoryImpl implements UploadsRepository {
  final List<UploadedReport> _mockDatabase = [
    UploadedReport(
      id: '1',
      imageUrl: 'https://nilco-int.com/storage/c86cadbf94b456840063ae7e26917a7c/1682612550-1MEX4G7yMn3TjbrLAMsasFKNcfsdEeMEMUhKCi2EwsJpdWe5G70EipSCjEx6srAGpiaPIee8U6YDg7aiPtT3KPN8YNjxSIOuTIolbXsXIyo1edadTZAhdcXZa8KVYQ2jGUv9dfi2nuLZqqiJtImKHR.jpg',
      toyCategory: 'ألعاب كروت',
      note: 'تم ترتيب عرض لعبة بانانا',
      latitude: 24.7136,
      longitude: 46.6753,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UploadedReport(
      id: '2',
      imageUrl: 'https://nilco-int.com/storage/6f3e51bf658e5bfc9b3e9b72f503dd41/1682950733-Oao1dBNh8P4RpXJgyuIqfLeTd1WdddtcYKUujhlmc49uNzdkXBGhMtgHrTpdkhx6CdgSEDz3rZhYXCkr5whncYtDYBtUKzxJvlFd4aQ8sOCL495FTqEQqfSibuzr0YRsSCKVlzKSCUI2OtaVHUihh7.jpg',
      toyCategory: 'ألعاب الطاولة',
      note: 'نفذت كمية شيتي كويسشي، يجب طلب المزيد',
      latitude: 24.7136,
      longitude: 46.6753,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    UploadedReport(
      id: '3',
      imageUrl: 'https://nilco-int.com/storage/f8867a770b563c434a72baf11f2a873f/1682950958-H4tmsmfUURBheX2gE5CTHthSLfow5JM7vhwqsRgGVZFmTUD9VFLVbznrKVPCbwGn5bgDHT52BTiSSLDDTgXzK5R7iqLsMFH1MrM5guFtXzW2aiKYKu6dfPMBsCn2GJmKcrLElazdgvdUIg6o8HGMOZ.jpg',
      toyCategory: 'ألعاب كروت',
      note: 'شات اب متوفرة بكميات كبيرة',
      latitude: 24.7136,
      longitude: 46.6753,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Future<void> submitReport(String imagePath, String category, String note, double lat, double lng) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate uploading and saving
    _mockDatabase.insert(0, UploadedReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: 'https://via.placeholder.com/300?text=New+Upload', // Mock URL since we can't host local file easily in this mock
      toyCategory: category,
      note: note,
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<List<UploadedReport>> getGalleryReports() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockDatabase;
  }
}

final uploadsRepositoryProvider = Provider<UploadsRepository>((ref) {
  return UploadsRepositoryImpl();
});
