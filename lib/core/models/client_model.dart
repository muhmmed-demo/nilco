class ClientModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final String regionId;
  final String? assignedRepId;
  final DateTime? lastVisitDate;

  ClientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.regionId,
    this.assignedRepId,
    this.lastVisitDate,
  });
}
