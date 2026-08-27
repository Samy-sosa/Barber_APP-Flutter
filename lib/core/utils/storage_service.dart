// lib/core/utils/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // ✅ NUEVAS CLAVES PARA DATOS DEL USUARIO
  static const String _userRoleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _barbershopIdKey = 'barbershop_id';

  // ============ TOKEN ============
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      print('✅ Token guardado');
    } catch (e) {
      print('❌ Error guardando token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('❌ Error obteniendo token: $e');
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      print('✅ Token eliminado');
    } catch (e) {
      print('❌ Error eliminando token: $e');
    }
  }

  // ============ USUARIO (ACTUALIZADO) ============
  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar datos individuales
      await prefs.setString(_userKey, user.toString());
      await prefs.setString(_userRoleKey, user['role'] ?? 'CLIENT');
      await prefs.setString(_userIdKey, user['id']?.toString() ?? '');
      await prefs.setString(_userNameKey, user['name'] ?? '');
      await prefs.setString(_userEmailKey, user['email'] ?? '');
      await prefs.setString(_barbershopIdKey, user['barbershopId']?.toString() ?? '');

      print('✅ Usuario guardado');
    } catch (e) {
      print('❌ Error guardando usuario: $e');
    }
  }

  // ✅ NUEVO: Obtener rol del usuario
  Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (e) {
      print('❌ Error obteniendo rol: $e');
      return null;
    }
  }

  // ✅ NUEVO: Obtener ID del usuario
  Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_userIdKey);
      return id != null && id.isNotEmpty ? int.tryParse(id) : null;
    } catch (e) {
      print('❌ Error obteniendo ID: $e');
      return null;
    }
  }

  // ✅ NUEVO: Obtener nombre del usuario
  Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey);
    } catch (e) {
      print('❌ Error obteniendo nombre: $e');
      return null;
    }
  }

  // ✅ NUEVO: Obtener email del usuario
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      print('❌ Error obteniendo email: $e');
      return null;
    }
  }

  // ✅ NUEVO: Obtener ID de la barbería
  Future<int?> getBarbershopId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_barbershopIdKey);
      return id != null && id.isNotEmpty ? int.tryParse(id) : null;
    } catch (e) {
      print('❌ Error obteniendo barbershopId: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      if (userData != null) {
        return {};
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      return null;
    }
  }

  Future<void> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_userRoleKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_barbershopIdKey);
      print('✅ Usuario eliminado');
    } catch (e) {
      print('❌ Error eliminando usuario: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('✅ Todos los datos eliminados');
    } catch (e) {
      print('❌ Error limpiando datos: $e');
    }
  }
}