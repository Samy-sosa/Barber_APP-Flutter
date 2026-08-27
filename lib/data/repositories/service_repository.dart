// lib/data/repositories/service_repository.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:barberapp_yucatan/core/network/api_client.dart';
import 'package:barberapp_yucatan/core/network/api_endpoints.dart';
import 'package:barberapp_yucatan/models/service/service.dart';

class ServiceRepository {
  final ApiClient _apiClient = ApiClient();

  // GET /api/services
  Future<List<Service>> getServices({int? barbershopId}) async {
    try {
      final endpoint = barbershopId != null
          ? '${ApiEndpoints.services}?barbershopId=$barbershopId'
          : ApiEndpoints.services;

      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener servicios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /api/services/{id}
  Future<Service> getServiceById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.serviceDetail(id),
      );

      if (response.statusCode == 200) {
        return Service.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener servicio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/services
  Future<Service> createService(Service service) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.services,
        service.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Service.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear servicio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT /api/services/{id}
  Future<Service> updateService(Service service) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.serviceDetail(service.id),
        service.toJson(),
      );

      if (response.statusCode == 200) {
        return Service.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al actualizar servicio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE /api/services/{id}
  Future<void> deleteService(int id) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.serviceDetail(id),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar servicio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/services/{id}/photo
  Future<String> uploadPhoto(int serviceId, String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.path.split('/').last,
      );

      final response = await _apiClient.multipart(
        ApiEndpoints.servicePhoto(serviceId),
        files: [multipartFile],
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'] ?? data['imageUrl'] ?? '';
      } else {
        throw Exception('Error al subir foto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ⭐ NUEVO MÉTODO AGREGADO: Alternar estado (Activo/Inactivo)
  Future<Service> toggleService(int serviceId) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.serviceToggle(serviceId), // Asegúrate de que esta ruta exista en tu api_endpoints.dart
        {'active': true}, // Ajusta según lo que tu API espere
      );

      if (response.statusCode == 200) {
        return Service.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al alternar servicio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}