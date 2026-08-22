// lib/core/network/api_endpoints.dart

import 'dart:io';

class ApiEndpoints {
  static String get baseUrl {
    if (Platform.isAndroid) {
      // 🔥 Usa la IP de tu laptop (la que encontraste con ipconfig)
      return 'http://192.168.100.10:8080/api'; // ← PUERTO 8080 AGREGADO
    }
    return 'http://localhost:8080/api';
  }

  // Auth
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';

  // Core
  static String get barbershops => '$baseUrl/barbershops';
  static String get barbers => '$baseUrl/barbers';
  static String get services => '$baseUrl/services';
  static String get schedules => '$baseUrl/schedules';

  // Appointments & Availability
  static String get appointments => '$baseUrl/appointments';
  static String get availability => '$baseUrl/availability';

  // Plans & Subscriptions
  static String get plans => '$baseUrl/plans';
  static String get subscriptions => '$baseUrl/subscriptions';

  // Mercado Pago
  static String mercadoPagoStatus(int barbershopId) => '$baseUrl/mercadopago/status/$barbershopId';
  static String mercadoPagoDisconnect(int barbershopId) => '$baseUrl/mercadopago/disconnect/$barbershopId';
}