class LandRequestModel {
  final String id;
  final String landId;
  final String farmerId;
  final String status; // "pending", "accepted", or "rejected"
  final DateTime createdAt;

  LandRequestModel({
    required this.id,
    required this.landId,
    required this.farmerId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'landId': landId,
      'farmerId': farmerId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LandRequestModel.fromMap(String id, Map<String, dynamic> map) {
    return LandRequestModel(
      id: id,
      landId: map['landId'] ?? '',
      farmerId: map['farmerId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
