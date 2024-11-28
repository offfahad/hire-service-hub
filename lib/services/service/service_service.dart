import 'dart:convert';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;

class ServiceService {
  Future<List<ServiceModel>> fetchServices() async {
    try {
      final response = await http
          .get(Uri.parse("${Constants.baseUrl}${Constants.userApiService}"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((service) => ServiceModel.fromJson(service)).toList();
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }
}
