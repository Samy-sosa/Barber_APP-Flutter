// lib/data/models/service/service.dart

class Service {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int duration; // en minutos
  final String? imageUrl;
  final bool isActive;
  final int barbershopId;
  final String barbershopName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Service({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    this.imageUrl,
    this.isActive = true,
    required this.barbershopId,
    required this.barbershopName,
    required this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      barbershopId: json['barbershopId'] ?? 0,
      barbershopName: json['barbershopName'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'barbershopId': barbershopId,
      'barbershopName': barbershopName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get durationFormatted {
    if (duration < 60) {
      return '$duration min';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return '$hours h';
    }
    return '$hours h $minutes min';
  }
}