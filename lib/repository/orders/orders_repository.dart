import 'dart:convert';
import 'package:e_commerce/models/orders/create_order_model.dart';
import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/services/orders/orders_service.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  final OrderService _orderService = OrderService();

  Future<CreateOrderResponse?> bookOrder(Order order) async {
    try {
      final response = await _orderService.bookOrder(order);

      if (response.statusCode == 200) {
        // Parse response body to extract the nested "data" object
        return CreateOrderResponse.fromMap(json.decode(response.body));
      } else {
        throw Exception("Failed to book order: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred while booking the order: $e");
    }
  }

  Future<GetMyOrders?> fetchOrders() async {
    final response = await _orderService.getMyOrders();
    if (response.statusCode == 200) {
      return GetMyOrders.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch orders: ${response.body}");
    }
  }

  Future<http.Response> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) {
    return _orderService.cancelOrder(
      orderId: orderId,
      cancellationReason: cancellationReason,
    );
  }

  Future<http.Response> updateOrder({
    required String orderId,
    required String orderDate,
    required String additionalNotes,
  }) {
    return _orderService.updateOrder(
      orderId: orderId,
      orderDate: orderDate,
      additionalNotes: additionalNotes,
    );
  }

  Future<http.Response> acceptOrder(String orderId) {
    return _orderService.updateOrderStatus(
      orderId: orderId,
      orderStatus: "processing",
    );
  }

  Future<http.Response> rejectOrder(String orderId) {
    return _orderService.updateOrderStatus(
      orderId: orderId,
      orderStatus: "cancelled",
    );
  }

  Future<http.Response> completeOrder(String orderId) {
    return _orderService.updateOrderStatus(
      orderId: orderId,
      orderStatus: "completed",
    );
  }
}
