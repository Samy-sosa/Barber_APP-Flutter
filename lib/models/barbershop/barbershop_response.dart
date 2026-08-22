class BarbershopResponse {
  final int id;
  final int ownerId;
  final String ownerName;
  final String name;
  final String slug;
  final String municipality;
  final String? address;

  BarbershopResponse({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.name,
    required this.slug,
    required this.municipality,
    this.address,
  });

  factory BarbershopResponse.fromJson(Map<String, dynamic> json) {
    return BarbershopResponse(
      id: json['id'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      municipality: json['municipality'] ?? '',
      address: json['address'],
    );
  }
}