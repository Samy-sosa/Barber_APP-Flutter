// lib/presentation/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/core/utils/storage_service.dart';
import 'package:barberapp_yucatan/services/auth_service.dart';
import 'package:barberapp_yucatan/models/auth/auth_response.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  String? _userName;
  String? _userEmail;
  String? _userRole;
  int? _userId;
  int? _barbershopId;
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole;
  int? get userId => _userId;
  int? get barbershopId => _barbershopId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        _isAuthenticated = true;
        _userRole = await _storage.getUserRole();
        _userId = await _storage.getUserId();
        _userName = await _storage.getUserName();
        _userEmail = await _storage.getUserEmail();
        _barbershopId = await _storage.getBarbershopId();
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final AuthResponse? response = await _authService.login(email, password);

      if (response != null) {
        // Guardar token y datos del usuario
        await _storage.saveToken(response.token);
        await _storage.saveUser({
          'id': response.userId,
          'name': response.name,
          'email': response.email,
          'role': response.role,
          'barbershopId': response.barbershopId, // Si existe en tu AuthResponse
        });

        _isAuthenticated = true;
        _userName = response.name;
        _userEmail = response.email;
        _userRole = response.role;
        _userId = response.userId;
        _barbershopId = response.barbershopId;

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Credenciales incorrectas';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _storage.clearAll();

    _isAuthenticated = false;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    _userId = null;
    _barbershopId = null;
    _isLoading = false;

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}