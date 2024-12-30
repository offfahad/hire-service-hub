import 'dart:convert';

import 'package:e_commerce/models/orders/create_order_model.dart';
import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/repository/orders/orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

      try {
        // Attempt to extract the JSON message
        final errorJson = RegExp(r'\{.*\}').stringMatch(e.toString());
        if (errorJson != null) {
          final Map<String, dynamic> errorMap = json.decode(errorJson);
          _errorMessage = errorMap['message'] ?? 'An unknown error occurred';
        } else {
          _errorMessage = 'An unknown error occurred';
        }
      } catch (parseError) {
        // If JSON parsing fails, fallback to a default message
        _errorMessage = 'An error occurred: ${e.toString()}';
      }

      // Debug log for further inspection
      print('Error: $_errorMessage');

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

  void clearOrders() {
    _orders = null;
    notifyListeners();
  }

  Future<http.Response> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call the repository method to cancel the order
      final results = await _orderRepository.cancelOrder(
        orderId: orderId,
        cancellationReason: cancellationReason,
      );

      // Decode the response to check for errors
      final responseData = jsonDecode(results.body);

      if (results.statusCode == 200) {
        // Success: Handle the decoded response if needed
        print("Order canceled successfully: ${responseData['message']}");
      } else {
        // Error: Handle server errors
        _errorMessage = responseData['message'] ?? 'An error occurred';
        print("Error: $_errorMessage");
      }

      return results; // Return the response for further handling
    } catch (e) {
      // Catch network or other unexpected errors
      _errorMessage = "An error occurred: $e";
      print("Exception: $_errorMessage");
      rethrow; // Optionally rethrow the error to let the caller handle it
    } finally {
      // Reset loading state
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> updateOrder({
    required String orderId,
    required String orderDate,
    required String additionalNotes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _orderRepository.updateOrder(
        orderId: orderId,
        orderDate: orderDate,
        additionalNotes: additionalNotes,
      );

      _isLoading = false;
      notifyListeners();
      return response; // Return the raw response
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  String? orderMessageResponse;

  Future<http.Response?> acceptOrder(String orderId) async {
    _isLoading = true;
    orderMessageResponse = null;
    try {
      final response = await _orderRepository.acceptOrder(orderId);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      orderMessageResponse = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<http.Response?> rejectOrder(String orderId) async {
    _isLoading = true;
    orderMessageResponse = null;
    try {
      final response = await _orderRepository.rejectOrder(orderId);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      orderMessageResponse = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<http.Response?> completeOrder(String orderId) async {
    _isLoading = true;
    orderMessageResponse = null;
    try {
      final response = await _orderRepository.completeOrder(orderId);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      orderMessageResponse = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  String _selectedFilter = "All";

  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
