// lib/models/appointment/appointment.dart

import 'package:flutter/material.dart';

class Appointment {
  final int id;
  final int clientId;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final int barberId;
  final String barberName;
  final int barbershopId;
  final String barbershopName;
  final int serviceId;
  final String serviceName;
  final double servicePrice;
  final int serviceDuration;
  final DateTime appointmentDate;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final bool isActive;

  Appointment({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientEmail,
    this.clientPhone,
    required this.barberId,
    required this.barberName,
    required this.barbershopId,
    required this.barbershopName,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDuration,
    required this.appointmentDate,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.isActive = true,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? 0,
      clientId: json['clientId'] ?? 0,
      clientName: json['clientName'] ?? '',
      clientEmail: json['clientEmail'],
      clientPhone: json['clientPhone'],
      barberId: json['barberId'] ?? 0,
      barberName: json['barberName'] ?? '',
      barbershopId: json['barbershopId'] ?? 0,
      barbershopName: json['barbershopName'] ?? '',
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'] ?? '',
      servicePrice: (json['servicePrice'] ?? 0).toDouble(),
      serviceDuration: json['serviceDuration'] ?? 0,
      appointmentDate: DateTime.parse(json['appointmentDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'PENDING',
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      cancellationReason: json['cancellationReason'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'barberId': barberId,
      'barberName': barberName,
      'barbershopId': barbershopId,
      'barbershopName': barbershopName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'serviceDuration': serviceDuration,
      'appointmentDate': appointmentDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'isActive': isActive,
    };
  }

  // ============ METODOS UTILES ============

  String get statusDisplay {
    switch (status) {
      case 'PENDING':
        return 'Pendiente';
      case 'CONFIRMED':
        return 'Confirmada';
      case 'COMPLETED':
        return 'Completada';
      case 'CANCELLED':
        return 'Cancelada';
      case 'NO_SHOW':
        return 'No Asistió';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'NO_SHOW':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = appointmentDate.difference(now);

    if (diff.inDays == 0) {
      return 'Hoy ${_formatTime(appointmentDate)}';
    } else if (diff.inDays == 1) {
      return 'Mañana ${_formatTime(appointmentDate)}';
    } else if (diff.inDays < 7) {
      final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      return '${days[appointmentDate.weekday - 1]} ${_formatTime(appointmentDate)}';
    } else {
      return '${appointmentDate.day}/${appointmentDate.month} ${_formatTime(appointmentDate)}';
    }
  }

  String get formattedTime {
    return _formatTime(appointmentDate);
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get isPending => status == 'PENDING';
  bool get isConfirmed => status == 'CONFIRMED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';
  bool get isNoShow => status == 'NO_SHOW';
  bool get isActiveAppointment => isPending || isConfirmed;
}