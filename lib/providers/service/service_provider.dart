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
  List<ServiceModel> get services => _services;
  bool _isLoading = false;
  String? _errorMessage = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? _errorMessageForServiceDetails = '';
  String? get errorMessageForServiceDetails => _errorMessageForServiceDetails;

  List<String> _cityNames = [];
  List<String> get cityNames => _cityNames;

  bool _isFilterApplied = false;
  List<ServiceModel> get filteredServices =>
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
// Service management
  Future<bool> createServiceWithCoverPhoto(
      CreateService serviceData, String imagePath) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      CreateService? result = await serviceRepository
          .createServiceWithCoverPhoto(serviceData, imagePath);

      if (result != null) {
        return true;
      } else {
        _errorMessage = "Failed to create service.";
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteService(String serviceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool isDeleted = await serviceRepository.deleteService(serviceId);
      if (isDeleted) {
        _services.removeWhere((service) => service.id == serviceId);
        _filterServices.removeWhere((service) => service.id == serviceId);
        notifyListeners();
      } else {
        _errorMessage = "Failed to delete service.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetCreateServiceValues() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    startTimeController.clear();
    endTimeController.clear();
    _coverPhoto = null;
    _selectedCategory = '';
    _isAvailable = false;
    notifyListeners();
  }
}
