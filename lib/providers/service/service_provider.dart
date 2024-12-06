import 'package:e_commerce/models/service/create_service_model.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/repository/service/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceRepository serviceRepository = ServiceRepository();

  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _errorMessage = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? _errorMessageForServiceDetails = '';
  String? get errorMessageForServiceDetails => _errorMessageForServiceDetails;

  List<String> _cityNames = [];
  List<String> get cityNames => _cityNames;

  bool _isFilterApplied = false;
  List<ServiceModel> get services =>
      _isFilterApplied ? _filterServices : _services;

  bool get isFilterApplied => _isFilterApplied;

  Future<void> fetchServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _services = await serviceRepository.getServices();
      _cityNames = _services.map((service) => service.city).toSet().toList();
      _isFilterApplied = false;
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
    String? priceRangetype,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _filterServices = await serviceRepository.getFilterServices(
        categoryId: categoryId,
        city: city,
        priceRangeType: priceRangetype,
      );
      _isFilterApplied = _filterServices
          .isNotEmpty; // Enable filtered view only if data exists
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _isFilterApplied = false;
    _filterServices = [];
    notifyListeners();
  }

  void clearServicesList() {
    _services = [];
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  XFile? _coverPhoto;
  String _selectedCategory = '';
  bool _isAvailable = false;

  XFile? get coverPhoto => _coverPhoto;
  String get selectedCategory => _selectedCategory;
  bool get isAvailable => _isAvailable;

  void setCoverPhoto(XFile photo) {
    _coverPhoto = photo;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleAvailability(bool value) {
    _isAvailable = value;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  CreateService? _createService;
  CreateService get createService => _createService!;

  Future<void> createServiceWithCoverPhoto(
      CreateService serviceData, String imagePath) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = await serviceRepository.createServiceWithCoverPhoto(
          serviceData, imagePath);

      if (success) {
        // Update state if needed
        _createService = serviceData;
      } else {
        _errorMessage = "Failed to create service with cover photo.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
