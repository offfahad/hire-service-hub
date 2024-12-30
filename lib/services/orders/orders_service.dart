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

  Future<http.Response> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    final url = Uri.parse(
        "${Constants.baseUrl}${Constants.userApiBookingOrder}/cancel/$orderId");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Replace with actual token
    };

    final body = jsonEncode({
      "cancellation_reason": cancellationReason,
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);
      return response; // Response can be handled in the Provider
    } catch (e) {
      throw Exception("Failed to cancel order: $e");
    }
  }

  Future<http.Response> updateOrder({
    required String orderId,
    required String orderDate,
    required String additionalNotes,
  }) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    final url = Uri.parse(
        "${Constants.baseUrl}${Constants.userApiBookingOrder}/update/$orderId");
    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode({
          "order_date": orderDate,
          "additional_notes": additionalNotes,
        }),
      );
      return response; // Return the raw response
    } catch (e) {
      throw Exception("Failed to update order: $e");
    }
  }

  Future<http.Response> updateOrderStatus({
    required String orderId,
    required String orderStatus,
  }) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.userApiBookingOrder}/service-provider/$orderId');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    final body = jsonEncode({"order_status": orderStatus});

    try {
      final response = await http.patch(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception("Error updating order: $e");
    }
  }
}
