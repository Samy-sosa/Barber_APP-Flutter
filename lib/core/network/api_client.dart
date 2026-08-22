// lib/core/network/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage_service.dart';

class ApiClient {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders({bool isAuthRequired = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (isAuthRequired) {
      final token = await _storageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(String url, {bool isAuthRequired = true}) async {
    print('📱 GET: $url');
    final headers = await _getHeaders(isAuthRequired: isAuthRequired);
    final response = await http.get(Uri.parse(url), headers: headers);
    print('📱 GET Status: ${response.statusCode}');
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> body, {bool isAuthRequired = true}) async {
    print('📱 POST: $url');
    print('📱 Body: $body');

    final headers = await _getHeaders(isAuthRequired: isAuthRequired);
    print('📱 Headers: $headers');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15));

    print('📱 POST Status: ${response.statusCode}');
    print('📱 POST Response: ${response.body}');
    return response;
  }

  Future<http.Response> put(String url, Map<String, dynamic> body, {bool isAuthRequired = true}) async {
    print('📱 PUT: $url');
    final headers = await _getHeaders(isAuthRequired: isAuthRequired);
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    print('📱 PUT Status: ${response.statusCode}');
    return response;
  }

  Future<http.Response> delete(String url, {bool isAuthRequired = true}) async {
    print('📱 DELETE: $url');
    final headers = await _getHeaders(isAuthRequired: isAuthRequired);
    final response = await http.delete(Uri.parse(url), headers: headers);
    print('📱 DELETE Status: ${response.statusCode}');
    return response;
  }
}