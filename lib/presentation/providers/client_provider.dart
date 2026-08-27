// lib/presentation/providers/client_provider.dart

import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/data/repositories/barbershop_repository.dart';
import 'package:barberapp_yucatan/data/repositories/service_repository.dart';
import 'package:barberapp_yucatan/data/repositories/barber_repository.dart';
import 'package:barberapp_yucatan/data/repositories/appointment_repository.dart';
import 'package:barberapp_yucatan/models/barbershop/barbershop.dart';
import 'package:barberapp_yucatan/models/service/service.dart';
import 'package:barberapp_yucatan/models/barber/barber.dart';
import 'package:barberapp_yucatan/models/appointment/appointment.dart';

class ClientProvider extends ChangeNotifier {
  final BarbershopRepository _barbershopRepo = BarbershopRepository();
  final ServiceRepository _serviceRepo = ServiceRepository();
  final BarberRepository _barberRepo = BarberRepository();
  final AppointmentRepository _appointmentRepo = AppointmentRepository();

  // Estado general
  bool _isLoading = false;
  String? _error;
  int _currentClientId = 0;

  // Listas
  List<Barbershop> _barbershops = [];
  List<Service> _services = [];
  List<Barber> _barbers = [];
  List<Appointment> _appointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _historyAppointments = [];

  // Barbería seleccionada
  Barbershop? _selectedBarbershop;
  Service? _selectedService;
  Barber? _selectedBarber;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentClientId => _currentClientId;
  List<Barbershop> get barbershops => _barbershops;
  List<Service> get services => _services;
  List<Barber> get barbers => _barbers;
  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Appointment> get historyAppointments => _historyAppointments;
  Barbershop? get selectedBarbershop => _selectedBarbershop;
  Service? get selectedService => _selectedService;
  Barber? get selectedBarber => _selectedBarber;

  void setClientId(int id) {
    _currentClientId = id;
    notifyListeners();
  }

  // ============ BARBERSHOPS ============
  Future<void> loadBarbershops() async {
    _setLoading(true);
    try {
      _barbershops = await _barbershopRepo.getBarbershops();
      // Filtrar solo barberías activas
      _barbershops = _barbershops.where((b) => b.isActive).toList();
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> selectBarbershop(int id) async {
    try {
      _selectedBarbershop = _barbershops.firstWhere((b) => b.id == id);
      _selectedService = null;
      _selectedBarber = null;
      _notify();
    } catch (e) {
      _setError('Barbería no encontrada');
    }
  }

  // ============ SERVICES ============
  Future<void> loadServices(int barbershopId) async {
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

  void selectService(int id) {
    try {
      _selectedService = _services.firstWhere((s) => s.id == id);
      _notify();
    } catch (e) {
      _setError('Servicio no encontrado');
    }
  }

  // ============ BARBERS ============
  Future<void> loadBarbers(int barbershopId) async {
    _setLoading(true);
    try {
      _barbers = await _barberRepo.getBarbers(barbershopId: barbershopId);
      // Filtrar solo barberos activos
      _barbers = _barbers.where((b) => b.isActive).toList();
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void selectBarber(int id) {
    try {
      _selectedBarber = _barbers.firstWhere((b) => b.id == id);
      _notify();
    } catch (e) {
      _setError('Barbero no encontrado');
    }
  }

  // ============ APPOINTMENTS ============
  Future<void> loadAppointments() async {
    _setLoading(true);
    try {
      _appointments = await _appointmentRepo.getAppointments();
      _upcomingAppointments = _appointments
          .where((a) => a.appointmentDate.isAfter(DateTime.now()))
          .toList();
      _historyAppointments = _appointments
          .where((a) => a.appointmentDate.isBefore(DateTime.now()))
          .toList();
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Appointment?> createAppointment({
    required int barbershopId,
    required int barberId,
    required DateTime date,
    required List<int> serviceIds,
    required String paymentMethod,
  }) async {
    _setLoading(true);
    try {
      final appointment = await _appointmentRepo.createAppointment(
        barbershopId: barbershopId,
        clientId: _currentClientId,
        barberId: barberId,
        date: date,
        serviceIds: serviceIds,
        paymentMethod: paymentMethod,
      );
      _appointments.add(appointment);
      _notify();
      return appointment;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelAppointment(int id) async {
    _setLoading(true);
    try {
      final cancelled = await _appointmentRepo.cancelAppointment(id);
      final index = _appointments.indexWhere((a) => a.id == id);
      if (index != -1) {
        _appointments[index] = cancelled;
        _notify();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============ LIMPIEZA ============
  void clearSelection() {
    _selectedBarbershop = null;
    _selectedService = null;
    _selectedBarber = null;
    _services = [];
    _barbers = [];
    _notify();
  }

  void reset() {
    _barbershops = [];
    _services = [];
    _barbers = [];
    _appointments = [];
    _upcomingAppointments = [];
    _historyAppointments = [];
    _selectedBarbershop = null;
    _selectedService = null;
    _selectedBarber = null;
    _isLoading = false;
    _error = null;
    _notify();
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

  void clearError() {
    _error = null;
    _notify();
  }
}