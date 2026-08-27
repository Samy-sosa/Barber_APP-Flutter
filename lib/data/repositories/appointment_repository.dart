// lib/data/repositories/appointment_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart'; // ✅ AGREGADO para debugPrint
import 'package:barberapp_yucatan/core/network/api_client.dart';
import 'package:barberapp_yucatan/core/network/api_endpoints.dart';
import 'package:barberapp_yucatan/models/appointment/appointment.dart';

class AppointmentRepository {
  final ApiClient _apiClient = ApiClient();

  // ============ GET ALL APPOINTMENTS ============
  Future<List<Appointment>> getAppointments({
    int? barbershopId,
    String? status,
  }) async {
    try {
      String endpoint = ApiEndpoints.appointments;
      final params = <String, String>{};
      if (barbershopId != null) {
        params['barbershopId'] = barbershopId.toString();
      }
      if (status != null) {
        params['status'] = status;
      }

      if (params.isNotEmpty) {
        final queryString = params.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error en getAppointments: $e');
      return [];
    }
  }

  // ============ GET APPOINTMENT BY ID ============
  Future<Appointment> getAppointmentById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.appointmentDetail(id),
      );

      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener cita: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ============ CREATE APPOINTMENT ============
  Future<Appointment> createAppointment({
    required int barbershopId,
    required int clientId,
    required int barberId,
    required DateTime date,
    required List<int> serviceIds,
    required String paymentMethod,
  }) async {
    try {
      final body = {
        'barbershopId': barbershopId,
        'clientId': clientId,
        'barberId': barberId,
        'date': date.toIso8601String().split('T').first,
        'startTime': '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
        'serviceIds': serviceIds,
        'paymentMethod': paymentMethod,
      };

      final response = await _apiClient.post(
        ApiEndpoints.appointments,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Error al crear cita');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ============ CANCEL APPOINTMENT ============
  Future<Appointment> cancelAppointment(int id, {String? reason}) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.appointmentCancel(id),
        {'reason': reason ?? 'Cancelado por el cliente'},
      );

      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al cancelar cita: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ============ GET UPCOMING APPOINTMENTS ============
  Future<List<Appointment>> getUpcomingAppointments() async {
    try {
      // ✅ Usar el endpoint genérico con filtro de estado
      final response = await _apiClient.get(
        '${ApiEndpoints.appointments}?status=PENDING,CONFIRMED',
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error en getUpcomingAppointments: $e');
      return [];
    }
  }

  // ============ GET APPOINTMENT HISTORY ============
  Future<List<Appointment>> getAppointmentHistory() async {
    try {
      // ✅ Usar el endpoint genérico con filtro de estado
      final response = await _apiClient.get(
        '${ApiEndpoints.appointments}?status=COMPLETED,CANCELLED,NO_SHOW',
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error en getAppointmentHistory: $e');
      return [];
    }
  }
}