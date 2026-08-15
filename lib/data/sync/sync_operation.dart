class SyncOperation {
  final String type; // 'create_order', 'update_visit', etc.
  final Map<String, dynamic> payload;
  final DateTime createdAt;

  SyncOperation({required this.type, required this.payload, required this.createdAt});

  Map<String, dynamic> toJson() => {'type': type, 'payload': payload, 'createdAt': createdAt.toIso8601String()};
  
  factory SyncOperation.fromJson(Map json) => SyncOperation(
    type: json['type'],
    payload: Map<String, dynamic>.from(json['payload']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}
