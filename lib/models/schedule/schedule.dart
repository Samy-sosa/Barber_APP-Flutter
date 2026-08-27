// lib/data/models/schedule/schedule.dart

class Schedule {
  final int id;
  final int barbershopId;
  final String barbershopName;
  final String dayOfWeek; // MONDAY, TUESDAY, etc.
  final String startTime;
  final String endTime;
  final String? breakStart;
  final String? breakEnd;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Schedule({
    required this.id,
    required this.barbershopId,
    required this.barbershopName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.breakStart,
    this.breakEnd,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? 0,
      barbershopId: json['barbershopId'] ?? 0,
      barbershopName: json['barbershopName'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      breakStart: json['breakStart'],
      breakEnd: json['breakEnd'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barbershopId': barbershopId,
      'barbershopName': barbershopName,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'breakStart': breakStart,
      'breakEnd': breakEnd,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get dayDisplay {
    final days = {
      'MONDAY': 'Lunes',
      'TUESDAY': 'Martes',
      'WEDNESDAY': 'Miércoles',
      'THURSDAY': 'Jueves',
      'FRIDAY': 'Viernes',
      'SATURDAY': 'Sábado',
      'SUNDAY': 'Domingo',
    };
    return days[dayOfWeek] ?? dayOfWeek;
  }

  String get timeDisplay {
    String display = '$startTime - $endTime';
    if (breakStart != null && breakEnd != null) {
      display += '\nDescanso: $breakStart - $breakEnd';
    }
    return display;
  }
}