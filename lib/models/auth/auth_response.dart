// lib/models/auth/auth_response.dart

class AuthResponse {
  final String token;
  final int userId;
  final String name;
  final String email;
  final String role;
  final int? barbershopId; // ✅ AGREGAR

  AuthResponse({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.barbershopId, // ✅ AGREGAR
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? json['id'] ?? 0,
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'CLIENT',
      barbershopId: json['barbershopId'], // ✅ AGREGAR
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'barbershopId': barbershopId, // ✅ AGREGAR
    };
  }
}