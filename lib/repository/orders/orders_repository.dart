import 'dart:convert';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/services/orders/orders_service.dart';

class OrderRepository {
  final OrderService _orderService = OrderService();
  Future<Order?> bookOrder(Order order) async {
    final response = await _orderService.bookOrder(order);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Order.fromJson(data); // Convert API response to an Order object
    } else {
      throw Exception("Failed to book order: ${response.body}");
    }
  }
}
