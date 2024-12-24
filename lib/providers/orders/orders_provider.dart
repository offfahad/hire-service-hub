import 'package:e_commerce/models/orders/create_order_model.dart';
import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/repository/orders/orders_repository.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  bool _isLoading = false;
  String? _errorMessage;

  CreateOrderResponse? _createOrderResponse;
  CreateOrderResponse? get createOrderResponse => _createOrderResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<CreateOrderResponse?> bookOrder(Order order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _createOrderResponse = await _orderRepository.bookOrder(order);
      _isLoading = false;
      notifyListeners();
      return _createOrderResponse;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  GetMyOrders? _orders;
  GetMyOrders? get orders => _orders;

  Future<void> fetchMyOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderRepository.fetchOrders();
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _cancelOrderResponse;

  Future<void> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cancelOrderResponse = await _orderRepository.cancelOrder(
        orderId: orderId,
        cancellationReason: cancellationReason,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
