class SyncOperation {
  final String type; // e.g., 'create_order', 'update_visit'
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  SyncOperation({
    required this.type,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SyncOperation.fromJson(Map<dynamic, dynamic> json) {
    return SyncOperation(
      type: json['type'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
