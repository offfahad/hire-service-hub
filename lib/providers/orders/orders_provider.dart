import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/repository/orders/orders_repository.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository;
  bool _isLoading = false;
  String? _errorMessage;

  OrderProvider(this._orderRepository);

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
}
