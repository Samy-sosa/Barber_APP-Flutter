// lib/data/repositories/schedule_repository.dart

import 'dart:convert';
import 'package:barberapp_yucatan/core/network/api_client.dart';
import 'package:barberapp_yucatan/core/network/api_endpoints.dart';
import 'package:barberapp_yucatan/models/schedule/schedule.dart';

class ScheduleRepository {
  final ApiClient _apiClient = ApiClient();

  // GET /api/schedules
  Future<List<Schedule>> getSchedules({int? barbershopId}) async {
    try {
      final endpoint = barbershopId != null
          ? '${ApiEndpoints.schedules}?barbershopId=$barbershopId'
          : ApiEndpoints.schedules;

      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Schedule.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener horarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /api/schedules/{id}
  Future<Schedule> getScheduleById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.scheduleDetail(id),
      );

      if (response.statusCode == 200) {
        return Schedule.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener horario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /api/schedules
  Future<Schedule> createSchedule(Schedule schedule) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.schedules,
        schedule.toJson(), // ✅ CORREGIDO: sin "body:"
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Schedule.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear horario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT /api/schedules/{id}
  Future<Schedule> updateSchedule(Schedule schedule) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.scheduleDetail(schedule.id),
        schedule.toJson(), // ✅ CORREGIDO: sin "body:"
      );

      if (response.statusCode == 200) {
        return Schedule.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al actualizar horario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE /api/schedules/{id}
  Future<void> deleteSchedule(int id) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.scheduleDetail(id),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar horario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}