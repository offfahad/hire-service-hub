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

  Future<void> fetchServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _services = await serviceRepository.getServices();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
