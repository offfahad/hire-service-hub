import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/repository/orders/orders_repository.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> bookOrder(Order order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _orderRepository.bookOrder(order);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
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
}
