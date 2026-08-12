class RouteModel {
  final String id;
  final String repId;
  final String repName;
  final DateTime date;
  final List<RouteStop> stops;
  final bool isAssignedByManager;

  RouteModel({
    required this.id,
    required this.repId,
    required this.repName,
    required this.date,
    required this.stops,
    required this.isAssignedByManager,
  });
}

class RouteStop {
  final int order;
  final String clientId;
  final String clientName;
  final String address;
  final double latitude;
  final double longitude;
  final bool isVisited;

  RouteStop({
    required this.order,
    required this.clientId,
    required this.clientName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isVisited,
  });
}
