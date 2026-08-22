// lib/models/auth/register_request.dart

class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? barbershopName;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.barbershopName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      if (barbershopName != null) 'barbershopName': barbershopName,
    };
  }
}