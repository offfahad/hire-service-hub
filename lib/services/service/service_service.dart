import 'dart:convert';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
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

  Future<FetchSingleService?> fetchSingleService(String serviceId) async {
    final url =
        Uri.parse("${Constants.baseUrl}${Constants.userApiService}/$serviceId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return fetchSingleServiceFromJson(response.body);
      } else {
        print("Failed to fetch service: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching service: $e");
      return null;
    }
  }

  // Fetch services based on selected filters
  Future<List<ServiceModel>> fetchFilteredServices({
    String? categoryId,
    String? city,
    String? priceRangeType,
  }) async {
    // Build query parameters based on selected filters
    final filters = <String, String>{};
    if (categoryId != null) filters['category_id'] = categoryId;
    if (city != null) filters['city'] = city;
    // Add only the selected price range type to the filters
    if (priceRangeType == "High To Low") {
      filters['PHTL'] = "true";
    } else if (priceRangeType == "Low To High") {
      filters['PLTH'] = "true";
    }
    // Build the final URL with query parameters
    final uri =
        Uri.parse("${Constants.baseUrl}${Constants.userApiService}/filter")
            .replace(queryParameters: filters);
    try {
      final response = await http.get(uri);
      //print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((service) => ServiceModel.fromJson(service)).toList();
      } else {
        throw Exception('Failed to load filter services');
      }
    } catch (e) {
      throw Exception('Failed to load filter services: $e');
    }
  }
}
