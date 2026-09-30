class LandModel {
  final String id;
  final String ownerId;
  final String location;
  final double area;
  final String soilType;
  final String crops;
  final double price;
  final bool available;
  final DateTime createdAt;
  final String? photoBase64; // null if no photo was added

  LandModel({
    required this.id,
    required this.ownerId,
    required this.location,
    required this.area,
    required this.soilType,
    required this.crops,
    required this.price,
    required this.available,
    required this.createdAt,
    this.photoBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'location': location,
      'area': area,
      'soilType': soilType,
      'crops': crops,
      'price': price,
      'available': available,
      'createdAt': createdAt.toIso8601String(),
      'photoBase64': photoBase64,
    };
  }

  factory LandModel.fromMap(String id, Map<String, dynamic> map) {
    return LandModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      location: map['location'] ?? '',
      area: (map['area'] ?? 0).toDouble(),
      soilType: map['soilType'] ?? '',
      crops: map['crops'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      available: map['available'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      photoBase64: map['photoBase64'],
    );
  }
}
