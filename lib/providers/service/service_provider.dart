import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/repository/service/service_repository.dart';
import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceRepository serviceRepository = ServiceRepository();

  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _errorMessage = '';

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? _errorMessageForServiceDetails = '';
  String? get errorMessageForServiceDetails => _errorMessageForServiceDetails;

  List<String> _cityNames = [];
  List<String> get cityNames => _cityNames;

  Future<void> fetchServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _services = await serviceRepository.getServices();
      _cityNames = _services.map((service) => service.city).toSet().toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  FetchSingleService? _service;
  FetchSingleService? get service => _service;

  Future<void> fetchSingleServiceDetail(String serviceId) async {
    _isLoading = true;
    _errorMessageForServiceDetails = null;
    notifyListeners();

    final result = await serviceRepository.getService(serviceId);

    if (result != null) {
      _service = result;
    } else {
      _errorMessageForServiceDetails = "Failed to fetch the service.";
    }

    _isLoading = false;
    notifyListeners();
  }

  final List<FetchSingleService> _cartList = [];
  List<FetchSingleService> get cartList => _cartList;
// Add to Cart
  bool addToCart(String serviceId) {
    // Ensure service is not null and the specific service ID matches
    if (service?.data?.specificService?.id == serviceId) {
      // Check if the service is already in the cart
      if (_cartList
          .any((item) => item.data?.specificService?.id == serviceId)) {
        return false; // Service already in the cart
      } else {
        _cartList.add(service!);
        notifyListeners();
        return true; // Successfully added to the cart
      }
    }
    return false; // Service ID does not match
  }

// Remove from Cart
  void removeFromCart(String serviceId) {
    // Remove the service from the cart by matching the ID
    _cartList
        .removeWhere((item) => item.data?.specificService?.id == serviceId);
    notifyListeners();
  }

  void clearCart() {
    _cartList.clear();
    notifyListeners();
  }

  List<ServiceModel> _filterServices = [];

  List<ServiceModel> get filterServices => _filterServices;

// Fetch services based on filters
  Future<void> fetchFilterServices({
    String? categoryId,
    String? city,
    String? price,
    bool? priceHightToLow,
    bool? priceLowToHigh,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _filterServices = await serviceRepository.getFilterServices(
        categoryId: categoryId,
        city: city,
        priceHightToLow: priceHightToLow,
        priceLowToHigh: priceLowToHigh,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
