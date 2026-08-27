// lib/presentation/providers/tenant_admin_provider.dart

import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/models/barbershop/barbershop.dart';
import 'package:barberapp_yucatan/models/barber/barber.dart';
import 'package:barberapp_yucatan/models/service/service.dart';
import 'package:barberapp_yucatan/models/schedule/schedule.dart';
import 'package:barberapp_yucatan/models/appointment/appointment.dart';
import 'package:barberapp_yucatan/data/repositories/barbershop_repository.dart';
import 'package:barberapp_yucatan/data/repositories/barber_repository.dart';
import 'package:barberapp_yucatan/data/repositories/service_repository.dart';
import 'package:barberapp_yucatan/data/repositories/schedule_repository.dart';
import 'package:barberapp_yucatan/data/repositories/appointment_repository.dart';

class TenantAdminProvider extends ChangeNotifier {
  final BarbershopRepository _barbershopRepo = BarbershopRepository();
  final BarberRepository _barberRepo = BarberRepository();
  final ServiceRepository _serviceRepo = ServiceRepository();
  final ScheduleRepository _scheduleRepo = ScheduleRepository();
  final AppointmentRepository _appointmentRepo = AppointmentRepository();

  // Estado
  bool _isLoading = false;
  String? _error;

  // Datos de la barbería
  Barbershop? _barbershop;
  List<Barber> _barbers = [];
  List<Service> _services = [];
  List<Schedule> _schedules = [];
  List<Appointment> _appointments = [];

  // Métricas
  Map<String, dynamic>? _metrics;
  Map<String, dynamic>? _stats;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Barbershop? get barbershop => _barbershop;
  List<Barber> get barbers => _barbers;
  List<Service> get services => _services;
  List<Schedule> get schedules => _schedules;
  List<Appointment> get appointments => _appointments;
  Map<String, dynamic>? get metrics => _metrics;
  Map<String, dynamic>? get stats => _stats;

  // ============ BARBERSHOP ============
  Future<void> loadBarbershop(int id) async {
    _setLoading(true);
    try {
      _barbershop = await _barbershopRepo.getBarbershopById(id);
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMetrics(int id) async {
    try {
      _metrics = await _barbershopRepo.getMetrics(id);
      _notify();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadStats(int id) async {
    try {
      _stats = await _barbershopRepo.getStats(id);
      _notify();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ============ BARBERS ============
  Future<void> loadBarbers({int? barbershopId}) async {
    _setLoading(true);
    try {
      _barbers = await _barberRepo.getBarbers(barbershopId: barbershopId);
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createBarber(Barber barber, {String? photoPath}) async {
    _setLoading(true);
    try {
      final createdBarber = await _barberRepo.createBarber(barber);

      if (photoPath != null && photoPath.isNotEmpty) {
        await _barberRepo.uploadPhoto(createdBarber.id, photoPath);
      }

      _barbers.add(createdBarber);
      _error = null;
      _notify();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleBarber(int barberId) async {
    _setLoading(true);
    try {
      final updatedBarber = await _barberRepo.toggleBarber(barberId);
      final index = _barbers.indexWhere((b) => b.id == barberId);
      if (index != -1) {
        _barbers[index] = updatedBarber;
      }
      _error = null;
      _notify();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBarber(int barberId) async {
    _setLoading(true);
    try {
      await _barberRepo.deleteBarber(barberId);
      _barbers.removeWhere((b) => b.id == barberId);
      _error = null;
      _notify();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============ SERVICES ============
  Future<void> loadServices({int? barbershopId}) async {
    _setLoading(true);
    try {
      _services = await _serviceRepo.getServices(barbershopId: barbershopId);
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Método para crear servicio con imagen
  Future<void> createService(Service service, {String? imagePath}) async {
    _setLoading(true);
    try {
      final createdService = await _serviceRepo.createService(service);

      if (imagePath != null && imagePath.isNotEmpty) {
        await _serviceRepo.uploadPhoto(createdService.id, imagePath);
      }

      _services.add(createdService);
      _error = null;
      _notify();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Método para alternar estado (Activo/Inactivo)
  Future<void> toggleService(int serviceId) async {
    _setLoading(true);
    try {
      final updatedService = await _serviceRepo.toggleService(serviceId);
      final index = _services.indexWhere((s) => s.id == serviceId);
      if (index != -1) {
        _services[index] = updatedService;
      }
      _error = null;
      _notify();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Método para eliminar servicio
  Future<void> deleteService(int serviceId) async {
    _setLoading(true);
    try {
      await _serviceRepo.deleteService(serviceId);
      _services.removeWhere((s) => s.id == serviceId);
      _error = null;
      _notify();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============ SCHEDULES ============
  Future<void> loadSchedules({int? barbershopId}) async {
    _setLoading(true);
    try {
      _schedules = await _scheduleRepo.getSchedules(barbershopId: barbershopId);
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ============ APPOINTMENTS ============
  Future<void> loadAppointments({int? barbershopId, String? status}) async {
    _setLoading(true);
    try {
      _appointments = await _appointmentRepo.getAppointments(
        barbershopId: barbershopId,
        status: status,
      );
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _notify();
  }

  void _setError(String error) {
    _error = error;
    _notify();
  }

  void _notify() {
    notifyListeners();
  }

  void clear() {
    _barbershop = null;
    _barbers = [];
    _services = [];
    _schedules = [];
    _appointments = [];
    _metrics = null;
    _stats = null;
    _isLoading = false;
    _error = null;
    _notify();
  }
}