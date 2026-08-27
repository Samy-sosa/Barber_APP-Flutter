// lib/data/repositories/barbershop_repository.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:barberapp_yucatan/core/network/api_client.dart';
import 'package:barberapp_yucatan/core/network/api_endpoints.dart';
import 'package:barberapp_yucatan/models/barbershop/barbershop.dart';

class BarbershopRepository {
  final ApiClient _apiClient = ApiClient();

  // GET /api/barbershops
  Future<List<Barbershop>> getBarbershops() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.barbershops);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Barbershop.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener barberías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /api/barbershops/{id}
  Future<Barbershop> getBarbershopById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.barbershopDetail(id),
      );

      if (response.statusCode == 200) {
        return Barbershop.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener barbería: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/barbershops
  Future<Barbershop> createBarbershop(Barbershop barbershop) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.barbershops,
        barbershop.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Barbershop.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear barbería: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT /api/barbershops/{id}
  Future<Barbershop> updateBarbershop(Barbershop barbershop) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.barbershopDetail(barbershop.id),
        barbershop.toJson(),
      );

      if (response.statusCode == 200) {
        return Barbershop.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al actualizar barbería: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE /api/barbershops/{id}
  Future<void> deleteBarbershop(int id) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.barbershopDetail(id),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar barbería: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/barbershops/{id}/logo
  Future<String> uploadLogo(int barbershopId, String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.path.split('/').last,
      );

      final response = await _apiClient.multipart(
        ApiEndpoints.barbershopLogo(barbershopId),
        files: [multipartFile],
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'] ?? data['logoUrl'] ?? '';
      } else {
        throw Exception('Error al subir logo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/barbershops/{id}/banner
  Future<String> uploadBanner(int barbershopId, String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.path.split('/').last,
      );

      final response = await _apiClient.multipart(
        ApiEndpoints.barbershopBanner(barbershopId),
        files: [multipartFile],
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'] ?? data['bannerUrl'] ?? '';
      } else {
        throw Exception('Error al subir banner: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /api/barbershops/{id}/metrics
  Future<Map<String, dynamic>> getMetrics(int barbershopId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.barbershopMetrics(barbershopId),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener métricas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /api/barbershops/{id}/stats
  Future<Map<String, dynamic>> getStats(int barbershopId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.barbershopStats(barbershopId),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener estadísticas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}