class MachineryModel {
  final String id;
  final String ownerId;
  final String type; // Tractor, Harvester, Tiller, Sprayer, etc.
  final String location;
  final double dailyRate;
  final bool available;
  final DateTime createdAt;
  final String? photoBase64; // null if no photo was added

  MachineryModel({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.location,
    required this.dailyRate,
    required this.available,
    required this.createdAt,
    this.photoBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'type': type,
      'location': location,
      'dailyRate': dailyRate,
      'available': available,
      'createdAt': createdAt.toIso8601String(),
      'photoBase64': photoBase64,
    };
  }

  factory MachineryModel.fromMap(String id, Map<String, dynamic> map) {
    return MachineryModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      type: map['type'] ?? '',
      location: map['location'] ?? '',
      dailyRate: (map['dailyRate'] ?? 0).toDouble(),
      available: map['available'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      photoBase64: map['photoBase64'],
    );
  }
}
