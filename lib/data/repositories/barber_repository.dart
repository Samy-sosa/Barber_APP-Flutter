// lib/data/repositories/barber_repository.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:barberapp_yucatan/core/network/api_client.dart';
import 'package:barberapp_yucatan/core/network/api_endpoints.dart';
import 'package:barberapp_yucatan/models/barber/barber.dart';

class BarberRepository {
  final ApiClient _apiClient = ApiClient();

  // GET /api/barbers
  Future<List<Barber>> getBarbers({int? barbershopId}) async {
    try {
      final endpoint = barbershopId != null
          ? '${ApiEndpoints.barbers}?barbershopId=$barbershopId'
          : ApiEndpoints.barbers;

      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Barber.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener barberos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /api/barbers/{id}
  Future<Barber> getBarberById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.barberDetail(id),
      );

      if (response.statusCode == 200) {
        return Barber.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener barbero: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/barbers
  Future<Barber> createBarber(Barber barber) async {
    try {
      // Si tu ApiClient usa el formato 'body:', descomenta esta línea y borra la de abajo:
      // final response = await _apiClient.post(
      //   ApiEndpoints.barbers,
      //   body: barber.toJson(),
      // );

      // Versión actual (sin body:):
      final response = await _apiClient.post(
        ApiEndpoints.barbers,
        barber.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Barber.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear barbero: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT /api/barbers/{id}
  Future<Barber> updateBarber(Barber barber) async {
    try {
      // Si tu ApiClient usa el formato 'body:', descomenta esta línea y borra la de abajo:
      // final response = await _apiClient.put(
      //   ApiEndpoints.barberDetail(barber.id),
      //   body: barber.toJson(),
      // );

      // Versión actual (sin body:):
      final response = await _apiClient.put(
        ApiEndpoints.barberDetail(barber.id),
        barber.toJson(),
      );

      if (response.statusCode == 200) {
        return Barber.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al actualizar barbero: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE /api/barbers/{id}
  Future<void> deleteBarber(int id) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.barberDetail(id),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar barbero: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/barbers/{id}/photo
  Future<String> uploadPhoto(int barberId, String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.path.split('/').last,
      );

      final response = await _apiClient.multipart(
        ApiEndpoints.barberPhoto(barberId),
        files: [multipartFile],
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'] ?? data['photoUrl'] ?? '';
      } else {
        throw Exception('Error al subir foto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PATCH /api/barbers/{id}/toggle
  Future<Barber> toggleBarber(int barberId) async {
    try {
      // Si tu ApiClient usa el formato 'body:', descomenta esta línea y borra la de abajo:
      // final response = await _apiClient.patch(
      //   ApiEndpoints.barberToggle(barberId),
      //   body: {'active': true},
      // );

      // Versión actual (sin body:):
      final response = await _apiClient.patch(
        ApiEndpoints.barberToggle(barberId),
        {'active': true},
      );

      if (response.statusCode == 200) {
        return Barber.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al alternar barbero: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}