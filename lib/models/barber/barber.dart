// lib/data/models/barber/barber.dart

class Barber {
  final int id;
  final String name;
  final String? photoUrl;
  final String? email;
  final String? phone;
  final String? specialty;
  final String? bio;
  final double? rating;
  final int? totalReviews;
  final bool isActive;
  final int barbershopId;
  final String barbershopName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Barber({
    required this.id,
    required this.name,
    this.photoUrl,
    this.email,
    this.phone,
    this.specialty,
    this.bio,
    this.rating,
    this.totalReviews,
    this.isActive = true,
    required this.barbershopId,
    required this.barbershopName,
    required this.createdAt,
    this.updatedAt,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
      email: json['email'],
      phone: json['phone'],
      specialty: json['specialty'],
      bio: json['bio'],
      rating: json['rating']?.toDouble(),
      totalReviews: json['totalReviews'],
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
      'photoUrl': photoUrl,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'bio': bio,
      'rating': rating,
      'totalReviews': totalReviews,
      'isActive': isActive,
      'barbershopId': barbershopId,
      'barbershopName': barbershopName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}