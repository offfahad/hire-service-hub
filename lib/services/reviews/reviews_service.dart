import 'dart:convert';
import 'package:e_commerce/services/authentication/auth_servcies.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  Future<http.Response> createReview({
    required String orderId,
    required String serviceId,
    required String reviewMessage,
    required double rating,
  }) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    final url = Uri.parse('${Constants.baseUrl}/api/review');
    print(url);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Replace with your token logic
      },
      body: jsonEncode({
        'order_id': orderId,
        'service_id': serviceId,
        'review_message': reviewMessage,
        'rating': rating,
      }),
    );
    print(response.body);
    return response;
  }

  Future<http.Response> deleteReview(String reviewId) async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) throw Exception("Access token is missing.");
    final url = Uri.parse('${Constants.baseUrl}/api/review/$reviewId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Replace with your token logic
      },
    );
    print(response.body);
    return response;
  }
}
