enum VisitStatus { planned, inProgress, completed, skipped }

class VisitModel {
  final String id;
  final String repId;
  final String clientId;
  final String clientName;
  final String clientAddress;
  final double? latitude;
  final double? longitude;
  final List<String> photoUrls;
  final String? notes;
  final VisitStatus status;
  final DateTime scheduledAt;
  final DateTime? arrivedAt;
  final DateTime? completedAt;

  VisitModel({
    required this.id,
    required this.repId,
    required this.clientId,
    required this.clientName,
    required this.clientAddress,
    this.latitude,
    this.longitude,
    required this.photoUrls,
    this.notes,
    required this.status,
    required this.scheduledAt,
    this.arrivedAt,
    this.completedAt,
  });
}
