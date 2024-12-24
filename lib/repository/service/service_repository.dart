import 'package:e_commerce/models/service/create_service_model.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/services/service/service_service.dart';

class ServiceRepository {
  final ServiceService serviceService = ServiceService();

  Future<List<ServiceModel>> getServices() async {
    return await serviceService.fetchServices();
  }

  Future<FetchSingleService?> getService(String serviceId) async {
    return await serviceService.fetchSingleService(serviceId);
  }

  Future<List<ServiceModel>> getFilterServices({
    String? categoryId,
    String? city,
    String? priceRangeType,
  }) async {
    return await serviceService.fetchFilteredServices(
      categoryId: categoryId,
      city: city,
      priceRangeType: priceRangeType,
    );
  }

  Future<CreateService?> createService(CreateService serviceData) async {
    return await serviceService.createService(serviceData);
  }

  Future<CreateService?> uploadServiceCoverPhoto(
      String imagePath, String serviceId) async {
    return await serviceService.uploadServiceCoverPhoto(imagePath, serviceId);
  }

  Future<CreateService?> createServiceWithCoverPhoto(
      CreateService serviceData, String imagePath) async {
    try {
      final service = await createService(serviceData);
      if (service?.id != null) {
        return await uploadServiceCoverPhoto(imagePath, service!.id!);
      } else {
        throw Exception('Service creation failed.');
      }
    } catch (e) {
      throw Exception(
          'Failed to create service with cover photo: ${e.toString()}');
    }
  }

  Future<bool> deleteService(String serviceId) async {
    return await serviceService.deleteService(serviceId);
  }

  Future<Map<String, dynamic>> updateService(
      String serviceId, Map<String, dynamic> serviceData) async {
    return await serviceService.updateService(serviceId, serviceData);
  }

  Future<List<ServiceModel>> getMyServices() async {
    return await serviceService.fetchMyServices();
  }
}
