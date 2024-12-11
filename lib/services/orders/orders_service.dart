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
}
