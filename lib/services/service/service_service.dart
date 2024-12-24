import 'dart:convert';
import 'package:e_commerce/models/service/create_service_model.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/services/authentication/auth_servcies.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;

class ServiceService {
  Map<String, String> _generateHeaders({String? accessToken}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

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

// Create a service
  Future<CreateService?> createService(CreateService serviceData) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");

    final url = Uri.parse('${Constants.baseUrl}${Constants.userApiService}/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(serviceData.toJson()),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == true) {
        return CreateService.fromJson(responseBody['data']['data'][0]);
      } else {
        // Handle server error messages
        throw Exception(responseBody['message'] ?? 'Failed to create service.');
      }
    } catch (e) {
      throw Exception('Failed to create service: ${e.toString()}');
    }
  }

// Upload service cover photo
  Future<CreateService?> uploadServiceCoverPhoto(
      String imagePath, String serviceId) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");

    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.userApiService}/cover-photo/$serviceId');

    try {
      final request = http.MultipartRequest('PATCH', url)
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..files
            .add(await http.MultipartFile.fromPath('cover_photo', imagePath));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final responseBody = json.decode(responseData.body);
      print("Response from uploading a image ${responseBody}");
      if (response.statusCode == 200 && responseBody['success'] == true) {
        return CreateService.fromJson(responseBody['data'][0]);
      } else {
        // Handle server error messages
        throw Exception(
            responseBody['message'] ?? 'Failed to upload cover photo.');
      }
    } catch (e) {
      throw Exception('Failed to upload cover photo: ${e.toString()}');
    }
  }

  Future<bool> deleteService(String serviceId) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");

    final url =
        Uri.parse('${Constants.baseUrl}${Constants.userApiService}/$serviceId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return true;
        } else {
          throw Exception('Failed to delete service: ${data['message']}');
        }
      } else {
        throw Exception('Failed to delete service: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  Future<Map<String, dynamic>> updateService(
      String serviceId, Map<String, dynamic> serviceData) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    try {
      final url = Uri.parse(
          '${Constants.baseUrl}${Constants.userApiService}/$serviceId'); // Backend API endpoint
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(serviceData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Successful response
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      throw Exception("Failed to update service: $e");
    }
  }

  Future<List<ServiceModel>> fetchMyServices() async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    try {
      // Create headers with the access token
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Send the GET request with headers
      final response = await http.get(
        Uri.parse("${Constants.baseUrl}${Constants.userApiService}/myServices"),
        headers: headers,
      );

      // Check response status code
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data
            .map((service) => ServiceModel.fromJsonGetMyServices(service))
            .toList();
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }
}
