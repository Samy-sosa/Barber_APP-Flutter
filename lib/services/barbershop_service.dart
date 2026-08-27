// lib/services/barbershop_service.dart

import 'dart:convert';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/barbershop/barbershop.dart';

class BarbershopService {
  final ApiClient _apiClient = ApiClient();

  // GET /api/barbershops
  Future<List<Barbershop>> getBarbershops() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.barbershops, isAuthRequired: false);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        // Mapeamos la lista de JSON a objetos Barbershop
        return body.map((item) => Barbershop.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar barberías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}