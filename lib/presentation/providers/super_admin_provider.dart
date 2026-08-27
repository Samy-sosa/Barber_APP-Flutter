// lib/presentation/providers/super_admin_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/core/network/api_client.dart';
import 'package:barberapp_yucatan/core/network/api_endpoints.dart';

class SuperAdminProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? _metrics;
  List<Map<String, dynamic>> _barbershops = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get metrics => _metrics;
  List<Map<String, dynamic>> get barbershops => _barbershops;

  // ============ CARGAR METRICAS GLOBALES ============
  Future<void> loadMetrics() async {
    _setLoading(true);
    try {
      final response = await _apiClient.get(ApiEndpoints.adminMetrics);

      if (response.statusCode == 200) {
        _metrics = jsonDecode(response.body);
        _notify();
      } else {
        _setError('Error al cargar metricas: ${response.statusCode}');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ============ CARGAR BARBERIAS (PARA SUPER ADMIN) ============
  Future<void> loadBarbershops() async {
    _setLoading(true);
    try {
      final response = await _apiClient.get(ApiEndpoints.adminBarbershopsStats);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _barbershops = data.map((e) => e as Map<String, dynamic>).toList();
        _notify();
      } else {
        _setError('Error al cargar barberias: ${response.statusCode}');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ============ CARGAR TODOS LOS DATOS ============
  Future<void> loadAllData() async {
    await Future.wait([
      loadMetrics(),
      loadBarbershops(),
    ]);
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
    _metrics = null;
    _barbershops = [];
    _isLoading = false;
    _error = null;
    _notify();
  }
}