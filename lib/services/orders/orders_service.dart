import 'dart:convert';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/services/authentication/auth_servcies.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<http.Response> bookOrder(Order order) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");

    final url =
        Uri.parse("${Constants.baseUrl}${Constants.userApiBookingOrder}/");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(order.toJson()),
      );

      return response; // Pass the response back to the repo
    } catch (e) {
      throw Exception("Failed to book order: $e");
    }
  }

  Future<http.Response> getMyOrders() async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");

    try {
      final response = await http.get(
        Uri.parse("${Constants.baseUrl}${Constants.userApiBookingOrder}/"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<Map<String, dynamic>> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.userApiBookingOrder}/cancel/$orderId');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({'cancellation_reason': cancellationReason}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Success response
      } else {
        // Parse and throw error message
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Re-throw error to the provider
      throw Exception(e.toString());
    }
  }
}
