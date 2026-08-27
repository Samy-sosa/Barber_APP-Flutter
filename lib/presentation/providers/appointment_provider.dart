// lib/presentation/providers/appointment_provider.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barberapp_yucatan/data/repositories/appointment_repository.dart';
import 'package:barberapp_yucatan/data/repositories/service_repository.dart';
import 'package:barberapp_yucatan/data/repositories/barber_repository.dart';
import 'package:barberapp_yucatan/models/appointment/appointment.dart';
import 'package:barberapp_yucatan/models/barbershop/barbershop.dart';
import 'package:barberapp_yucatan/models/service/service.dart';
import 'package:barberapp_yucatan/models/barber/barber.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _appointmentRepo = AppointmentRepository();
  final ServiceRepository _serviceRepo = ServiceRepository();
  final BarberRepository _barberRepo = BarberRepository();

  // ============ ESTADO ============
  bool _isLoading = false;
  String? _error;
  int _currentClientId = 0;

  // ============ DATOS DE LA CITA ============
  Barbershop? _selectedBarbershop;
  Service? _selectedService;
  Barber? _selectedBarber;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _paymentMethod = 'CASH';

  List<Service> _availableServices = [];
  List<Barber> _availableBarbers = [];
  List<Appointment> _myAppointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _historyAppointments = [];
  List<DateTime> _availableSlots = [];

  // ============ GETTERS ============
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentClientId => _currentClientId;

  Barbershop? get selectedBarbershop => _selectedBarbershop;
  Service? get selectedService => _selectedService;
  Barber? get selectedBarber => _selectedBarber;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get paymentMethod => _paymentMethod;

  List<Service> get availableServices => _availableServices;
  List<Barber> get availableBarbers => _availableBarbers;
  List<Appointment> get myAppointments => _myAppointments;
  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Appointment> get historyAppointments => _historyAppointments;
  List<DateTime> get availableSlots => _availableSlots;

  // ============ SETTERS ============
  void setClientId(int id) {
    _currentClientId = id;
    notifyListeners();
  }

  void selectBarbershop(Barbershop barbershop) {
    _selectedBarbershop = barbershop;
    _selectedService = null;
    _selectedBarber = null;
    _selectedDate = null;
    _selectedTime = null;
    _availableServices = [];
    _availableBarbers = [];
    _availableSlots = [];
    notifyListeners();
  }

  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }

  void selectBarber(Barber barber) {
    _selectedBarber = barber;
    _selectedDate = null;
    _selectedTime = null;
    _availableSlots = [];
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null;
    _availableSlots = [];
    notifyListeners();
  }

  void selectTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // ============ CARGAR DATOS ============

  // Cargar servicios de una barbería
  Future<void> loadServices(int barbershopId) async {
    _setLoading(true);
    try {
      _availableServices = await _serviceRepo.getServices(barbershopId: barbershopId);
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Cargar barberos de una barbería
  Future<void> loadBarbers(int barbershopId) async {
    _setLoading(true);
    try {
      _availableBarbers = await _barberRepo.getBarbers(barbershopId: barbershopId);
      _availableBarbers = _availableBarbers.where((b) => b.isActive).toList();
      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Cargar slots disponibles - SIMPLIFICADO
  Future<void> loadAvailableSlots({
    required int barbershopId,
    required int barberId,
    required DateTime date,
  }) async {
    _setLoading(true);
    try {
      // Simulación de slots disponibles (9:00 - 18:00, con descanso 13:00-14:00)
      _availableSlots = [];
      for (int hour = 9; hour <= 17; hour++) {
        // Saltar hora de descanso (13:00 - 14:00)
        if (hour == 13) continue;

        _availableSlots.add(DateTime(date.year, date.month, date.day, hour, 0));
        _availableSlots.add(DateTime(date.year, date.month, date.day, hour, 30));
      }
      _notify();
    } catch (e) {
      _setError(e.toString());
      _availableSlots = [];
    } finally {
      _setLoading(false);
    }
  }

  // Cargar mis citas
  Future<void> loadMyAppointments() async {
    _setLoading(true);
    try {
      _myAppointments = await _appointmentRepo.getAppointments();

      final now = DateTime.now();
      _upcomingAppointments = _myAppointments
          .where((a) =>
      a.appointmentDate.isAfter(now) &&
          a.status != 'CANCELLED' &&
          a.status != 'NO_SHOW')
          .toList()
        ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

      _historyAppointments = _myAppointments
          .where((a) =>
      a.appointmentDate.isBefore(now) ||
          a.status == 'CANCELLED' ||
          a.status == 'NO_SHOW')
          .toList()
        ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

      _notify();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ============ ACCIONES ============

  // Crear cita
  Future<Appointment?> createAppointment() async {
    if (_selectedBarbershop == null ||
        _selectedService == null ||
        _selectedBarber == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      _setError('Faltan datos para crear la cita');
      return null;
    }

    _setLoading(true);
    try {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final appointment = await _appointmentRepo.createAppointment(
        barbershopId: _selectedBarbershop!.id,
        clientId: _currentClientId,
        barberId: _selectedBarber!.id,
        date: dateTime,
        serviceIds: [_selectedService!.id],
        paymentMethod: _paymentMethod,
      );

      _myAppointments.add(appointment);
      _updateAppointmentsLists();
      _notify();

      // Limpiar selección después de crear
      _clearSelection();

      return appointment;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Cancelar cita
  Future<bool> cancelAppointment(int id, {String? reason}) async {
    _setLoading(true);
    try {
      final cancelled = await _appointmentRepo.cancelAppointment(id, reason: reason);

      final index = _myAppointments.indexWhere((a) => a.id == id);
      if (index != -1) {
        _myAppointments[index] = cancelled;
        _updateAppointmentsLists();
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

  // ============ MÉTODOS AUXILIARES ============

  void _updateAppointmentsLists() {
    final now = DateTime.now();
    _upcomingAppointments = _myAppointments
        .where((a) =>
    a.appointmentDate.isAfter(now) &&
        a.status != 'CANCELLED' &&
        a.status != 'NO_SHOW')
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    _historyAppointments = _myAppointments
        .where((a) =>
    a.appointmentDate.isBefore(now) ||
        a.status == 'CANCELLED' ||
        a.status == 'NO_SHOW')
        .toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  void _clearSelection() {
    _selectedBarbershop = null;
    _selectedService = null;
    _selectedBarber = null;
    _selectedDate = null;
    _selectedTime = null;
    _availableServices = [];
    _availableBarbers = [];
    _availableSlots = [];
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

  void reset() {
    _clearSelection();
    _myAppointments = [];
    _upcomingAppointments = [];
    _historyAppointments = [];
    _availableSlots = [];
    _isLoading = false;
    _error = null;
    _notify();
  }

  // ============ UTILIDADES ============

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'es').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  bool isAppointmentCancelable(Appointment appointment) {
    final now = DateTime.now();
    final diff = appointment.appointmentDate.difference(now);
    return diff.inHours >= 24 &&
        appointment.status != 'CANCELLED' &&
        appointment.status != 'COMPLETED' &&
        appointment.status != 'NO_SHOW';
  }
}