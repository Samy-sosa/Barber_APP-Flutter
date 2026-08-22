// lib/services/auth_service.dart

import 'dart:convert';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/storage_service.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/register_request.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<AuthResponse?> login(String email, String password) async {
    try {
      print('📱 Iniciando login...');

      final response = await _apiClient.post(
        ApiEndpoints.login,
        {'email': email, 'password': password},
        isAuthRequired: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Login exitoso');
        final authData = AuthResponse.fromJson(data);
        await _storageService.saveToken(authData.token);
        return authData;
      } else {
        print('❌ Error en login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción en login: $e');
      return null;
    }
  }

  Future<AuthResponse?> register(RegisterRequest request) async {
    try {
      print('📱 Iniciando registro...');

      final response = await _apiClient.post(
        ApiEndpoints.register,
        request.toJson(),
        isAuthRequired: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Registro exitoso');
        final authData = AuthResponse.fromJson(data);
        await _storageService.saveToken(authData.token);
        return authData;
      } else {
        print('❌ Error en registro: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción en registro: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null;
  }
}