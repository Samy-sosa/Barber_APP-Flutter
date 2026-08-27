// lib/data/models/barbershop/barbershop.dart

class Barbershop {
  final int id;
  final String name;
  final String address;
  final String municipality;
  final String? phone;
  final String? email;
  final String? description;
  final String? slug;
  final String? website;
  final String? socialMedia;
  final String? openingHours;
  final double? lat;
  final double? lng;
  final String? logoUrl;
  final String? bannerUrl;
  final int ownerId;
  final String ownerName;
  final String ownerEmail;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Barbershop({
    required this.id,
    required this.name,
    required this.address,
    required this.municipality,
    this.phone,
    this.email,
    this.description,
    this.slug,
    this.website,
    this.socialMedia,
    this.openingHours,
    this.lat,
    this.lng,
    this.logoUrl,
    this.bannerUrl,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  factory Barbershop.fromJson(Map<String, dynamic> json) {
    return Barbershop(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      municipality: json['municipality'] ?? '',
      phone: json['phone'],
      email: json['email'],
      description: json['description'],
      slug: json['slug'],
      website: json['website'],
      socialMedia: json['socialMedia'],
      openingHours: json['openingHours'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      logoUrl: json['logoUrl'],
      bannerUrl: json['bannerUrl'],
      ownerId: json['ownerId'] ?? 0,
      ownerName: json['ownerName'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'municipality': municipality,
      'phone': phone,
      'email': email,
      'description': description,
      'slug': slug,
      'website': website,
      'socialMedia': socialMedia,
      'openingHours': openingHours,
      'lat': lat,
      'lng': lng,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  Barbershop copyWith({
    String? name,
    String? address,
    String? municipality,
    String? phone,
    String? email,
    String? description,
    String? slug,
    String? website,
    String? socialMedia,
    String? openingHours,
    double? lat,
    double? lng,
    String? logoUrl,
    String? bannerUrl,
    bool? isActive,
  }) {
    return Barbershop(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      municipality: municipality ?? this.municipality,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      slug: slug ?? this.slug,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      openingHours: openingHours ?? this.openingHours,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}