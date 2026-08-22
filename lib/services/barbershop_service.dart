import 'dart:convert';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/barbershop/barbershop_response.dart';

class BarbershopService {
  final ApiClient _apiClient = ApiClient();

  Future<List<BarbershopResponse>> getBarbershops() async {
    final response = await _apiClient.get(ApiEndpoints.barbershops, isAuthRequired: false);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => BarbershopResponse.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar barberías');
    }
  }
}