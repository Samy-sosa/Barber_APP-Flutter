// lib/core/theme/colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ============ COLORES PRINCIPALES ============
  static const Color primary = Color(0xFFC9A84C);
  static const Color primaryDark = Color(0xFF8B7A3C);
  static const Color primaryLight = Color(0xFFE8D5A3);
  static const Color primaryBackground = Color(0xFFF5EDD6);

  // ============ COLORES SECUNDARIOS ============
  static const Color secondary = Color(0xFF1A1A1A);
  static const Color secondaryDark = Color(0xFF0A0A0A);
  static const Color secondaryLight = Color(0xFF2A2A2A);

  // ============ COLORES DE ESTADO ============
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);

  // ============ COLORES DE TEXTO ============
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xCCFFFFFF);
  static const Color textHint = Color(0x66FFFFFF);
  static const Color textBlack = Color(0xFF000000);

  // ============ COLORES DE FONDO ============
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color backgroundCard = Color(0xFF1A1A1A);
  static const Color backgroundInput = Color(0xFF2A2A2A);

  // ============ GRADIENTES ============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark, primary],
  );

  // ✅ CORREGIDO: Cambiado a LinearGradient con los colores correctos
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondaryLight, secondaryDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
  );

  // ============ SOMBRAS (con .withValues() en lugar de .withOpacity()) ============
  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.3),  // ✅ CORREGIDO
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 5,
    ),
    BoxShadow(
      color: primary.withValues(alpha: 0.15),  // ✅ CORREGIDO
      blurRadius: 40,
      offset: const Offset(0, 15),
      spreadRadius: 10,
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),  // ✅ CORREGIDO
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.4),  // ✅ CORREGIDO
      blurRadius: 30,
      spreadRadius: 5,
    ),
    BoxShadow(
      color: primary.withValues(alpha: 0.2),  // ✅ CORREGIDO
      blurRadius: 60,
      spreadRadius: 10,
    ),
  ];

  // ============ COLORES PARA BARBEROS ============
  static const Map<String, Color> barberColors = {
    'Corte': Color(0xFF4CAF50),
    'Barba': Color(0xFFFF9800),
    'Coloración': Color(0xFF9C27B0),
    'Tratamiento': Color(0xFF2196F3),
    'Cejas': Color(0xFF795548),
    'Otro': Color(0xFF607D8B),
  };

  // ============ COLORES PARA ESTADOS DE CITAS ============
  static const Map<String, Color> appointmentStatusColors = {
    'PENDING': Color(0xFFFF9800),
    'CONFIRMED': Color(0xFF2196F3),
    'COMPLETED': Color(0xFF4CAF50),
    'CANCELLED': Color(0xFFE53935),
    'NO_SHOW': Color(0xFF9E9E9E),
  };

  static const Map<String, String> appointmentStatusLabels = {
    'PENDING': 'Pendiente',
    'CONFIRMED': 'Confirmada',
    'COMPLETED': 'Completada',
    'CANCELLED': 'Cancelada',
    'NO_SHOW': 'No Asistió',
  };

  // ============ COLORES PARA ROLES ============
  static const Map<String, Color> roleColors = {
    'SUPER_ADMIN': Color(0xFFE53935),
    'TENANT_ADMIN': Color(0xFFC9A84C),
    'CLIENT': Color(0xFF2196F3),
  };
}