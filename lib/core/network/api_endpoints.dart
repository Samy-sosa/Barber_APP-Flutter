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

  // ============ AUTH ============
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';

  // ============ BARBERSHOPS ============
  static String get barbershops => '$baseUrl/barbershops';
  static String barbershopDetail(int id) => '$baseUrl/barbershops/$id';
  static String barbershopLogo(int id) => '$baseUrl/barbershops/$id/logo';
  static String barbershopBanner(int id) => '$baseUrl/barbershops/$id/banner';
  static String barbershopMetrics(int id) => '$baseUrl/barbershops/$id/metrics';
  static String barbershopStats(int id) => '$baseUrl/barbershops/$id/stats';

  // ============ BARBERS ============
  static String get barbers => '$baseUrl/barbers';
  static String barberDetail(int id) => '$baseUrl/barbers/$id';
  static String barberPhoto(int id) => '$baseUrl/barbers/$id/photo';
  static String barberToggle(int id) => '$baseUrl/barbers/$id/toggle';

  // ============ SERVICES ============
  static String get services => '$baseUrl/services';
  static String serviceDetail(int id) => '$baseUrl/services/$id';
  static String servicePhoto(int id) => '$baseUrl/services/$id/photo';

  // ============ SCHEDULES ============
  static String get schedules => '$baseUrl/schedules';
  static String scheduleDetail(int id) => '$baseUrl/schedules/$id';

  // ============ APPOINTMENTS ============
  static String get appointments => '$baseUrl/appointments';
  static String appointmentDetail(int id) => '$baseUrl/appointments/$id';
  static String appointmentCancel(int id) => '$baseUrl/appointments/$id/cancel';
  static String appointmentConfirm(int id) => '$baseUrl/appointments/$id/confirm';
  static String appointmentComplete(int id) => '$baseUrl/appointments/$id/complete';

  // ============ AVAILABILITY ============
  static String get availability => '$baseUrl/availability';

  // ============ PLANS & SUBSCRIPTIONS ============
  static String get plans => '$baseUrl/plans';
  static String get subscriptions => '$baseUrl/subscriptions';

  // ============ MERCADO PAGO ============
  static String mercadoPagoStatus(int barbershopId) => '$baseUrl/mercadopago/status/$barbershopId';
  static String mercadoPagoDisconnect(int barbershopId) => '$baseUrl/mercadopago/disconnect/$barbershopId';
  static String get mercadoPagoConnect => '$baseUrl/mercadopago/connect';
  static String get mercadoPagoAuthUrl => '$baseUrl/mercadopago/auth-url';
  static String get mercadoPagoCallback => '$baseUrl/mercadopago/callback';

  // ============ ADMIN ============
  static String get adminMetrics => '$baseUrl/admin/metrics';
  static String get adminUsers => '$baseUrl/admin/users';
  static String adminUserDetail(int id) => '$baseUrl/admin/users/$id';
  static String adminUserRole(int id) => '$baseUrl/admin/users/$id/role';
  static String adminUserToggle(int id) => '$baseUrl/admin/users/$id/toggle';
  static String get adminSubscriptionsExpiring => '$baseUrl/admin/subscriptions/expiring';
  static String get adminPayments => '$baseUrl/admin/payments';
  static String get adminRevenue => '$baseUrl/admin/revenue';
  static String get adminBarbershopsStats => '$baseUrl/admin/barbershops';
  static String serviceToggle(int id) => '/api/services/$id/toggle';

  // ============ NOTIFICATIONS ============
  static String get notifications => '$baseUrl/notifications';
  static String notificationRead(int id) => '$baseUrl/notifications/$id/read';
  static String get notificationsReadAll => '$baseUrl/notifications/read-all';
  static String get notificationsRegisterToken => '$baseUrl/notifications/register-token';
  static String get notificationsUnregisterToken => '$baseUrl/notifications/unregister-token';

  // ============ RATINGS ============
  static String ratingsBarbershop(int id) => '$baseUrl/ratings/barbershop/$id';
  static String ratingsBarbershopSummary(int id) => '$baseUrl/ratings/barbershop/$id/summary';
  static String ratingsBarber(int id) => '$baseUrl/ratings/barber/$id';
  static String ratingsDetail(int id) => '$baseUrl/ratings/$id';
}