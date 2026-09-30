class WorkerModel {
  final String id;
  final String userId; // the worker's own user id
  final String skills; // comma separated, e.g. "Harvesting, Spraying"
  final String experience; // e.g. "3 years"
  final String location;
  final double wage; // per day
  final bool available;
  final DateTime createdAt;

  WorkerModel({
    required this.id,
    required this.userId,
    required this.skills,
    required this.experience,
    required this.location,
    required this.wage,
    required this.available,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'skills': skills,
      'experience': experience,
      'location': location,
      'wage': wage,
      'available': available,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WorkerModel.fromMap(String id, Map<String, dynamic> map) {
    return WorkerModel(
      id: id,
      userId: map['userId'] ?? '',
      skills: map['skills'] ?? '',
      experience: map['experience'] ?? '',
      location: map['location'] ?? '',
      wage: (map['wage'] ?? 0).toDouble(),
      available: map['available'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
